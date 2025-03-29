import { defineCollection, z } from 'astro:content'

const blogCollection = defineCollection({
  schema: z
    .object({
      title: z.string(),
      tags: z.array(z.string()).default([]),
      date: z.string().optional(),
      description: z.string().optional(),
      noindex: z.boolean().optional(),
    })
    .strict(),
})

export const collections = {
  blog: blogCollection,
}
