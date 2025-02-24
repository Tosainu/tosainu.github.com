import type { AuthorWork, NavigationLink } from '@/types'

export const site = {
  title: "Tosainu's Portfolio",
  description: "Tosainu's Portfolio Page",
  root: 'https://myon.info',
  footer: '© 2011-2024 Tosainu.',
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

export const links: NavigationLink[] = [
  {
    name: 'Photos',
    url: 'https://photos.myon.info',
  },
  {
    name: 'Blog',
    url: '/blog/',
  },
]

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
    'Programming (Rust, Haskell, C++20)',
    'Embedded System (Zynq UltraScale+, RP2040)',
    'CTF (pwn)',
    'Camera',
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
    name: 'gnss-7-seg-clock',
    url: 'https://github.com/Tosainu/gnss-7-seg-clock',
    imageUrl: '/images/gnss-7-seg-clock.jpg',
    description: 'GNSS-powered, seven-segment table clock ',
  },
  {
    name: 'bp35c0-j11-stuff',
    url: 'https://github.com/Tosainu/bp35c0-j11-stuff',
    imageUrl: '/images/bp35c0-j11-stuff.jpg',
    description: 'Energy meter built by BP35C0-J11 and RP2040',
  },
  {
    name: 'ultra96-fractal',
    url: 'https://github.com/Tosainu/ultra96-fractal',
    imageUrl: '/images/ultra96-fractal.jpg',
    description: 'Hardware accelerated Julia set explorer running on Ultra96',
  },
  {
    name: 'earthly-zynqmp-example',
    url: 'https://github.com/Tosainu/earthly-zynqmp-example',
    imageUrl: '/images/earthly-zynqmp-example.jpg',
    description: '🌍 Earthly x ZynqMP',
  },
  {
    name: 'zynqmp-arch',
    url: 'https://github.com/Tosainu/zynqmp-arch',
    imageUrl: '/images/zynqmp-arch.png',
    description: 'Unofficial Arch Linux ARM porting for Xilinx Zynq UltraScale+ devices',
  },
  {
    name: 'pwn.hs',
    url: 'https://github.com/Tosainu/pwn.hs',
    imageUrl: '/images/pwn.hs.png',
    description: 'Exploit development library for Haskeller',
  },
  {
    name: 'cute_AA.txt',
    url: 'https://gist.github.com/Tosainu/47ed11f068f942026494',
    imageUrl: '/images/cute_AA.png',
    description: 'Cute Kaomoji (顔文字) dictionary',
  },
]
