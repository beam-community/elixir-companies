module.exports = {
  purge: [
    '../lib/coin_purse_web/**/*.ex',
    '../lib/coin_purse_web/**/*.leex',
    '../lib/coin_purse_web/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      keyframes: {
        fade: {
          '0%': {
            opacity: '0'
          },
          '100%': {
            opacity: '1'
          },
        }
      },
      animation: {
        fade: 'fade 1s ease-in',
      },
      colors: {
        'brand-purple': '#63487f',
        'brand-pink': '#fe6886'
      },
    },
  },
  variants: {},
  plugins: [
    require('@tailwindcss/aspect-ratio')
  ],
}
