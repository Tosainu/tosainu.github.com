/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        darkgray: '#3f434a',
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            '--tw-prose-body': theme('colors.darkgray'),
            '--tw-prose-links': theme('colors.sky[700]'),
            '--tw-prose-headings': 'inherit',
            '--tw-prose-code': 'inherit',
            'code::before': {
              content: 'none',
            },
            'code::after': {
              content: 'none',
            },
            fontSize: 'inherit',
            lineHeight: 'inherit',
            maxWidth: '100%',
          },
        },
      }),
    },
  },
  plugins: [require('@tailwindcss/typography')],
};
