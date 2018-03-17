---
title: ブログデザイン更新した
date: 2014-12-24 22:52:00+0900
tags: Website
---

どもども(✿╹◡╹)ﾉ

見ての通り, ブログのデザインを変えました.  
といってもデザイン自体はあんまり変わっていない気がしますが....

<!--more-->

## SCSS

まず, 今回のデザインからCSSではなくSCSSを使うようにしました. SCSSめっちょ便利.  
SCSSのすごいところはいっぱいあるのですが, そのなかでも`@mixin`を簡単に紹介しようと思います.

mixinは, スタイルの定義を簡単に再利用できるようにするための仕組みです.  
例えば, こんな感じに書くことができます.

```scss
@mixin button_bg($color) {
  background: $color;

  &:active, &:hover {
    background: darken($color, 20%);
  }
}

.twitter {
  @include button_bg(#55acee);
}
.hatena {
  @include button_bg(#007bca);
}
.pocket {
  @include button_bg(#ed4055);
}
.google_plus {
  @include button_bg(#c93725);
}
.adn {
  @include button_bg(#4a484d);
}
```

これをコンパイルすると, こんな感じになります.

```css
.twitter {
  background: #55acee; }
.twitter:active, .twitter:hover {
  background: #147bc9; }

.hatena {
  background: #007bca; }
.hatena:active, .hatena:hover {
  background: #003d64; }

.pocket {
  background: #ed4055; }
.pocket:active, .pocket:hover {
  background: #b61125; }

.google_plus {
  background: #c93725; }
.google_plus:active, .google_plus:hover {
  background: #731f15; }

.adn {
  background: #4a484d; }
.adn:active, .adn:hover {
  background: #171718; }
```

middlemanではSCSSのコンパイルも勝手にやってくれるので, コンパイルを全く意識することなくCSSを書く感覚で書くことが出来ました.  
また, livereloadと組み合わせることで, PCはもちろんAndroid端末までブラウザ開きっぱなしでデザインすることができて最高すぎました. (なんか日本語おかしいけど伝われ〜)

## Susy

SCSSを採用したもう一つの理由に, [Susy](http://susy.oddbird.net/)というCSS Librariesが使いたかったのがあります.

Susyは簡単にResponsiveなGrid layoutを組むことができるものです.  
例えば12カラムのレイアウトで9:3で分割したいとき, こんな感じに書くだけで実現できてしまいます.

```html
<div id="main">
  <p>メインカラム</p>
</div>
<div id="side">
  <p>サイドバー</p>
</div>
```

```scss
@import 'susy';

#main {
  @include span(9);
}

#side {
  @include span(3 last);
}
```

middlemanやRails等のRuby製アプリケーションでは, `Gemfile`に

```ruby
gem 'susy'
```

を追加して`bundle install`したりするだけで使えるようになります.

## JavaScript使ってません

僕はサーバサイドのJSは好きだけれどブラウザ上で動かすJSはあんまり好きじゃなくて(だいたい某巨大JSライブラリによる激重サイトのせい), 数世代前のデザインから**Xperia 2011でも快適に閲覧できるブログ**をコンセプトに少しづつJSを減らしていました.  
今回のデザインでは今まで愛用していたskelJSを使うのをやめ, またTwitter等のShareボタンもアイコンとリンクだけで書くことで, レイアウト/デザイン面ではすべてCSS(SCSS)だけで実現することができました.

正確には完全に脱JSしたわけではなくて, Twitterウィジェットを埋め込んだ記事やGoogle Analyticsの導入なんかでちょこっと使っていたりしますが....

## Remote Debugging

<blockquote class="twitter-tweet tw-align-center" data-partner="tweetdeck"><p>最高っぽいな? <a href="http://t.co/xIX9SqiYYk">pic.twitter.com/xIX9SqiYYk</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/547642586819600384">December 24, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

詳しくは[Remote Debugging on Android with Chrome - Google Chrome](https://developer.chrome.com/devtools/docs/remote-debugging)参照.  
これが無かったら**Chromeのデバイスエミュレートじゃ起きないけど実機だとズレる現象**が解決できませんでした.

Android端末にChromeを入れることなく, KitKatの標準ブラウザで普通に動きました.  
使い勝手は普段のDeveloper Toolsと変わることなく, 普通にパラメータ変更とかもできるからヤヴァイ.

## その他

このBlogは[Githubでビルド前の状態から公開](https://github.com/Tosainu/blog)していますが, そのレポジトリのライセンスがめちゃくちゃだったので修正(テンプレートはMIT, 記事はCopyright)したり, [詳細プロフィール](/about)の情報を更新したり, ブログ記事に付けられたタグを表示するようにしたりと, いろいろ変更しました.  
Webデザインは相変わらず苦手ですが, 少なくとも小6の頃書いたやつよりは進化してると思います.

おっと, 日付が変わりましたね.  
あんまりクリスマスとか気にする人ではないのですが, まぁ挨拶(?)だけでも.

メリークリスマス.

<blockquote class="twitter-tweet tw-align-center" data-partner="tweetdeck"><p>かんぱーい <a href="http://t.co/NStqyFOyjy">pic.twitter.com/NStqyFOyjy</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/547756612044066816">December 24, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
