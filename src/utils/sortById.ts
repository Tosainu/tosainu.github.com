interface HasId {
  id: string
}

const sortById = <T extends HasId>(xs: T[]): T[] =>
  xs.sort(({ id: a }, { id: b }) => b.localeCompare(a))

export default sortById
