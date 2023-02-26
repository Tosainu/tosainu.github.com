import { z } from 'astro:content'

export const blogSchema = z
  .object({
    title: z.string(),
    tags: z.array(z.string()).default([]),
    date: z.string().optional(),
    description: z.string().optional(),
    noindex: z.boolean().optional(),
  })
  .strict()

export type BlogSchema = z.infer<typeof blogSchema>
