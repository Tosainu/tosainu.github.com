---
title: FirefoxでinnerTextが使えない件
date: 2013-12-16 22:19:11 JST
tags: JavaScript
---
みょん。

&nbsp;

以前Node.js使ってラジコン制御をしていましたが、またNode.jsで遊びたくなったのでいろいろやってました。

<blockquote class="twitter-tweet" lang="ja"><p>鯖落ちしない程度に遊びに来てください&#10;<a href="http://t.co/nTszQEEeb9">http://t.co/nTszQEEeb9</a></p>&mdash; とさいぬ.conf (@tosainu_3930k) <a href="https://twitter.com/tosainu_3930k/statuses/412204978271297537">2013, 12月 15</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

ログ保存機能がまだ実装されていないクソなチャットです。Socket.ioを使いリアルタイムでやりとりできます。

（記事執筆当時は稼働させていません）

&nbsp;

そんなこともあってまたJavaScriptを書いていましたが、ちょっと面倒なことに遭遇したのでメモ。

&nbsp;

innerTextというオブジェクト内の文字列を参照したり書き換えたりもできるプロパティがあるのですが、どうもこれがFirefox系のブラウザで動作しないようです。

<a href="http://filipo.cocolog-nifty.com/blog/2007/05/firefoxinnertex_916a.html">FireFoxでは、innerTextは使えない: Ozalog</a>

&nbsp;

htmlタグ等を含んだ投稿で何か悪い事されないために、innerTextを使いたかったのですが・・・

ってことで、対処してみました。(特定の文字をエスケープしているだけです)

```javascript
// Escape
function escape(s) {return s.replace(/&amp;/g, '&amp;amp;').replace(/&lt;/g, '&amp;lt;').replace(/&gt;/g, '&amp;gt;').replace(/"/g, '&amp;quot;').replace(/'/g, '&amp;#039;');}

// id:myonのオブジェクトの内容を書き換える例
document.getElementById("myon").innerHTML = escape(data);
```

&nbsp;

ほか、僕は確認していませんがtextContentを使う方法もあるようです。

<a href="http://www.oikawa-sekkei.com/web/design/js/firefox-innertext.html">JavaScript - Firefox で innerText が効かない｜及川WEB室</a>

&nbsp;

ではでは〜
