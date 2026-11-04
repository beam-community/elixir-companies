import { defineConfig } from 'astro/config';
import preact from '@astrojs/preact';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://elixir-companies.com',
  output: 'static',
  integrations: [preact()],
  vite: {
    plugins: [tailwindcss()],
  },
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'el', 'es', 'nl', 'ru'],
    routing: {
      prefixDefaultLocale: false,
    },
  },
});
