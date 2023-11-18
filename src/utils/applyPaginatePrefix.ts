import type { Page, Params, Props } from 'astro'

const applyPaginatePrefix = <
  PageData,
  PaginateParams extends Params & { page: string | undefined },
  PaginateProps extends Props & { page: Page<PageData> },
>(
  data: { params: PaginateParams; props: PaginateProps }[],
  prefix: string,
) =>
  data.map(({ params, props }) => {
    const { currentPage, url } = props.page
    return {
      params: {
        ...params,
        page: params.page === undefined ? undefined : prefix + params.page,
      },
      props: {
        ...props,
        page: {
          ...props.page,
          url: {
            current: url.current.replace(new RegExp(`/(${currentPage}/?)$`), `/${prefix}$1`),
            next: url.next?.replace(new RegExp(`/(${currentPage + 1}/?)$`), `/${prefix}$1`),
            prev: url.prev?.replace(new RegExp(`/(${currentPage - 1}/?)$`), `/${prefix}$1`),
          },
        },
      },
    }
  })

export default applyPaginatePrefix
