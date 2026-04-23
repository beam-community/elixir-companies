import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';
import { INDUSTRY_VALUES } from './utils/industries';

const companies = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/companies' }),
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
