import * as Config from '@/config'

import type { APIRoute } from 'astro'

export const get: APIRoute = (_) => {
  return {
    body: new URL(Config.site.root).host,
  }
}
