/** @type {import('tailwindcss').Config} */

// Theme-aware colours resolve to CSS variables set in global.css (light on :root, dark on .dark).
const themed = (name) => `rgb(var(--${name}) / <alpha-value>)`;

export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        ground: themed('ground'),
        surface: themed('surface'),
        ink: themed('ink'),
        body: themed('body'),
        muted: themed('muted'),
        line: { DEFAULT: themed('line'), soft: themed('line-soft') },
        field: themed('field'),
        tint: { DEFAULT: themed('tint'), strong: themed('tint-strong'), border: themed('tint-border') },
        link: { DEFAULT: themed('link'), hover: themed('link-hover') },
        pill: themed('pill'),
        hiring: { bg: themed('hiring-bg'), text: themed('hiring-text') },

        // Fixed in both themes: the plum header band and purple brand fills.
        plum: {
          DEFAULT: '#1C0E2B',
          deep: '#120820',
          raised: '#2E1A45',
          border: '#4A3463',
          text: '#F6F1FB',
          soft: '#D9CFE8',
          dim: '#C9BEDA',
        },
        elixir: {
          600: '#5B2A86',
          700: '#4A2170',
        },
        amber: {
          DEFAULT: '#F4C152',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['"Bricolage Grotesque"', 'system-ui', 'sans-serif'],
        mono: ['"JetBrains Mono"', 'ui-monospace', 'monospace'],
      },
    },
  },
  plugins: [require('@tailwindcss/typography')],
};
