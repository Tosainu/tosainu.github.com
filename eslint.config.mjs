import astro from 'eslint-plugin-astro';
import globals from 'globals';
import js from '@eslint/js';
import sortDestructureKeys from 'eslint-plugin-sort-destructure-keys';
import typescript from 'typescript-eslint';

export default typescript.config(
  {
    ignores: ['dist/**', '**/*.d.ts'],
  },

  js.configs.recommended,
  ...typescript.configs.recommended,
  ...astro.configs['flat/recommended'],

  {
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'module',
      globals: {
        ...globals.browser,
        ...globals.es2021,
        ...globals.node,
      },
    },
  },

  {
    plugins: {
      ['sort-destructure-keys']: sortDestructureKeys,
    },
    rules: {
      '@typescript-eslint/no-unused-vars': [
        'warn',
        {
          argsIgnorePattern: '^_',
          destructuredArrayIgnorePattern: '^_',
          varsIgnorePattern: '^_',
          ignoreRestSiblings: true,
        },
      ],
      'sort-destructure-keys/sort-destructure-keys': ['warn', { caseSensitive: false }],
    },
  },
);
