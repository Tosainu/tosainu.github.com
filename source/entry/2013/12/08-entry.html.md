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

<div class="video-container"><iframe width="560" height="315" src="https://www.youtube.com/embed/2ii13L6zgsA?rel=0" frameborder="0" allowfullscreen></iframe></div>
</div>
思っていた以上にサクサクと動いてくれました。

ただし、1:30あたりからのBrowsing Testにもあるように、ブラウザ周りが使い物にならないほど重くなっています。

もちろん、動画内で使っているブラウザ以外でも試しましたがどれも重く、Twitterアプリの認証画面などまで重くなっていました。

&nbsp;

実行中のアプリ一覧の画面

<img src="https://lh5.googleusercontent.com/-MkgJZzHulcE/UqQomN9IsVI/AAAAAAAACzI/zxQUsGg9-Ik/s640/Screenshot_2013-12-08-10-08-50.png" />

&nbsp;

有名なベンチマークを2つ回してみました。

### Quadrant Standard Edition

左:定格 右:1.4GHz-OC

<img src="https://lh3.googleusercontent.com/-a6boOgc04KY/UqQokyCToGI/AAAAAAAACyw/bDS1IQzuBJk/s640/Screenshot_2013-12-08-09-54-53.png" />

### AnTuTu Benchmark

左:定格 右:1.4GHz-OC

<img src="https://lh4.googleusercontent.com/-0XZv2H5SzL4/UqQokhUl2WI/AAAAAAAACyo/neF8zxVBoNs/s640/Screenshot_2013-12-08-09-29-47.png" />

このHa Haはスコアをバカにしているのでしょうか？？？

こんな中華アプリ二度と使わねぇ・・・

<img src="https://lh4.googleusercontent.com/-ZervDLWZioQ/UqQolO-XXrI/AAAAAAAACy4/u1yQou4SB3c/s640/Screenshot_2013-12-08-09-56-39.png" />

&nbsp;

ほか、カメラなどもどれも完璧に動きましたが、僕の環境では電話がうまく動いてくれませんでした。

実用はまだ先な感じですね。

しかしまぁ、有志様方仕事が早い・・・

僕もAOSPソース用のデバイス定義ファイルくらい書けるようになりたいですね()

&nbsp;

それでは〜
