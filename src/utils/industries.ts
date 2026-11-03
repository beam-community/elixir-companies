export const INDUSTRY_VALUES = [
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

export type Industry = (typeof INDUSTRY_VALUES)[number];
