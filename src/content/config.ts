import { blogSchema } from './_schema'
import { defineCollection } from 'astro:content'

const blogCollection = defineCollection({
  schema: blogSchema,
})

export const collections = {
  blog: blogCollection,
}
