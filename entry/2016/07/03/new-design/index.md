---
title: とさいぬの隠し部屋はTosainu Labになりました
date: 2016-07-03 23:59:00+0900
tags: Middleman, Ruby, Website
math: true
---

タイトルの通りです.  
"とさいぬの隠し部屋" は **"Tosainu Lab"** になりました.

理由としては, 最近

<blockquote class="twitter-tweet tw-align-center" data-partner="tweetdeck"><p lang="ja" dir="ltr">ブログタイトル, 〇〇の部屋ってあたりが数世代前のｲﾝﾀｰﾈｯﾂ感出してるのでそろそろ変えたい</p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/747791333436186624">June 28, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

という思いが強まっていたからです.  
丁度ブログデザインも少し修正したいなーと思っていたので, たまたま休講だった金曜日から一気にコードを書き上げました.

新タイトルはとさいぬのブログだという雰囲気を残しつつ, 少し変わったものにしようとしましたが良さげなものが思い浮かばず...  
結局とさいぬという言葉は残し, また技術ネタを中心にしていこうということでLabと付けました.  
古臭さは抜けたかもしれないけど, カッコよくなったかはちょっと微妙ですね...  
まぁいっか.

<!--more-->

## その他の変更点

### KaTeXの導入

技術ネタを中心にしていこうということで, 以前から興味のあった数式表示を導入しました.  
ってことで, とりあえずMaxwllの方程式を置いておきます.

$$
\begin{aligned}
\nabla \times \vec{E} &= - \frac{\partial\vec{B}}{\partial t}\\
\nabla \times \vec{H} &= \sigma\vec{E} + \frac{\partial\vec{D}}{\partial t}\\
\nabla \cdot \vec{D} &= \rho\\
\nabla \cdot \vec{B} &= 0
\end{aligned}
$$

この手で有名なのはやっぱり[MathJax](https://www.mathjax.org/)ですが, [前回のデザイン変更](/entry/2014/12/24/new_blog_theme/)で書いたようにあまり重量級Webサイトにしたくないという点でうーんという感じです. 何より静的サイトジェネレータ信者である僕としては**ブラウザで開かれたときに構文解析/レンダリングが行われる**というのがもう許せないです.

そこで見つけたのが**[KaTeX](https://khan.github.io/KaTeX/)**です. とりあえず左のリンクから公式の紹介サイトへ行き, `Type an expression:`のところに式を入れてみてください. **!?**となると思います.  
流石, **The fastest math typesetting library for the web.** と謳っているだけはありますね.

もちろん, KaTeXを選んだ理由はこれだけではありません. なんと**Server side renderingが可能**なんです!!!  
つまり, 予めKaTeXのJavaScriptを呼んで式を処理しておけば, **表示するときはCSSだけで良い**のです!!! すっごくないですかっ!? (友利奈緒)

とはいえ, このブログの生成に使っている[Middleman](https://middlemanapp.com/)はRuby製です.  
ということで, [ExecJS](https://github.com/rails/execjs)を使った[ラッパクラスを作成](https://github.com/Tosainu/blog/blob/8e9fa81b873719f107016e47f5b1d6c39e4e15fb/lib/katex.rb)し, markdownパーサの[Redcarpet](https://github.com/vmg/redcarpet)を[拡張して](https://github.com/Tosainu/blog/blob/8e9fa81b873719f107016e47f5b1d6c39e4e15fb/lib/custom_renderer.rb)強引に対応させました.  
RedcarpetのAPI都合上, 数式をcode spanやcode blockの中に記述しないといけないという仕様になっていますが, もし同じようなこと考えている方がいたら(いない)参考ししてもらえると良いかなと思います.[^1]

[^1]: Kramdownは数式エンジン対応が公式であって強いのだけど, GFM Parserを選択しても微妙に挙動が違って移行できなかった

### サイドバー

コードの汚い部分や重複を改善したり, SCSSを複数に分割したり, `compass/reset`から[normalize.css](https://necolas.github.io/normalize.css/)に移行といったリファクタリング的な修正が多く, あまり表に見える変更点は少ないのですが, サイドバーはかなり変わったと思います.

まずタグクラウドです. 今まではMiddleman-blogのタグ機能をカテゴリのように使っていましたが, 件数が増えて縦に長くなってきたので, もっとすっきりさせようということでこうしました.  
実装は[Wikipediaにあったアルゴリズム](https://en.wikipedia.org/wiki/Tag_cloud#Creation_of_a_tag_cloud)を参考に,

$$
s_i = f_{max} \cdot \frac{t_i - t_{min}}{t_{max} - t_{min}} + f_{min}
$$

- $s_i$: 表示するフォントサイズ
- $f_{min}$: 最小のフォントサイズ
- $f_{max}$: 最大のフォントサイズから$f_{min}$を引いた値
- $t_i$: 現在のタグがついた記事数
- $t_{max}, t_{min}$: タグあたりの最大, 最小の記事数

という感じにしました. 実際のSlimで書かれたテンプレートが[これ](https://github.com/Tosainu/blog/blob/8e9fa81b873719f107016e47f5b1d6c39e4e15fb/source/partials/_sidebar.slim#L24-L36)です.

年/月毎のアーカイブのリンクも同様の理由でコンパクトにまとめました. ~~どう見てもはてなブログです~~.  
とはいえ, これもよくある手法を使ってCSSだけで実現しています.

### Twitter cardsの画像対応等

Twitter使っているならば対応させておきたいのが[Twitter Cards](https://dev.twitter.com/cards/overview)です.  
これは前回のデザイン変更で導入していたのですが, **どのページのリンクでも同じ内容が表示される**という雑なものでした.

そこで, 今回の変更でそれなりにマトモなものにしました.  
まず, [こんな感じのヘルパ関数を追加](https://github.com/Tosainu/blog/blob/8e9fa81b873719f107016e47f5b1d6c39e4e15fb/helpers/custom_helpers.rb#L23-L41)して, 本文の先頭150字, 記事に貼られた画像を取得できるようにしました.  
そして, [Twitter CardsだけでなくOpen Graphのタグを設定](https://github.com/Tosainu/blog/blob/8e9fa81b873719f107016e47f5b1d6c39e4e15fb/source/layouts/default.slim#L10-L21)することで, その他の対応しているサービスでも利用できるようにしました.

<blockquote class="twitter-tweet tw-align-center" data-lang="en"><p lang="ja" dir="ltr">てすと <a href="https://t.co/8PHeWUpvua">https://t.co/8PHeWUpvua</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/749618315903971328">July 3, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

記事の画像を取得するヘルパ関数は**markdownからHTMLに変換された記事をNokogiriでparse**みたいな気持ちの悪いことをしているので, いつかなんとかできると良いなぁと. (たぶんしない)

## おわり

これからもよろしくお願いします!!!
