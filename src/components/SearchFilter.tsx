import { useState, useMemo, useCallback, useEffect } from 'preact/hooks';
import type { CompanyData, SortOption } from '../utils/search';
import {
  searchCompanies,
  filterByIndustry,
  filterByCountry,
  sortCompanies,
  getUniqueCountries,
  getUniqueIndustries,
} from '../utils/search';
import { getIndustryColor, getIndustryIcon } from '../utils/industries';

const PAGE_SIZE = 24;

function CompanyCardPreact({ company }: { company: CompanyData }) {
  const locationText =
    [company.location.city, company.location.state, company.location.country]
      .filter(Boolean)
      .join(', ') || 'Remote';

  const truncatedDesc =
    company.description.length > 150
      ? company.description.slice(0, 150).trimEnd() + '...'
      : company.description;

  return (
    <a
      href={`/companies/${company.slug}`}
      class="card block group relative"
    >
      {company.jobs && (
        <div class="absolute top-3 right-3 z-10">
          <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-500 text-white shadow-lg shadow-emerald-500/30">
            Hiring
          </span>
        </div>
      )}
      <div class="p-6">
        <h3 class="font-display font-bold text-lg text-gray-900 dark:text-white group-hover:text-accent transition-colors leading-tight mb-3">
          {company.name}
        </h3>
        <div class="flex flex-wrap gap-1.5 mb-3">
          <span
            class={`inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ${getIndustryColor(company.industry[0])}`}
          >
            <span class="mr-1">{getIndustryIcon(company.industry[0])}</span>
            {company.industry[0]}
          </span>
          {company.industry.length > 1 && (
            <span
              class={`inline-flex items-center px-2 py-1 rounded-full text-[0.65rem] font-medium ${getIndustryColor(company.industry[1])}`}
            >
              {company.industry[1]}
            </span>
          )}
        </div>
        <p class="text-sm text-gray-500 dark:text-gray-400 mb-3 leading-relaxed"
           style={{ display: '-webkit-box', WebkitLineClamp: 3, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>
          {truncatedDesc}
        </p>
        <div class="flex items-center gap-4 text-xs text-gray-400 dark:text-gray-500 mt-auto pt-3 border-t border-gray-100 dark:border-elixir-800">
          <span class="flex items-center gap-1">
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"
              />
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"
              />
            </svg>
            {locationText}
          </span>
          {company.github && (
            <span class="flex items-center gap-1">
              <svg class="w-3.5 h-3.5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z" />
              </svg>
              GitHub
            </span>
          )}
        </div>
      </div>
    </a>
  );
}

export default function SearchFilter({
  companies,
}: {
  companies: CompanyData[];
}) {
  const [query, setQuery] = useState('');
  const [selectedIndustries, setSelectedIndustries] = useState<string[]>([]);
  const [selectedCountry, setSelectedCountry] = useState('');
  const [sort, setSort] = useState<SortOption>('name');
  const [page, setPage] = useState(1);
  const [showFilters, setShowFilters] = useState(false);

  const allIndustries = useMemo(() => getUniqueIndustries(companies), [companies]);
  const allCountries = useMemo(() => getUniqueCountries(companies), [companies]);

  // Read initial state from URL
  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const q = params.get('q');
    const ind = params.get('industry');
    const country = params.get('country');
    const s = params.get('sort');
    if (q) setQuery(q);
    if (ind) setSelectedIndustries(ind.split(','));
    if (country) setSelectedCountry(country);
    if (s === 'name' || s === 'recent') setSort(s);
  }, []);

  const filtered = useMemo(() => {
    let result = searchCompanies(companies, query);
    result = filterByIndustry(result, selectedIndustries);
    result = filterByCountry(result, selectedCountry);
    result = sortCompanies(result, sort);
    return result;
  }, [companies, query, selectedIndustries, selectedCountry, sort]);

  const displayed = useMemo(
    () => filtered.slice(0, page * PAGE_SIZE),
    [filtered, page],
  );
  const hasMore = displayed.length < filtered.length;

  // Sync state to URL
  useEffect(() => {
    const params = new URLSearchParams();
    if (query) params.set('q', query);
    if (selectedIndustries.length) params.set('industry', selectedIndustries.join(','));
    if (selectedCountry) params.set('country', selectedCountry);
    if (sort !== 'name') params.set('sort', sort);
    const qs = params.toString();
    const url = qs ? `${window.location.pathname}?${qs}` : window.location.pathname;
    window.history.replaceState(null, '', url);
  }, [query, selectedIndustries, selectedCountry, sort]);

  const toggleIndustry = useCallback((industry: string) => {
    setSelectedIndustries((prev) =>
      prev.includes(industry)
        ? prev.filter((i) => i !== industry)
        : [...prev, industry],
    );
    setPage(1);
  }, []);

  const clearFilters = useCallback(() => {
    setQuery('');
    setSelectedIndustries([]);
    setSelectedCountry('');
    setSort('name');
    setPage(1);
  }, []);

  const activeFilterCount =
    (query ? 1 : 0) + selectedIndustries.length + (selectedCountry ? 1 : 0);

  return (
    <div>
      {/* Search bar */}
      <div class="flex flex-col sm:flex-row gap-3 mb-6">
        <div class="relative flex-1">
          <svg
            class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
            />
          </svg>
          <input
            type="text"
            placeholder="Search companies, industries, locations..."
            value={query}
            onInput={(e) => {
              setQuery((e.target as HTMLInputElement).value);
              setPage(1);
            }}
            class="w-full pl-10 pr-4 py-3 rounded-xl border border-gray-200 dark:border-elixir-700 bg-white dark:bg-elixir-900 text-gray-900 dark:text-white placeholder-gray-400 focus:ring-2 focus:ring-accent/50 focus:border-accent outline-none transition-all"
          />
        </div>

        <div class="flex gap-2">
          <button
            onClick={() => setShowFilters(!showFilters)}
            class={`flex items-center gap-2 px-4 py-3 rounded-xl border transition-all text-sm font-medium ${
              showFilters || activeFilterCount > 0
                ? 'border-accent bg-accent/10 text-accent'
                : 'border-gray-200 dark:border-elixir-700 text-gray-600 dark:text-gray-300 hover:border-accent'
            }`}
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z" />
            </svg>
            Filters
            {activeFilterCount > 0 && (
              <span class="flex items-center justify-center w-5 h-5 rounded-full bg-accent text-white text-xs font-bold">
                {activeFilterCount}
              </span>
            )}
          </button>

          <select
            value={sort}
            onChange={(e) => {
              setSort((e.target as HTMLSelectElement).value as SortOption);
              setPage(1);
            }}
            class="px-4 py-3 rounded-xl border border-gray-200 dark:border-elixir-700 bg-white dark:bg-elixir-900 text-gray-600 dark:text-gray-300 text-sm font-medium outline-none focus:ring-2 focus:ring-accent/50"
          >
            <option value="name">A - Z</option>
            <option value="recent">Recently Added</option>
          </select>
        </div>
      </div>

      {/* Filters panel */}
      {showFilters && (
        <div class="mb-6 p-5 rounded-2xl bg-white dark:bg-elixir-900 border border-gray-200 dark:border-elixir-700 animate-fade-in">
          <div class="flex items-center justify-between mb-4">
            <h3 class="font-display font-semibold text-sm text-gray-900 dark:text-white">
              Filter by Industry
            </h3>
            {activeFilterCount > 0 && (
              <button
                onClick={clearFilters}
                class="text-xs text-accent hover:text-accent-hover font-medium"
              >
                Clear all
              </button>
            )}
          </div>
          <div class="flex flex-wrap gap-2 mb-4">
            {allIndustries.map((industry) => (
              <button
                key={industry}
                onClick={() => toggleIndustry(industry)}
                class={`px-3 py-1.5 rounded-full text-xs font-medium transition-all ${
                  selectedIndustries.includes(industry)
                    ? 'bg-accent text-white shadow-md shadow-accent/25'
                    : 'bg-gray-100 dark:bg-elixir-800 text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-elixir-700'
                }`}
              >
                {getIndustryIcon(industry)} {industry}
              </button>
            ))}
          </div>

          <h3 class="font-display font-semibold text-sm text-gray-900 dark:text-white mb-2">
            Filter by Country
          </h3>
          <select
            value={selectedCountry}
            onChange={(e) => {
              setSelectedCountry((e.target as HTMLSelectElement).value);
              setPage(1);
            }}
            class="w-full sm:w-64 px-3 py-2 rounded-lg border border-gray-200 dark:border-elixir-700 bg-white dark:bg-elixir-800 text-gray-600 dark:text-gray-300 text-sm outline-none"
          >
            <option value="">All Countries</option>
            {allCountries.map((country) => (
              <option key={country} value={country}>
                {country}
              </option>
            ))}
          </select>
        </div>
      )}

      {/* Results count */}
      <div class="flex items-center justify-between mb-6">
        <p class="text-sm text-gray-500 dark:text-gray-400">
          Showing{' '}
          <span class="font-semibold text-gray-900 dark:text-white">
            {displayed.length}
          </span>{' '}
          of{' '}
          <span class="font-semibold text-gray-900 dark:text-white">
            {filtered.length}
          </span>{' '}
          companies
        </p>
      </div>

      {/* Results grid */}
      {displayed.length > 0 ? (
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
          {displayed.map((company) => (
            <CompanyCardPreact key={company.slug} company={company} />
          ))}
        </div>
      ) : (
        <div class="text-center py-16">
          <div class="text-5xl mb-4">🔍</div>
          <h3 class="font-display font-semibold text-lg text-gray-900 dark:text-white mb-2">
            No companies found
          </h3>
          <p class="text-gray-500 dark:text-gray-400 mb-4">
            Try adjusting your search or filters
          </p>
          <button onClick={clearFilters} class="btn-primary text-sm">
            Clear all filters
          </button>
        </div>
      )}

      {/* Load more */}
      {hasMore && (
        <div class="text-center mt-8">
          <button
            onClick={() => setPage((p) => p + 1)}
            class="btn-secondary"
          >
            Load More ({filtered.length - displayed.length} remaining)
          </button>
        </div>
      )}
    </div>
  );
}
