---
title: (僕の)ケータイのデータふっ飛ばして妹と母親に殺された1日でした
date: 2013-12-07 01:21:50 JST
tags: Android
---
どもどもですん

&nbsp;

今日は某部活(正確にはちょっと違うけど)の現役・OBで集まりご飯食べに行ってきました〜

<blockquote class="twitter-tweet" lang="ja"><p>めしなー <a href="http://t.co/lyS2gbPLkJ">pic.twitter.com/lyS2gbPLkJ</a></p>&mdash; とさいぬ.cc (@tosainu_3930k) <a href="https://twitter.com/tosainu_3930k/statuses/408916055990353920">2013, 12月 6</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

とても楽しかったです。

特に先輩方と再び会えたのがとても良かった！！

もう懐かしくて懐かしくて・・・少しあの頃に戻りたいなと思ってみたり。

(ただしあの部の活動はもうやりたくありません)

&nbsp;

本題。

<a href="http://juggly.cn/archives/101440.html">Xperia 2011モデルにAndroid 4.4（KitKat）を提供しようというプロジェクト「LegacyXperia Project」が始動 | juggly.cn</a>

<a href="http://legacyxperia.github.io/">LegacyXperia Project</a>

<span class="fontsize7">キタ———(゜∀゜)———— !!</span>

本当に、有志様方の素晴らしい努力に感動と感謝でいっぱいです。

ってことで友人氏のXperia Rayを借りて早速試していたわけです。

<blockquote class="twitter-tweet" lang="ja"><p>なう！ <a href="http://t.co/fsMGQPUaz4">pic.twitter.com/fsMGQPUaz4</a></p>&mdash; とさいぬ.cc (@tosainu_3930k) <a href="https://twitter.com/tosainu_3930k/statuses/408844229184479232">2013, 12月 6</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

後日動画付きのレビューでもしようと思います。

&nbsp;

んで、問題なくKitKat動いたのは良かったのですが、どうもインストールの段階でトンデモナイミスを犯してしまったようで。

1. 借りたRayにSDカードが刺さっていなかったので、自分のArc(兼妹と母親のゲーム機)からSDを持ってくる
2. RayたんにKernel焼き、CWMrecoveryから<span style="color:red;">FactoryReset</span>
3. Rayたん無事KitKat起動確認、SDカードをArcに戻す
4. Arcたん起動、<span style="color:red;">アプリケーション全く読み込まない</span>

原因は赤文字部分。

なんせ大量にゲームを入れていたわけですから、当然2011Xperiaの内部ストレージには入りきりません。

SDカード上にExt4で別パーティションを作成し、S2Eで/dataを移していたわけです。

しかしCWMRecoveryのFactoryReset、こいつが<span style="color:red;">別パーティションのフォーマットもしてしまう</span>ことをすっかり忘れ実行してしまったのです。

<span class="fontsize7">＼(^o^)／ｵﾜﾀ</span>

&nbsp;

当然ゲームデータは消滅、妹と母親に殺されました。

皆さんも他の端末に常用中のSDカードを入れるときは十分注意しませう。

ではでは〜
