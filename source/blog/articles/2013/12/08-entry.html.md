---
title: Android 4.4 KitKat on Xperia Ray
date: 2013-12-08 17:20:17 JST
tags: Android
---
Ubuntu Touchを焼いた時の記事はこちら→<a href="http://tosainu.wktk.so/view/295">Ubuntu Touch on XPERIA Ray</a>

&nbsp;

どーもです。

昨日の記事にあるとおり、Xperia RayにAndroid 4.4を焼いてみました。


&nbsp;

## 準備

用意するもの

* Unlocked XPERIA2011（アンロック必須）
* AndroidSDK又はFlashtool（fastbootコマンドでカーネルを焼きます）

&nbsp;

ダウンロードするファイル

<a href="http://legacyxperia.github.io/">LegacyXperia Project</a>にアクセスし、

Useful linksのDownloads→cm11.0と進み、

* gapps-kk-20131119-lite.zip

さらに、自分の端末のフォルダ→nightliesと進み、

* cm-11.0-20131127-LX-NIGHTLY-xxxxxx.zip

をダウンロードします。ファイル名はこの記事執筆当時のものなので、変更される場合があります。

&nbsp;

## 焼く

<span style="color:red;">BBバージョンの関係で起動しない場合があると思われるので、予めICS以上の公式ファームを焼いておきます。</span>

手順は以前書いた記事とほとんど変わらないので、そちらを参考にしてください。→<a href="http://tosainu.wktk.so/page/customrom">カスタムROMを書き込んでみる</a>

&nbsp;

## 感想のようなもの

動かしてみた様子を動画にしてみました。

<div class="video"><iframe width="560" height="315" src="//www.youtube.com/embed/2ii13L6zgsA?rel=0" frameborder="0" allowfullscreen></iframe>
</div>
思っていた以上にサクサクと動いてくれました。

ただし、1:30あたりからのBrowsing Testにもあるように、ブラウザ周りが使い物にならないほど重くなっています。

もちろん、動画内で使っているブラウザ以外でも試しましたがどれも重く、Twitterアプリの認証画面などまで重くなっていました。

&nbsp;

実行中のアプリ一覧の画面

<a href="https://picasaweb.google.com/lh/photo/7gM_O3jGhLdzussKr_VKl9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-MkgJZzHulcE/UqQomN9IsVI/AAAAAAAACzI/zxQUsGg9-Ik/s400/Screenshot_2013-12-08-10-08-50.png" height="400" width="225" /></a>

&nbsp;

有名なベンチマークを2つ回してみました。

### Quadrant Standard Edition

左:定格 右:1.4GHz-OC

<a href="https://picasaweb.google.com/lh/photo/HbTUPP3xKrc07LS3qkJyj9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-y2zd33q5gKA/UqQol2YhFwI/AAAAAAAACzE/Iks5_FxY7rM/s400/Screenshot_2013-12-08-10-03-05.png" height="400" width="225" /></a><a href="https://picasaweb.google.com/lh/photo/T__zAPMHanMLhk3_uRXzs9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh3.googleusercontent.com/-a6boOgc04KY/UqQokyCToGI/AAAAAAAACyw/bDS1IQzuBJk/s400/Screenshot_2013-12-08-09-54-53.png" height="400" width="225" /></a>

### AnTuTu Benchmark

左:定格 右:1.4GHz-OC

<a href="https://picasaweb.google.com/lh/photo/YG28Gf-lky5BsjSv-Zlxh9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-sdylBQdCbes/UqQolR7HwrI/AAAAAAAACy8/MGXZOWLnC2s/s400/Screenshot_2013-12-08-10-00-41.png" height="400" width="225" /></a><a href="https://picasaweb.google.com/lh/photo/Kd0qLymmyvYY6hUlsU7CPNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-0XZv2H5SzL4/UqQokhUl2WI/AAAAAAAACyo/neF8zxVBoNs/s400/Screenshot_2013-12-08-09-29-47.png" height="400" width="225" /></a>

このHa Haはスコアをバカにしているのでしょうか？？？

こんな中華アプリ二度と使わねぇ・・・

<a href="https://picasaweb.google.com/lh/photo/O8OOx3I2hCWITwCIvxFwE9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-ZervDLWZioQ/UqQolO-XXrI/AAAAAAAACy4/u1yQou4SB3c/s400/Screenshot_2013-12-08-09-56-39.png" height="400" width="225" /></a>

&nbsp;

ほか、カメラなどもどれも完璧に動きましたが、僕の環境では電話がうまく動いてくれませんでした。

実用はまだ先な感じですね。

しかしまぁ、有志様方仕事が早い・・・

僕もAOSPソース用のデバイス定義ファイルくらい書けるようになりたいですね()

&nbsp;

それでは〜