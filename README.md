![Elixir Companies](https://user-images.githubusercontent.com/73386/33328317-e6e58c6e-d416-11e7-9a16-b60700db0a51.png)

# Elixir Companies

A [curated directory of companies using Elixir](https://elixir-companies.com/) in production.

Built with [Astro](https://astro.build) and deployed to GitHub Pages.

## Adding a new company

1. Fork this repository
2. Create a new file in `src/content/companies/` named `your-company.md`:

```markdown
---
name: "Your Company"
website: "https://example.com"
github: "https://github.com/your-org"
industry: "Information Technology"
location:
  city: "City"
  state: "State"
  country: "Country"
lastChangedOn: 2024-01-01
---

A description of your company and how you use Elixir.
```

3. Create a pull request

### Available industries

Based on the [Global Industry Classification Standard (GICS)](https://www.msci.com/our-solutions/indexes/gics):

- Communication Services
- Consumer Discretionary
- Consumer Staples
- Education
- Energy
- Financials
- Health Care
- Industrials
- Information Technology
- Materials
- Real Estate
- Transportation
- Utilities

### Optional fields

You can also include these in the frontmatter:

- `blog` - URL to the company blog
- `jobs` - URL to the company careers page (displays a "Hiring" badge)

## Development

### Prerequisites

- [Node.js](https://nodejs.org/) 20+

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

## License

See [LICENSE](LICENSE) for details.
