---
title: '[ML110 G7] フロントI/O ピンアサイン解析'
date: 2013-03-08 20:00:46 JST
tags: ML110 G7 Mod
---
<p>どーもとさいぬです。</p>
<p>&nbsp;</p>
<p>◎2号機のおさらい</p>
<p>先日、HPの安鯖『ML110 G7』を分解し、マザボ載せ替えなどをしました。（<a href="http://www5.pf-x.net/~tosainu/index.php/view/233">ブログ記事見てね</a>）</p>
<p>しかし、このケースには予想はしていましたが、様々な特殊仕様がありました。</p>
<p>特にフロントのIOパネル。</p>
<p>USBポートのコネクタは微妙に違うし、スイッチ、LED等の端子は1つの謎のコネクタでまとめられていました。</p>
<p>&nbsp;</p>
<p>今回はこのコネクタの解析と、マザーボードへの接続をしたのでまとめておこうと思います。</p>
<p>&nbsp;</p>
<p>----------------------------------------------</p>
<p>&nbsp;</p>
<h3>フロントUSBポート</h3>
<p>この安鯖さんのフロントUSBポートのコネクタは、穴の塞がっている場所が微妙に違っています。</p>
<p>いろいろ調べてみると、どうやらNCにあたる部分の端子の向きが違うだけのようです。</p>
<p>一体誰がこんな間違いをしたんだよｗ</p>
<p>&nbsp;</p>
<p>面倒くさいので塞がっているところに穴を開けてマザボに接続しました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/m-u3dlqAgU0PDpIlOHbBwdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/--I2_LI32pl8/UTmwq9Y50MI/AAAAAAAABec/UdJFU7CXs44/s400/IMG_0180.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<h3>スイッチ・LED等のコネクタ</h3>
<p>なんか間違ってる気もしますが、ピンアサインの解析をしたので画像を貼っときます。</p>
<p>→側が凸の方です。</p>
<p><a href="https://picasaweb.google.com/lh/photo/n-JvlYgCyKV03ej1gMxplNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-sr1Q_1SChuM/UTm5vb1PkCI/AAAAAAAABfU/YLC_DKfYmxE/s400/Untitled.png" height="237" width="400" /></a></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><span style="font-size:24px;">特殊仕様勘弁してくれマジで</span></p>
<p>このコネクタ、一部地味にGND共有してるのが本当にムカつくぜ・・・</p>
<p>+-がケーブルの色関係ないのとかもあるし・・・</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>ピンアサインがわかっただけでは何も意味がありません。</p>
<p>マザーボードと接続しなければ電源を入れることもできません。</p>
<p>&nbsp;</p>
<p>接続方法をいろいろ考えた結果、<a href="http://www5.pf-x.net/~tosainu/index.php/view/229">以前破壊したもの</a>の残骸を活用することにしました。</p>
<p>&nbsp;</p>
<p>ケーブルのスリーブを剥き、さらにコネクタからケーブルを金属の部分ごと抜きます。</p>
<p>金属の部分を押さえているツメを軽く持ち上げケーブルを引くと抜けます。</p>
<p>&nbsp;</p>
<p><a href="https://picasaweb.google.com/lh/photo/s-jqRUXAk8XorpqdcIgYRdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-3eNrA7Hvc3o/UTmwviGobgI/AAAAAAAABes/w4c1QqxAhes/s400/IMG_0181.JPG" height="300" width="400" /></a></p>
<p>不要なケーブルは邪魔なので束ねておきます。</p>
<p>&nbsp;</p>
<p>あとはマザボの端子にあわせて残骸に差していきます。</p>
<p>今回はUIDスイッチをリセットに割り当てることにしました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/cDgoZaCbXUZVOjaFo60arNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-5_7k9w_1pDg/UTmwuhbJgtI/AAAAAAAABek/b_LcQzKOPmQ/s400/IMG_0185.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p><a href="https://picasaweb.google.com/lh/photo/-KEzwdEN_KEcAZ_SNXJhtdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-9uSsv7QcXoM/UTmxHkUGd3I/AAAAAAAABe4/yqSWy_RY4_o/s400/IMG_0187.JPG" height="300" width="400" /></a></p>
<p>わーい</p>
<p>コネクタが全部接続されたどー！</p>
<p>&nbsp;</p>
<p><a href="https://picasaweb.google.com/lh/photo/_Gkr0iXey9fJegh2lEqBuNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-yCHQlljEoxk/UTmxLAIu82I/AAAAAAAABfE/V98t_fvzU3A/s400/IMG_0188.JPG" height="300" width="400" /></a></p>
<p>あとは適当に配線を済ませて完成。</p>
<p>&nbsp;</p>
<p><a href="https://picasaweb.google.com/lh/photo/ggWUTrLiqfiHemBCuSGRWtMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-cNmvXPhP7HY/UTmxIIjEpJI/AAAAAAAABe8/ZcM3QwzyF3E/s400/IMG_0189.JPG" height="300" width="400" /></a></p>
<p>なんとかスイッチ類やLEDも動いているようです。</p>
<p><del>光っていないのがあるのは気にしてはいけません</del></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>最後に</p>
<p><span style="font-size:36px;">HDD遅せぇぇぇぇぇぇぇぇ</span></p>
<p>&nbsp;</p>
<p>サブ機にSSDなんて高価なもの載せる財力はありません。</p>
<p>そうでなくとも高くなっちゃったし・・・</p>
<p>そしてPlextor迷走中（泣）</p>
<p>&nbsp;</p>
<p><span style="font-size:36px;">一番いいSSD（高信頼性&安価）を頼む</span></p>
