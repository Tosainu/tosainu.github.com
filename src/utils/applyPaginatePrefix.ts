import type { GetStaticPathsResult, GetStaticPathsItem, Page } from 'astro'

const applyPaginatePrefix = (
  staticPaths: GetStaticPathsResult,
  prefix: string
): GetStaticPathsResult =>
  staticPaths.map(({ params, props }): GetStaticPathsItem => {
    const paramName = 'page'

    const newParams = {
      ...params,
      [paramName]: params[paramName] === undefined ? undefined : prefix + params[paramName],
    }

    if (props === undefined || props[paramName] === undefined) {
      return { params, props: undefined }
    }

    const page = props[paramName] as Page
    const pageNum = page.currentPage
    const url = page.url

    const newProps = {
      ...props,
      [paramName]: {
        ...page,
        url: {
          ...(url.current && {
            current: url.current.replace(new RegExp(`/(${pageNum}/?)$`), `/${prefix}$1`),
          }),
          ...(url.next && {
            next: url.next.replace(new RegExp(`/(${pageNum + 1}/?)$`), `/${prefix}$1`),
          }),
          ...(url.prev && {
            prev: url.prev.replace(new RegExp(`/(${pageNum - 1}/?)$`), `/${prefix}$1`),
          }),
        },
      },
    }

    return { params: newParams, props: newProps }
  })

export default applyPaginatePrefix
