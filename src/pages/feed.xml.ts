import * as Config from '@/config'

import type { APIRoute } from 'astro'
import rss from '@astrojs/rss'
import { getCollection } from 'astro:content'

export const GET: APIRoute = async (_) => {
  const blog = await getCollection('blog', ({ data }) => !(data.noindex ?? false))
  return rss({
    title: Config.blog.title,
    description: Config.blog.description,
    site: Config.site.root,
    items: blog.map(({ body, data, slug }) => {
      const [year, month, day, _slug] = slug.split('/')
      return {
        title: data.title,
        pubDate: new Date(parseInt(year), parseInt(month) - 1, parseInt(day)),
        link: `/blog/${slug}/`,
        content: body,
      }
    }),
  })
}
