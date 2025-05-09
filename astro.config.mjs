import { defineConfig } from 'astro/config';

import mdx from '@astrojs/mdx';
import preact from '@astrojs/preact';
import rehypeKatex from 'rehype-katex';
import remarkMath from 'remark-math';

import tailwindcss from '@tailwindcss/vite';

import fs from 'node:fs';

const langDts = JSON.parse(
  fs.readFileSync('third_party/vscode-devicetree/syntaxes/dts.tmLanguage.json', 'utf8'),
);
const langEarthfile = JSON.parse(
  fs.readFileSync('third_party/earthfile-grammar/syntaxes/earthfile.tmLanguage.json', 'utf8'),
);
const langLlvm = JSON.parse(
  fs.readFileSync('third_party/llvm-syntax-highlighting/syntaxes/llvm.tmLanguage.json', 'utf8'),
);

// https://astro.build/config
export default defineConfig({
  build: {
    format: 'directory',
  },
  integrations: [mdx(), preact()],
  markdown: {
    shikiConfig: {
      langs: [langDts, langEarthfile, langLlvm],
      langAlias: {
        dts: 'DTS',
        llvm: 'LLVM',
      },
    },
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeKatex],
  },
  output: 'static',
  trailingSlash: 'always',
  vite: {
    plugins: [tailwindcss()],
  },
});
