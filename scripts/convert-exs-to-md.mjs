#!/usr/bin/env node

/**
 * Converts Elixir .exs company files to Markdown with YAML frontmatter
 * for Astro content collections.
 */

import { readdir, readFile, writeFile, mkdir } from 'node:fs/promises';
import { join, basename, extname } from 'node:path';

const COMPANIES_DIR = join(import.meta.dirname, '..', 'priv', 'companies');
const OUTPUT_DIR = join(import.meta.dirname, '..', 'src', 'content', 'companies');

function parseExsFile(content, filename) {
  // Remove comments (lines starting with #)
  const lines = content.split('\n');
  const cleaned = lines.filter(l => !l.trimStart().startsWith('#')).join('\n');

  // Extract top-level map fields
  const company = {};

  // Extract name
  const nameMatch = cleaned.match(/name:\s*"([^"]*?)"/);
  if (nameMatch) company.name = nameMatch[1];

  // Extract website
  const websiteMatch = cleaned.match(/website:\s*"([^"]*?)"/);
  if (websiteMatch) company.website = websiteMatch[1];

  // Extract github
  const githubMatch = cleaned.match(/github:\s*"([^"]*?)"/);
  if (githubMatch) company.github = githubMatch[1];

  // Extract blog
  const blogMatch = cleaned.match(/blog:\s*"([^"]*?)"/);
  if (blogMatch) company.blog = blogMatch[1];

  // Extract jobs
  const jobsMatch = cleaned.match(/jobs:\s*"([^"]*?)"/);
  if (jobsMatch) company.jobs = jobsMatch[1];

  // Extract industry
  const industryMatch = cleaned.match(/industry:\s*"([^"]*?)"/);
  if (industryMatch) company.industry = industryMatch[1];

  // Extract date
  const dateMatch = cleaned.match(/last_changed_on:\s*~D\[(\d{4}-\d{2}-\d{2})\]/);
  if (dateMatch) company.lastChangedOn = dateMatch[1];

  // Extract location
  const locationMatch = cleaned.match(/location:\s*%\{([^}]*)\}/s);
  if (locationMatch) {
    const locStr = locationMatch[1];
    const cityMatch = locStr.match(/city:\s*"([^"]*?)"/);
    const stateMatch = locStr.match(/state:\s*"([^"]*?)"/);
    const countryMatch = locStr.match(/country:\s*"([^"]*?)"/);
    company.location = {
      city: cityMatch ? cityMatch[1] : '',
      state: stateMatch ? stateMatch[1] : '',
      country: countryMatch ? countryMatch[1] : '',
    };
  }

  // Extract description - handle both """ heredoc and regular "string"
  let description = '';
  const heredocMatch = cleaned.match(/description:\s*"""\n([\s\S]*?)"""/);
  if (heredocMatch) {
    description = heredocMatch[1].trim();
  } else {
    const simpleDescMatch = cleaned.match(/description:\s*"((?:[^"\\]|\\.)*)"/);
    if (simpleDescMatch) {
      description = simpleDescMatch[1].replace(/\\n/g, '\n').replace(/\\"/g, '"').trim();
    }
  }

  return { ...company, description };
}

function escapeYamlString(str) {
  if (!str) return '""';
  // If string contains special YAML characters, quote it
  if (str.includes(':') || str.includes('#') || str.includes("'") || str.includes('"') ||
      str.includes('\n') || str.includes('{') || str.includes('}') || str.includes('[') ||
      str.includes(']') || str.includes(',') || str.includes('&') || str.includes('*') ||
      str.includes('!') || str.includes('|') || str.includes('>') || str.includes('%') ||
      str.includes('@') || str.includes('`') || str.startsWith(' ') || str.endsWith(' ')) {
    // Use double quotes and escape internal double quotes
    return `"${str.replace(/\\/g, '\\\\').replace(/"/g, '\\"')}"`;
  }
  return `"${str}"`;
}

function toMarkdown(company) {
  const lines = ['---'];
  lines.push(`name: ${escapeYamlString(company.name || '')}`);
  lines.push(`website: ${escapeYamlString(company.website || '')}`);
  if (company.github) lines.push(`github: ${escapeYamlString(company.github)}`);
  if (company.blog) lines.push(`blog: ${escapeYamlString(company.blog)}`);
  if (company.jobs) lines.push(`jobs: ${escapeYamlString(company.jobs)}`);
  lines.push(`industry: ${escapeYamlString(company.industry || '')}`);
  lines.push('location:');
  lines.push(`  city: ${escapeYamlString(company.location?.city || '')}`);
  lines.push(`  state: ${escapeYamlString(company.location?.state || '')}`);
  lines.push(`  country: ${escapeYamlString(company.location?.country || '')}`);
  if (company.lastChangedOn) {
    lines.push(`lastChangedOn: ${company.lastChangedOn}`);
  }
  lines.push('---');
  lines.push('');
  lines.push(company.description || '');
  lines.push('');

  return lines.join('\n');
}

async function main() {
  await mkdir(OUTPUT_DIR, { recursive: true });

  const files = await readdir(COMPANIES_DIR);
  const exsFiles = files.filter(f => extname(f) === '.exs');

  console.log(`Converting ${exsFiles.length} company files...`);

  let success = 0;
  let errors = 0;

  for (const file of exsFiles) {
    try {
      const content = await readFile(join(COMPANIES_DIR, file), 'utf-8');
      const slug = basename(file, '.exs');
      const company = parseExsFile(content, file);

      if (!company.name) {
        console.warn(`  WARN: ${file} - no name found, skipping`);
        errors++;
        continue;
      }

      const markdown = toMarkdown(company);
      await writeFile(join(OUTPUT_DIR, `${slug}.md`), markdown, 'utf-8');
      success++;
    } catch (err) {
      console.error(`  ERROR: ${file} - ${err.message}`);
      errors++;
    }
  }

  console.log(`\nDone! ${success} converted, ${errors} errors.`);
}

main();
