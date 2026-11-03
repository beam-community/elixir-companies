import { useState, useMemo, useEffect } from 'preact/hooks';
import type { CompanyData, SortOption } from '../utils/search';
import { filterCompanies, sortCompanies } from '../utils/search';

const PAGE_SIZE = 24;

interface Props {
  companies: CompanyData[];
  /** [industry, count] sorted by count. */
  industries: [string, number][];
  /** Countries with at least one listing, sorted by count. */
  countries: string[];
}

const PinIcon = () => (
  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true">
    <path d="M12 21s-7-6.2-7-11.5a7 7 0 0 1 14 0C19 14.8 12 21 12 21Z" />
    <circle cx="12" cy="9.5" r="2.5" />
  </svg>
);

const GithubIcon = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
    <path d="M9 19c-4.3 1.4-4.3-2.5-6-3m12 5v-3.5c0-1 .1-1.4-.5-2 2.8-.3 5.5-1.4 5.5-6a4.6 4.6 0 0 0-1.3-3.2 4.2 4.2 0 0 0-.1-3.2s-1.1-.3-3.5 1.3a12.3 12.3 0 0 0-6.2 0C6.5 2.8 5.4 3.1 5.4 3.1a4.2 4.2 0 0 0-.1 3.2A4.6 4.6 0 0 0 4 9.5c0 4.6 2.7 5.7 5.5 6-.6.6-.6 1.2-.5 2V21" />
  </svg>
);

const GlobeIcon = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" aria-hidden="true">
    <circle cx="12" cy="12" r="9" />
    <path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18" />
  </svg>
);

function CompanyCard({ company }: { company: CompanyData }) {
  const href = `/companies/${company.slug}`;
  return (
    <article class="card flex flex-col gap-3.5 p-6">
      <div class="flex items-center gap-3.5">
        <span class="avatar h-12 w-12 text-xl">{company.name[0]}</span>
        <div class="min-w-0">
          <h3 class="font-display text-xl font-bold tracking-[-0.01em]">
            <a href={href} class="text-ink no-underline hover:text-link">{company.name}</a>
          </h3>
          <div class="flex items-center gap-1 text-[13.5px] text-muted">
            <PinIcon />
            <span class="truncate">{company.place || 'Location not listed'}</span>
          </div>
        </div>
      </div>
      <p class="line-clamp-3 flex-1 text-[15px] leading-normal text-body">
        {company.description || 'No description yet.'}
      </p>
      <div class="flex flex-wrap gap-1.5">
        {company.industry.map((ind) => (
          <span key={ind} class="pill">{ind}</span>
        ))}
      </div>
      <div class="mt-0.5 flex items-center gap-2 border-t border-line-soft pt-3">
        <a href={href} class="flex-1 py-2.5 text-sm font-semibold no-underline">View profile →</a>
        {company.jobs && <span class="pill-hiring">Hiring</span>}
        {company.github && (
          <a href={company.github} target="_blank" rel="noopener" aria-label={`${company.name} on GitHub`} class="inline-flex h-11 w-11 items-center justify-center rounded-[10px] text-muted hover:bg-tint hover:text-link">
            <GithubIcon />
          </a>
        )}
        <a href={company.website} target="_blank" rel="noopener" aria-label={`${company.name} website`} class="inline-flex h-11 w-11 items-center justify-center rounded-[10px] text-muted hover:bg-tint hover:text-link">
          <GlobeIcon />
        </a>
      </div>
    </article>
  );
}

