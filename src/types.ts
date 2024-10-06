export type NavigationLink = {
  name: string
  url: string
}

export type AuthorWork = {
  name: string
  url: string
  imageUrl: string
  description: string
}

export interface SiteProps {
  pageTitle: string
  lang: string
  description: string
  noindex?: boolean
}
