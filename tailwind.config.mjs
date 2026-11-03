/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        // Core palette from the redesign canvas
        ink: '#1B1325',
        muted: '#5E5670',
        line: '#E7E3EE',
        ground: '#FBFAFD',
        plum: {
          DEFAULT: '#1C0E2B', // hero / dark surfaces
          deep: '#120820',
          raised: '#2E1A45',
          border: '#4A3463',
          text: '#F6F1FB',
          soft: '#D9CFE8',
          dim: '#C9BEDA',
        },
        elixir: {
          50: '#F3EFF8',
          100: '#F1EAF8',
          200: '#E2DAEC',
          600: '#5B2A86',
          700: '#4A2170',
          800: '#3D1A5E',
        },
        amber: {
          DEFAULT: '#F4C152',
        },
        hiring: {
          bg: '#E3F4EC',
          text: '#1D6B48',
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
