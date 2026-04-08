import { readdir, readFile, writeFile } from 'node:fs/promises';
import { join } from 'node:path';

const MAPPING = {
  'Technology Consulting': { primary: 'Professional Services', secondary: 'Information Technology' },
  'Information Technology': { primary: 'Information Technology' },
  'Communication': { primary: 'Communication Services' },
  'Healthcare': { primary: 'Health Care' },
  'Financial Technology': { primary: 'Financials', secondary: 'Information Technology' },
  'Enterprise Software': { primary: 'Information Technology' },
  'E-Commerce': { primary: 'Consumer Discretionary', secondary: 'Information Technology' },
  'Education': { primary: 'Education' },
  'Real Estate': { primary: 'Real Estate' },
  'Marketing/Sales': { primary: 'Professional Services' },
  'Sports': { primary: 'Media & Entertainment' },
  'Customer Service': { primary: 'Professional Services', secondary: 'Information Technology' },
  'Telecommunications': { primary: 'Communication Services' },
  'Gaming': { primary: 'Media & Entertainment' },
  'Financials': { primary: 'Financials' },
  'Transportation': { primary: 'Transportation' },
  'Legal Services': { primary: 'Professional Services' },
  'Computer Software': { primary: 'Information Technology' },
  'Marketplaces': { primary: 'Consumer Discretionary', secondary: 'Information Technology' },
  'Leisure/Travel': { primary: 'Consumer Discretionary' },
  'Human Resources': { primary: 'Professional Services' },
  'Financial Services': { primary: 'Financials' },
  'Computer Software/Engineering': { primary: 'Information Technology' },
  'Technology': { primary: 'Information Technology' },
  'Food': { primary: 'Agriculture & Food' },
  'Video': { primary: 'Media & Entertainment' },
  'Software': { primary: 'Information Technology' },
  'Social Network': { primary: 'Communication Services' },
  'Security': { primary: 'Information Technology' },
  'Online Ordering': { primary: 'Consumer Discretionary', secondary: 'Information Technology' },
  'Non-Profit/Volunteering': { primary: 'Government & Non-Profit' },
  'Internet Infrastructure': { primary: 'Information Technology' },
  'Insurance': { primary: 'Financials' },
  'Identity': { primary: 'Information Technology' },
  'Hospitality': { primary: 'Consumer Discretionary' },
  'Health/Fitness': { primary: 'Health Care' },
  'Health Care': { primary: 'Health Care' },
  'Entertainment': { primary: 'Media & Entertainment' },
  'Computer Hardware': { primary: 'Information Technology' },
  'Communication Services': { primary: 'Communication Services' },
  'Cannabis': { primary: 'Agriculture & Food' },
  'Business Intelligence': { primary: 'Information Technology' },
  'Staffing/Recruiting': { primary: 'Professional Services' },
  'Service Relationship Management': { primary: 'Professional Services', secondary: 'Information Technology' },
  'SEO': { primary: 'Professional Services' },
  'Retail Industry': { primary: 'Consumer Discretionary' },
  'Restaurant Tech': { primary: 'Consumer Discretionary', secondary: 'Information Technology' },
  'Research': { primary: 'Education' },
  'Publishing': { primary: 'Media & Entertainment' },
  'Performance Management': { primary: 'Professional Services' },
  'Payment': { primary: 'Financials' },
  'Navigation': { primary: 'Transportation', secondary: 'Information Technology' },
  'Mobile App & Game Development': { primary: 'Information Technology' },
  'Media Production': { primary: 'Media & Entertainment' },
  'Media': { primary: 'Media & Entertainment' },
  'Marketing/Advertising/Sales': { primary: 'Professional Services' },
  'Market Research': { primary: 'Professional Services' },
  'Logistics': { primary: 'Transportation' },
  'Industrials': { primary: 'Industrials' },
  'Home automation': { primary: 'Information Technology' },
  'Home Services': { primary: 'Consumer Discretionary' },
  'Government': { primary: 'Government & Non-Profit' },
  'GovTech': { primary: 'Government & Non-Profit', secondary: 'Information Technology' },
  'Gig Economy': { primary: 'Professional Services' },
  'Family': { primary: 'Consumer Staples' },
  'Expert Networks': { primary: 'Professional Services' },
  'Enterprise SaaS': { primary: 'Information Technology' },
  'Energy': { primary: 'Energy' },
  'Education Technology': { primary: 'Education', secondary: 'Information Technology' },
  'Domain Registrar': { primary: 'Information Technology' },
  'Dating': { primary: 'Communication Services' },
  'Consumer Electronics': { primary: 'Consumer Discretionary' },
  'Clean Tech': { primary: 'Energy' },
  'Child Care': { primary: 'Consumer Staples' },
  'Broadcast Media': { primary: 'Media & Entertainment' },
  'Blockchain & Fintech': { primary: 'Financials', secondary: 'Information Technology' },
  'Beauty/Wellness': { primary: 'Consumer Staples' },
  'Automotive': { primary: 'Industrials' },
  'Apparel/Fashion': { primary: 'Consumer Discretionary' },
  'Additive Manufacturing & 3D Printing': { primary: 'Industrials' },
};

const companiesDir = join(import.meta.dirname, '..', 'src', 'content', 'companies');

const files = (await readdir(companiesDir)).filter(f => f.endsWith('.md'));

let migrated = 0;
let warnings = 0;

for (const file of files) {
  const filePath = join(companiesDir, file);
  const content = await readFile(filePath, 'utf-8');

  // Match the industry line in frontmatter
  const match = content.match(/^industry:\s*"?([^"\n]+)"?\s*$/m);
  if (!match) {
    console.warn(`WARNING: No industry field found in ${file}`);
    warnings++;
    continue;
  }

  const oldIndustry = match[1].trim();
  const mapping = MAPPING[oldIndustry];

  if (!mapping) {
    console.warn(`WARNING: Unmapped industry "${oldIndustry}" in ${file}`);
    warnings++;
    continue;
  }

  const industries = [mapping.primary];
  if (mapping.secondary) industries.push(mapping.secondary);

  const yamlArray = industries.map(i => `  - "${i}"`).join('\n');
  const newContent = content.replace(
    /^industry:\s*"?[^"\n]+"?\s*$/m,
    `industry:\n${yamlArray}`
  );

  await writeFile(filePath, newContent, 'utf-8');
  migrated++;
}

console.log(`\nMigration complete: ${migrated} files migrated, ${warnings} warnings`);
