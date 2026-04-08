export interface CompanyData {
  slug: string;
  name: string;
  website: string;
  github?: string;
  blog?: string;
  jobs?: string;
  industry: string[];
  location: {
    city: string;
    state: string;
    country: string;
  };
  lastChangedOn: string;
  description: string;
}

export function searchCompanies(
  companies: CompanyData[],
  query: string,
): CompanyData[] {
  if (!query.trim()) return companies;
  const q = query.toLowerCase();
  return companies.filter(
    (c) =>
      c.name.toLowerCase().includes(q) ||
      c.industry.some((ind) => ind.toLowerCase().includes(q)) ||
      c.description.toLowerCase().includes(q) ||
      c.location.country.toLowerCase().includes(q) ||
      c.location.city.toLowerCase().includes(q),
  );
}

export function filterByIndustry(
  companies: CompanyData[],
  industries: string[],
): CompanyData[] {
  if (industries.length === 0) return companies;
  return companies.filter((c) =>
    c.industry.some((ind) => industries.includes(ind)),
  );
}

export function filterByCountry(
  companies: CompanyData[],
  country: string,
): CompanyData[] {
  if (!country) return companies;
  return companies.filter((c) => c.location.country === country);
}

export type SortOption = 'name' | 'recent';

export function sortCompanies(
  companies: CompanyData[],
  sort: SortOption,
): CompanyData[] {
  const sorted = [...companies];
  if (sort === 'name') {
    sorted.sort((a, b) => a.name.localeCompare(b.name));
  } else {
    sorted.sort(
      (a, b) =>
        new Date(b.lastChangedOn).getTime() -
        new Date(a.lastChangedOn).getTime(),
    );
  }
  return sorted;
}

export function getUniqueCountries(companies: CompanyData[]): string[] {
  const countries = new Set(
    companies.map((c) => c.location.country).filter(Boolean),
  );
  return [...countries].sort();
}

export function getUniqueIndustries(companies: CompanyData[]): string[] {
  const industries = new Set(
    companies.flatMap((c) => c.industry).filter(Boolean),
  );
  return [...industries].sort();
}
