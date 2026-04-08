import { defineCollection, z } from 'astro:content';

const INDUSTRY_VALUES = [
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

const companies = defineCollection({
  type: 'content',
  schema: z.object({
    name: z.string(),
    website: z.string(),
    github: z.string().optional(),
    blog: z.string().optional(),
    jobs: z.string().optional(),
    industry: z.array(z.enum(INDUSTRY_VALUES)).min(1).max(3),
    location: z.object({
      city: z.string().default(''),
      state: z.string().default(''),
      country: z.string().default(''),
    }),
    lastChangedOn: z.coerce.date(),
  }),
});

export const collections = { companies };
