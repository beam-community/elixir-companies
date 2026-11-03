export interface CompanyData {
  slug: string;
  name: string;
  website: string;
  github?: string;
  jobs?: string;
  industry: string[];
  /** "City, Country", empty when not listed. */
  place: string;
  /** Normalized country, empty when not listed. */
  country: string;
  lastChangedOn: string;
  /** Plain-text description. */
  description: string;
}

export interface Filters {
  query: string;
  industries: string[];
  country: string;
  onlyGithub: boolean;
  onlyHiring: boolean;
}

export type SortOption = 'name' | 'recent';

export function filterCompanies(companies: CompanyData[], f: Filters): CompanyData[] {
  const q = f.query.trim().toLowerCase();
  return companies.filter(
    (c) =>
      (f.industries.length === 0 || c.industry.some((ind) => f.industries.includes(ind))) &&
      (!f.country || c.country === f.country) &&
      (!f.onlyGithub || !!c.github) &&
      (!f.onlyHiring || !!c.jobs) &&
      (!q ||
        c.name.toLowerCase().includes(q) ||
        c.place.toLowerCase().includes(q) ||
        c.description.toLowerCase().includes(q) ||
        c.industry.some((ind) => ind.toLowerCase().includes(q))),
  );
}

export function sortCompanies(companies: CompanyData[], sort: SortOption): CompanyData[] {
  const sorted = [...companies];
  if (sort === 'name') {
    sorted.sort((a, b) => a.name.localeCompare(b.name));
  } else {
    sorted.sort((a, b) => b.lastChangedOn.localeCompare(a.lastChangedOn));
  }
  return sorted;
}
