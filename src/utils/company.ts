interface Location {
  city: string;
  state: string;
  country: string;
}

/** "City, Country" (state dropped to keep it short); empty string when nothing is listed. */
export function formatLocation(location: Location): string {
  const country = normalizeCountry(location.country);
  return [location.city, country].filter(Boolean).join(', ');
}

/** Markdown body reduced to one line of plain text. */
export function plainDescription(markdown: string): string {
  return markdown
    .replace(/\[([^\]]+)\]\([^)]+\)/g, '$1')
    .replace(/[*_~`#>]/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

const COUNTRY_ALIASES: Record<string, string> = {
  usa: 'United States',
  us: 'United States',
  'united states of america': 'United States',
  'wa. usa': 'United States',
  'ny. usa': 'United States',
  uk: 'United Kingdom',
  london: 'United Kingdom',
  'the netherlands': 'Netherlands',
  pl: 'Poland',
  fr: 'France',
  mex: 'Mexico',
  danmark: 'Denmark',
  distributed: 'Remote',
};

/** Free-text country field mapped onto one spelling per country where the intent is unambiguous. */
export function normalizeCountry(raw: string): string {
  const trimmed = raw.trim().replace(/\.$/, '');
  return COUNTRY_ALIASES[trimmed.toLowerCase()] ?? trimmed;
}

export function countBy<T>(items: T[], keys: (item: T) => string[]): [string, number][] {
  const counts = new Map<string, number>();
  for (const item of items) {
    for (const key of keys(item)) {
      if (key) counts.set(key, (counts.get(key) ?? 0) + 1);
    }
  }
  return [...counts.entries()].sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]));
}

const BEAM_TECH: [string, RegExp][] = [
  ['Elixir', /\belixir\b/i],
  ['Phoenix', /\bphoenix\b(?!\s+liveview)/i],
  ['Phoenix LiveView', /\blive ?view\b/i],
  ['Erlang/OTP', /\b(erlang|otp)\b/i],
  ['Ecto', /\becto\b/i],
  ['Nerves', /\bnerves\b/i],
  ['Absinthe', /\babsinthe\b/i],
  ['Oban', /\boban\b/i],
  ['Broadway', /\bbroadway\b/i],
];

/** BEAM technologies a company's description mentions, in a stable order. */
export function beamStack(description: string): string[] {
  return BEAM_TECH.filter(([, re]) => re.test(description)).map(([name]) => name);
}

export function displayUrl(url: string): string {
  return url.replace(/^https?:\/\/(www\.)?/, '').replace(/\/$/, '');
}

export function absoluteUrl(url: string): string {
  return url.startsWith('http') ? url : `https://${url}`;
}
