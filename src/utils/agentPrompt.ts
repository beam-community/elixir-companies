import { INDUSTRY_VALUES } from './industries';

/**
 * Instructions a contributor can paste into a coding agent to add their company.
 * Built from INDUSTRY_VALUES so the allowed industries never drift from the content schema.
 */
export const AGENT_PROMPT = `Help me add my company to Elixir Companies (https://elixir-companies.com), a directory of companies using Elixir in production. The site is an Astro project at https://github.com/beam-community/elixir-companies, and each company is a single Markdown file. Your goal is to open one pull request that adds one file.

1. Ask me for anything below that you don't know: company name, website, how the company uses Elixir, city/state/country, and optionally GitHub org, blog, and careers page URLs. Only use facts I give you or that you can verify on the company's own website. Never invent details.

2. Fork and clone the repository, then create a branch named add-<company-slug>.

3. Check for duplicates: search src/content/companies/ for the company name and website domain. If the company is already listed, stop and tell me instead of adding a new file.

4. Create src/content/companies/<company_slug>.md, where the slug is the lowercase company name with spaces replaced by underscores (for example, "Acme Labs" becomes acme_labs.md). Use exactly this format:

---
name: "Acme Labs"
website: "https://acme.example"
github: "https://github.com/acme"
blog: "https://acme.example/blog"
jobs: "https://acme.example/careers"
industry:
  - "Information Technology"
location:
  city: "Lisbon"
  state: ""
  country: "Portugal"
lastChangedOn: 2026-01-31
---

One or two short paragraphs, in the third person, describing what the company does and specifically how it uses Elixir.

Rules:
- industry is a list of 1 to 3 values, copied exactly from: ${INDUSTRY_VALUES.join(', ')}.
- github, blog, and jobs are optional (jobs shows a "Hiring" badge). Remove any that don't apply instead of leaving them empty.
- All URLs are full https:// links that resolve.
- Use the country's full English name. Leave state as "" if it doesn't apply.
- lastChangedOn is today's date in YYYY-MM-DD format.
- The description must mention Elixir usage. Keep it factual: no marketing superlatives, emoji, or tracking parameters in links.
- Do not change any other files.

5. Validate: run npm ci and then npm run build (requires Node.js 22.23.4 or newer). The build checks the frontmatter against the schema, so fix any errors it reports.

6. Commit only the new file with the message "Add <Company Name>", push the branch to my fork, and open a pull request against main titled "Add <Company Name>". Fill in the pull request template checklist.

7. Reply with the pull request URL.`;
