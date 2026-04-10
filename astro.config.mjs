import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import preact from '@astrojs/preact';

export default defineConfig({
  site: 'https://elixir-companies.com',
  output: 'static',
  integrations: [tailwind(), preact()],
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'el', 'es', 'nl', 'ru'],
    routing: {
      prefixDefaultLocale: false,
    },
  },
});