export default function SearchFilter({ companies, industries, countries }: Props) {
  const [query, setQuery] = useState('');
  const [selected, setSelected] = useState<string[]>([]);
  const [country, setCountry] = useState('');
  const [onlyGithub, setOnlyGithub] = useState(false);
  const [onlyHiring, setOnlyHiring] = useState(false);
  const [sort, setSort] = useState<SortOption>('name');
  const [page, setPage] = useState(1);

  // Read initial state from the URL (homepage links use ?industry=, ?q=, ?sort=).
  useEffect(() => {
    const p = new URLSearchParams(window.location.search);
    setQuery(p.get('q') ?? '');
    setSelected(p.get('industry')?.split(',').filter(Boolean) ?? []);
    setCountry(p.get('country') ?? '');
    setOnlyGithub(p.has('github'));
    setOnlyHiring(p.has('hiring'));
    const s = p.get('sort');
    if (s === 'name' || s === 'recent') setSort(s);
  }, []);

  // "/" focuses search, like most directories.
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      const target = e.target as HTMLElement;
      if (e.key !== '/' || target.closest('input, textarea, select')) return;
      e.preventDefault();
      document.getElementById('dir-search')?.focus();
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, []);

  // Keep the URL shareable.
  useEffect(() => {
    const p = new URLSearchParams();
    if (query) p.set('q', query);
    if (selected.length) p.set('industry', selected.join(','));
    if (country) p.set('country', country);
    if (onlyGithub) p.set('github', '');
    if (onlyHiring) p.set('hiring', '');
    if (sort !== 'name') p.set('sort', sort);
    const qs = p.toString().replace(/=(?=&|$)/g, '');
    window.history.replaceState(null, '', qs ? `${window.location.pathname}?${qs}` : window.location.pathname);
  }, [query, selected, country, onlyGithub, onlyHiring, sort]);

  const filtered = useMemo(
    () => sortCompanies(filterCompanies(companies, { query, industries: selected, country, onlyGithub, onlyHiring }), sort),
    [companies, query, selected, country, onlyGithub, onlyHiring, sort],
  );
  const displayed = filtered.slice(0, page * PAGE_SIZE);
  const isFiltered = !!query || selected.length > 0 || !!country || onlyGithub || onlyHiring;

  const update = <T,>(set: (v: T) => void) => (v: T) => {
    set(v);
    setPage(1);
  };

  const toggleIndustry = (ind: string) =>
    update(setSelected)(selected.includes(ind) ? selected.filter((i) => i !== ind) : [...selected, ind]);

  const clearFilters = () => {
    setQuery('');
    setSelected([]);
    setCountry('');
    setOnlyGithub(false);
    setOnlyHiring(false);
    setPage(1);
  };

  const industryButton = (name: string, count: number, active: boolean, onClick: () => void) => (
    <button
      key={name}
      type="button"
      aria-pressed={active}
      onClick={onClick}
      class={`flex min-h-11 w-full items-center justify-between gap-3 rounded-[10px] px-3 text-left text-[15px] transition ${
        active ? 'bg-tint-strong font-semibold text-link-hover' : 'text-ink hover:bg-tint'
      }`}
    >
      <span>{name}</span>
      <span class={`font-mono text-[13px] ${active ? 'text-link' : 'text-muted'}`}>{count}</span>
    </button>
  );

  return (
    <div>
      {/* Search sits in the dark header band on desktop and mobile alike. */}
      <div class="-mt-[88px] mb-10 flex h-14 max-w-[640px] items-center gap-2.5 rounded-[14px] bg-surface px-4 ring-1 ring-plum-border/60 shadow-[0_16px_40px_rgba(28,14,43,0.18)]">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" class="text-muted" stroke-width="2" stroke-linecap="round" aria-hidden="true">
          <circle cx="11" cy="11" r="7" />
          <path d="m20 20-3.5-3.5" />
        </svg>
        <label for="dir-search" class="sr-only">Search companies</label>
        <input
          id="dir-search"
          type="search"
          value={query}
          onInput={(e) => update(setQuery)((e.target as HTMLInputElement).value)}
          placeholder="Try “LiveView”, “Berlin” or “fintech”"
          class="min-w-0 flex-1 border-0 bg-transparent text-base text-ink outline-none placeholder:text-muted"
        />
        <kbd class="hidden rounded-md border border-field px-1.5 py-0.5 font-mono text-xs text-muted sm:inline">/</kbd>
      </div>

      <div class="flex flex-wrap items-start gap-10">
        <aside class="max-w-full flex-[1_1_240px]">
          <h2 class="mb-3 font-mono text-xs font-medium uppercase tracking-[0.08em] text-muted">Industry</h2>
          <div class="flex flex-col gap-0.5">
            {industryButton('All', companies.length, selected.length === 0, () => update(setSelected)([]))}
            {industries.map(([name, count]) => industryButton(name, count, selected.includes(name), () => toggleIndustry(name)))}
          </div>

          <h2 class="mb-3 mt-8 font-mono text-xs font-medium uppercase tracking-[0.08em] text-muted">
            <label for="dir-country">Country</label>
          </h2>
          <select
            id="dir-country"
            value={country}
            onChange={(e) => update(setCountry)((e.target as HTMLSelectElement).value)}
            class="h-11 w-full rounded-[10px] border border-field bg-surface px-3 text-[15px] text-ink"
          >
            <option value="">All countries</option>
            {countries.map((c) => (
              <option key={c} value={c}>{c}</option>
            ))}
          </select>

          <h2 class="mb-3 mt-8 font-mono text-xs font-medium uppercase tracking-[0.08em] text-muted">Show only</h2>
          <label class="flex min-h-11 items-center gap-2.5 text-[15px]">
            <input type="checkbox" checked={onlyGithub} onChange={() => update(setOnlyGithub)(!onlyGithub)} class="h-[18px] w-[18px] accent-link" />
            Has open source on GitHub
          </label>
          <label class="flex min-h-11 items-center gap-2.5 text-[15px]">
            <input type="checkbox" checked={onlyHiring} onChange={() => update(setOnlyHiring)(!onlyHiring)} class="h-[18px] w-[18px] accent-link" />
            Hiring (jobs link listed)
          </label>
        </aside>

        <section class="min-w-0 flex-[999_1_560px]" aria-label="Results">
          <div class="mb-5 flex flex-wrap items-center justify-between gap-3">
            <p class="text-[15px] text-muted" aria-live="polite">
              <strong class="text-ink">{isFiltered ? `${filtered.length} ${filtered.length === 1 ? 'match' : 'matches'}` : `${companies.length} companies`}</strong>
              {selected.length === 1 && ` in ${selected[0]}`}
              {isFiltered && (
                <button type="button" onClick={clearFilters} class="ml-3 font-semibold text-link hover:text-link-hover">
                  Clear filters
                </button>
              )}
            </p>
            <div class="flex items-center gap-2 text-sm text-muted">
              <label for="sort">Sort</label>
              <select
                id="sort"
                value={sort}
                onChange={(e) => update(setSort)((e.target as HTMLSelectElement).value as SortOption)}
                class="h-11 rounded-[10px] border border-field bg-surface px-3 text-sm text-ink"
              >
                <option value="name">Name A–Z</option>
                <option value="recent">Recently updated</option>
              </select>
            </div>
          </div>

          {displayed.length > 0 ? (
            <div class="grid grid-cols-[repeat(auto-fill,minmax(min(280px,100%),1fr))] gap-4">
              {displayed.map((c) => (
                <CompanyCard key={c.slug} company={c} />
              ))}
            </div>
          ) : (
            <div class="rounded-[20px] border border-dashed border-field bg-surface px-6 py-14 text-center">
              <h3 class="mb-2 font-display text-2xl font-bold">No companies match yet</h3>
              <p class="mb-5 text-[15px] text-muted">Know one that should be here? Listings are one Markdown file away.</p>
              <button type="button" onClick={clearFilters} class="h-11 rounded-xl border border-link bg-surface px-[18px] font-semibold text-link hover:bg-tint">
                Clear filters
              </button>
            </div>
          )}

          {displayed.length < filtered.length && (
            <div class="mt-10 text-center">
              <button type="button" onClick={() => setPage(page + 1)} class="h-12 rounded-[14px] border border-field bg-surface px-6 font-semibold text-ink hover:border-link hover:text-link">
                Show more ({filtered.length - displayed.length} remaining)
              </button>
            </div>
          )}
        </section>
      </div>
    </div>
  );
}
