import * as Config from '@/config'

import type { APIRoute } from 'astro'

export const GET: APIRoute = (_) => {
  return new Response(new URL(Config.site.root).host)
}
