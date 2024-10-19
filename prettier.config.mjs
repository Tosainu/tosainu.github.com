/** @type {import("prettier").Config} */
export default {
  plugins: ['prettier-plugin-astro', 'prettier-plugin-tailwindcss'],
  semi: true,
  singleQuote: true,
  printWidth: 100,
  overrides: [
    {
      files: './src/**/*.ts',
      options: {
        semi: false,
      },
    },
    {
      files: './src/**/*.astro',
      options: {
        parser: 'astro',
        printWidth: 256,
      },
    },
  ],
};
