import { defineCollection } from 'astro:content'
import { z } from 'astro/zod'
import { glob } from 'astro/loaders'

const blog = defineCollection({
  loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: './src/content/blog' }),
  schema: ({ image }) =>
    z
      .object({
        title: z.string(),
        tags: z.array(z.string()).default([]),
        date: z.string().optional(),
        description: z.string().optional(),
        noindex: z.boolean().optional(),
        cover: image().optional(),
      })
      .strict(),
})

export const collections = { blog }
