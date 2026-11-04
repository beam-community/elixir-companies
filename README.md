<p align="center">
  <img src="public/images/elixircompanies_readme_logo.png" alt="Elixir Companies" width="400" />
</p>

# Elixir Companies

A [curated directory of companies using Elixir](https://elixir-companies.com/) in production.

Built with [Astro](https://astro.build) and deployed to GitHub Pages on every push to `main`.

## Adding a new company

Every listing is a single Markdown file in [`src/content/companies/`](src/content/companies/). To add yours:

1. Fork this repository.
2. Create `src/content/companies/your_company.md`. Name the file after the company in lowercase, with spaces replaced by underscores.
3. Run `npm run build` to check your file against the schema (optional, but CI runs it on your pull request).
4. Open a pull request titled `Add Your Company`.

Start from this template:

```markdown
---
name: "Your Company"
website: "https://example.com"
github: "https://github.com/your-org"
blog: "https://example.com/blog"
jobs: "https://example.com/careers"
industry:
  - "Information Technology"
location:
  city: "City"
  state: ""
  country: "Country"
lastChangedOn: 2026-01-31
---

What the company does and how it uses Elixir.
```

### Fields

| Field | Required | Notes |
| --- | --- | --- |
| `name` | Yes | The company's name. |
| `website` | Yes | Full `https://` URL. |
| `industry` | Yes | A list of 1 to 3 values from [Industries](#industries). |
| `location` | Yes | `city`, `state` and `country`. Use the country's full English name, and `""` for any part that doesn't apply. |
| `lastChangedOn` | Yes | The date you added or last updated the entry, as `YYYY-MM-DD`. |
| `github` | No | The company's GitHub organization. |
| `blog` | No | The company's engineering or company blog. |
| `jobs` | No | The company's careers page. Listings with this field show a "Hiring" badge. |

Delete optional fields that don't apply rather than leaving them empty.

### Description

Below the frontmatter, write one or two short paragraphs in the third person about what the company does. **It must mention how the company uses Elixir.** Keep it factual: no marketing superlatives, emoji, or tracking parameters in links.

### Industries

Based on the [Global Industry Classification Standard (GICS)](https://www.msci.com/our-solutions/indexes/gics), with a few additions. Copy the value exactly:

- Agriculture & Food
- Communication Services
- Consumer Discretionary
- Consumer Staples
- Education
- Energy
- Financials
- Government & Non-Profit
- Health Care
- Industrials
- Information Technology
- Materials
- Media & Entertainment
- Professional Services
- Real Estate
- Transportation
- Utilities

The list is defined in [`src/utils/industries.ts`](src/utils/industries.ts).

### Using an AI agent

If you use a coding agent such as Claude Code, Codex or Cursor, paste it this prompt. It walks the agent through the same steps and checks above, and ends with a pull request. The same prompt is on the [website](https://elixir-companies.com/#add).

```text
Help me add my company to Elixir Companies (https://elixir-companies.com), a directory of companies using Elixir in production. The site is an Astro project at https://github.com/beam-community/elixir-companies, and each company is a single Markdown file. Your goal is to open one pull request that adds one file.

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
- industry is a list of 1 to 3 values, copied exactly from: Agriculture & Food, Communication Services, Consumer Discretionary, Consumer Staples, Education, Energy, Financials, Government & Non-Profit, Health Care, Industrials, Information Technology, Materials, Media & Entertainment, Professional Services, Real Estate, Transportation, Utilities.
- github, blog, and jobs are optional (jobs shows a "Hiring" badge). Remove any that don't apply instead of leaving them empty.
- All URLs are full https:// links that resolve.
- Use the country's full English name. Leave state as "" if it doesn't apply.
- lastChangedOn is today's date in YYYY-MM-DD format.
- The description must mention Elixir usage. Keep it factual: no marketing superlatives, emoji, or tracking parameters in links.
- Do not change any other files.

5. Validate: run npm ci and then npm run build (requires Node.js 22.23.4 or newer). The build checks the frontmatter against the schema, so fix any errors it reports.

6. Commit only the new file with the message "Add <Company Name>", push the branch to my fork, and open a pull request against main titled "Add <Company Name>". Fill in the pull request template checklist.

7. Reply with the pull request URL.
```

## Development

### Prerequisites

[Node.js](https://nodejs.org/) 22.23.4 or newer (required by Astro 7).

### Setup

```sh
npm install
npm run dev
```

Visit [localhost:4321](http://localhost:4321) in your browser.

### Build

```sh
npm run build
npm run preview
```

### Project layout

- `src/content/companies/`: one Markdown file per company
- `src/content.config.ts`: the schema each company file is validated against
- `src/utils/industries.ts`: allowed industry values
- `src/utils/agentPrompt.ts`: the AI agent prompt shown on the site. Keep the copy in this README in sync when you change it.
- `src/pages/`: the homepage and company pages

## License

See [LICENSE](LICENSE) for details.
