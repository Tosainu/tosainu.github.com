---
title: Qt5でJSON
date: 2015-01-17 14:57:00+0900
noindex: true
tags: C++
---

みょみょみょ.

最近, いろいろあってQt5を触っています(近いうちの記事で詳しく書きます).  
ちょっとJSON文字列をQtの機能だけでParseしたくなって, どう書けばいいのか粘っていたらこうなった.

<script src="https://gist.github.com/Tosainu/c451e277912cc7e605f7.js"></script>

あるJSONの"relationship" => "source" => "screen\_name"が指している文字列("bert")を取得することを考えてみます.

QtのJSON周りの主要なクラスには`QJsonDocument`, `QJsonObject`, `QJsonValue`の3つがあるようです.  
[QJsonDocument](http://doc.qt.io/qt-5/qjsondocument.html)はJSONドキュメント自体を扱うクラス,  
[QJsonObject](http://doc.qt.io/qt-5/qjsonobject.html)はパースされたJSONのKeyを扱うクラス,  
[QJsonValue](http://doc.qt.io/qt-5/qjsonvalue.html)はJSONの各keyが指しているValueを扱うクラスです.

まず, JSON文字列をParseするには`QJsonDocument`クラスを使います. Parseする方法はいくつかありますが, `QJsonDocument::fromJson()`に`QByteArray`に変換したJSON文章を渡すのが確実っぽい感じでした.

ParseしたJSONの各要素を扱うため, `QJsonDocument.object()`を使って`QJsonDocument`から`QJsonObject`を取得します.

`QJsonObject`で, あるKeyが指しているValueを取得するには`QJsonObject.value("hoge")`を使います. すると`QJsonValue`が返ってきます.

この状態で目的のValueに辿り着いたのであれば`QJsonValue.toString()`や`QJsonValue.toDouble()`で文字列や数値に変換してやります.  
しかし, 更に深い要素が欲しいのであれば`QJsonValue.toObject()`で再び`QJsonObject`に変換してやり, 同様に`.value("hoge").toObject().value("fuga")...`と続けていきます.

<blockquote class="twitter-tweet tw-align-center" lang="en"><p>QJson, 微妙ぃ.....</p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/556052826594373632">January 16, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet tw-align-center" lang="en"><p>これもっとCoolな書き方できないんですかね <a href="https://t.co/myBJAUPsOr">https://t.co/myBJAUPsOr</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/556055068739661824">January 16, 2015</a></blockquote>

<blockquote class="twitter-tweet tw-align-center" lang="en"><p>こりゃないっしょ.....って感じだ</p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/556056173267267585">January 16, 2015</a></blockquote>

求: Qtの機能だけでもっとCoolに各Valueを取得する方法
