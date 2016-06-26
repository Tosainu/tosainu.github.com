---
title: Node.jsでTwitterAPI使っていろいろやった
date: 2014-02-11 00:36:43 JST
tags: JavaScript
---
全く....テスト前に何やってるんでしょうか.........

&nbsp;

Node.jsでTwitterAPI使っていろいろやってみました。

Node.jsにはたくさんのライブラリがありますが・・・・・

<a href="https://github.com/jdub/node-twitter">jdub/node-twitter</a>

<a href="https://github.com/AvianFlu/ntwitter">AvianFlu/ntwitter</a>

<img src="https://lh3.googleusercontent.com/-IwaX61k-PCE/Uvjq1-uvLzI/AAAAAAAAC-M/bHp5vFFvzZo/s400/2014-02-11-000342_1920x1080_scrot.png" height="400" width="303" />

っとこんな状態のものばかり・・・・

&nbsp;

そんな中、比較的活発で、且つ高性能なライブラリを見つけました。

<a href="https://github.com/ttezel/twit">ttezel/twit</a>

StreamingAPIはもちろん対応。叩くAPIを直接指定するタイプでかなり使いやすいです。

```
$ npm install twit
```

でインストールできます。

&nbsp;

作ったもの

<a href="https://gist.github.com/Tosainu/8913172">Node.jsで書いたエ○フォ的な何か</a>

<a href="https://gist.github.com/Tosainu/8917166">Node.jsで書いた流行のupdate_name</a>
