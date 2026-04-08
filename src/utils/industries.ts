export const INDUSTRIES = [
  'Agriculture & Food',
  'Communication Services',
  'Consumer Discretionary',
  'Consumer Staples',
  'Education',
  'Energy',
  'Financials',
  'Government & Non-Profit',
  'Health Care',
  'Industrials',
  'Information Technology',
  'Materials',
  'Media & Entertainment',
  'Professional Services',
  'Real Estate',
  'Transportation',
  'Utilities',
] as const;

export type Industry = (typeof INDUSTRIES)[number];

const INDUSTRY_COLORS: Record<string, string> = {
  'Agriculture & Food': 'bg-lime-100 text-lime-800 dark:bg-lime-900 dark:text-lime-200',
  'Communication Services': 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200',
  'Consumer Discretionary': 'bg-pink-100 text-pink-800 dark:bg-pink-900 dark:text-pink-200',
  'Consumer Staples': 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200',
  'Education': 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200',
  'Energy': 'bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-200',
  'Financials': 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200',
  'Government & Non-Profit': 'bg-stone-100 text-stone-800 dark:bg-stone-900 dark:text-stone-200',
  'Health Care': 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200',
  'Industrials': 'bg-slate-100 text-slate-800 dark:bg-slate-900 dark:text-slate-200',
  'Information Technology': 'bg-violet-100 text-violet-800 dark:bg-violet-900 dark:text-violet-200',
  'Materials': 'bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-200',
  'Media & Entertainment': 'bg-rose-100 text-rose-800 dark:bg-rose-900 dark:text-rose-200',
  'Professional Services': 'bg-fuchsia-100 text-fuchsia-800 dark:bg-fuchsia-900 dark:text-fuchsia-200',
  'Real Estate': 'bg-teal-100 text-teal-800 dark:bg-teal-900 dark:text-teal-200',
  'Transportation': 'bg-cyan-100 text-cyan-800 dark:bg-cyan-900 dark:text-cyan-200',
  'Utilities': 'bg-indigo-100 text-indigo-800 dark:bg-indigo-900 dark:text-indigo-200',
};

export function getIndustryColor(industry: string): string {
  return INDUSTRY_COLORS[industry] || 'bg-gray-100 text-gray-800 dark:bg-gray-800 dark:text-gray-200';
}

const INDUSTRY_ICONS: Record<string, string> = {
  'Agriculture & Food': '🌾',
  'Communication Services': '📡',
  'Consumer Discretionary': '🛍️',
  'Consumer Staples': '🏪',
  'Education': '🎓',
  'Energy': '⚡',
  'Financials': '💰',
  'Government & Non-Profit': '🏛️',
  'Health Care': '🏥',
  'Industrials': '🏭',
  'Information Technology': '💻',
  'Materials': '🔬',
  'Media & Entertainment': '🎬',
  'Professional Services': '💼',
  'Real Estate': '🏠',
  'Transportation': '🚀',
  'Utilities': '🔧',
};

export function getIndustryIcon(industry: string): string {
  return INDUSTRY_ICONS[industry] || '🏢';
}
