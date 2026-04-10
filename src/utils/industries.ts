const INDUSTRY_DATA = {
  'Agriculture & Food': { color: 'bg-lime-100 text-lime-800 dark:bg-lime-900 dark:text-lime-200', icon: '🌾' },
  'Communication Services': { color: 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200', icon: '📡' },
  'Consumer Discretionary': { color: 'bg-pink-100 text-pink-800 dark:bg-pink-900 dark:text-pink-200', icon: '🛍️' },
  'Consumer Staples': { color: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200', icon: '🏪' },
  'Education': { color: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200', icon: '🎓' },
  'Energy': { color: 'bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-200', icon: '⚡' },
  'Financials': { color: 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200', icon: '💰' },
  'Government & Non-Profit': { color: 'bg-stone-100 text-stone-800 dark:bg-stone-900 dark:text-stone-200', icon: '🏛️' },
  'Health Care': { color: 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200', icon: '🏥' },
  'Industrials': { color: 'bg-slate-100 text-slate-800 dark:bg-slate-900 dark:text-slate-200', icon: '🏭' },
  'Information Technology': { color: 'bg-violet-100 text-violet-800 dark:bg-violet-900 dark:text-violet-200', icon: '💻' },
  'Materials': { color: 'bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-200', icon: '🔬' },
  'Media & Entertainment': { color: 'bg-rose-100 text-rose-800 dark:bg-rose-900 dark:text-rose-200', icon: '🎬' },
  'Professional Services': { color: 'bg-fuchsia-100 text-fuchsia-800 dark:bg-fuchsia-900 dark:text-fuchsia-200', icon: '💼' },
  'Real Estate': { color: 'bg-teal-100 text-teal-800 dark:bg-teal-900 dark:text-teal-200', icon: '🏠' },
  'Transportation': { color: 'bg-cyan-100 text-cyan-800 dark:bg-cyan-900 dark:text-cyan-200', icon: '🚀' },
  'Utilities': { color: 'bg-indigo-100 text-indigo-800 dark:bg-indigo-900 dark:text-indigo-200', icon: '🔧' },
} as const;

export const INDUSTRY_VALUES = Object.keys(INDUSTRY_DATA) as [string, ...string[]];

export type Industry = keyof typeof INDUSTRY_DATA;

export function getIndustryColor(industry: string): string {
  return (INDUSTRY_DATA as Record<string, { color: string }>)[industry]?.color
    || 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200';
}

export function getIndustryIcon(industry: string): string {
  return (INDUSTRY_DATA as Record<string, { icon: string }>)[industry]?.icon || '🏢';
}
