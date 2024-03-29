import { defineConfig } from 'astro/config';

import mdx from '@astrojs/mdx';
import rehypeKatex from 'rehype-katex';
import remarkMath from 'remark-math';
import tailwind from '@astrojs/tailwind';

// https://astro.build/config
export default defineConfig({
  build: {
    format: 'directory',
  },
  integrations: [
    tailwind({
      config: {
        applyBaseStyles: false,
      },
    }),
    mdx(),
  ],
  markdown: {
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeKatex],
  },
  output: 'static',
  trailingSlash: 'always',
});
