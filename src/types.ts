export type AuthorWork = {
  name: string
  url: string
  description: string
}

export interface SiteProps {
  pageTitle: string
  lang: string
  description: string
  noindex?: boolean
}
