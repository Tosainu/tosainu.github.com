import type { AuthorWork } from '@/types'

export const site = {
  title: "Tosainu's Portfolio",
  description: "Tosainu's Portfolio Page",
  root: 'https://myon.info',
  footer: '© 2011-2023 Tosainu.',
  lang: 'en',
  gtagId: 'G-NX0M9ZW278',
  image: '/images/icon/cocoa-512.jpg',
}

export const blog = {
  title: 'Tosainu Lab',
  description: 'とさいぬのブログです',
  lang: 'ja',
  articlesInPage: 15,
}

export const author = {
  name: 'Kenta Sato',
  nickname: 'Tosainu',
  avatar: '/images/icon/cocoa.svg',
  location: 'Tokyo, Japan (~2020 Aichi, Japan)',
  birthday: 'August 15th, 1995',
  job: 'Software Engineer',
  shortbio: '❤ Arch Linux, ごちうさ',
  interests: [
    'Arch Linux',
    'Programming (C++17, Rust, Haskell)',
    'Embedded System',
    'CTF (pwn)',
    'Is the order a rabbit?',
  ],
  social: {
    twitter: 'myon___',
    twitterId: '1497302120', // in user_id
    github: 'Tosainu',
    instagram: 'myon___',
    email: 'tosainu.maple@gmail.com',
  },
}

export const authorWorks: AuthorWork[] = [
  {
    name: 'ultra96-fractal',
    url: 'https://github.com/Tosainu/ultra96-fractal',
    description: 'Hardware accelerated Julia set explorer running on Ultra96',
  },
  {
    name: 'earthly-zynqmp-example',
    url: 'https://github.com/Tosainu/earthly-zynqmp-example',
    description: '🌍 Earthly x ZynqMP',
  },
  {
    name: 'zynqmp-arch',
    url: 'https://github.com/Tosainu/zynqmp-arch',
    description: 'Unofficial Arch Linux ARM porting for Xilinx Zynq UltraScale+ devices',
  },
  {
    name: 'pwn.hs',
    url: 'https://github.com/Tosainu/pwn.hs',
    description: 'Exploit development library for Haskeller',
  },
  {
    name: 'cute_AA.txt',
    url: 'https://gist.github.com/Tosainu/47ed11f068f942026494',
    description: 'Cute Kaomoji (顔文字) dictionary',
  },
]
