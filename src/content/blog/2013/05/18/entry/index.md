---
title: XperiaAcroのRoot取得とか
date: 2013-05-18 18:32:48+0900
noindex: true
tags:
  - Android
---
<p>どーもです。</p>
<p>&nbsp;</p>
<p>友人から、</p>
<p>「Acroのroot取得頼んだ！」</p>
<p>と、XperiaAcro（au IS11S）を預かりました。</p>

![](./IMG_0517.JPG)

<p>&nbsp;</p>
<p>これまた最新のファームウェアではroot取得できないので、いつものようにダウングレードの作業をします。</p>
<p>2011ペリアはDooMLoRD氏のバッチファイルによるroot化が有名ですが、今回はFlashtoolからやってみようと思います。</p>
<p>Linux環境からも簡単にroot取得の操作ができます！（←今日コレが言いたかっただけ）</p>
<p>&nbsp;</p>
<p>※ftf焼きなどに必要なソフトウェア等の準備方法は<a href="http://tosainu.wktk.so/page/xperiahack">Xperia2011年モデル改造まとめ</a>や他サイトを参考にしてください</p>
<p>&nbsp;</p>
<h3>FWのダウングレード</h3>
<p>XperiaAcro（au）のroot取得ができる最新のファームウェアはビルド番号4.0.1.B.0.112のようです。</p>
<p>ftfファイルはこちらにミラーしておきました→<a href="http://www.mediafire.com/download.php?466hm592w98zkg9">IS11S_4.0.1.B.0.112_KDDI.rar</a></p>
<p>&nbsp;</p>
<p>これを、いつも通りの方法で書き込みます。</p>
<p>&nbsp;</p>
<h3>Flashtoolから2011ペリア（And2.3.4）のroot化</h3>
<p><span style="font-size:18px;"><span style="color:red;"><strong>2013/5/19 (Sun) 20:19:10修正</strong></span></span></p>
<p>Flashtoolを起動して、デバッグモードを有効にした端末をPCと接続します。</p>
<p>ここで、接続した端末の種類を選択するウィンドウが出ると思います。XperiaAcroは一覧にありませんが、今回はただrootが取得したいだけなので、LT15 XperiaArcを選択しました。</p>
<p>上部メニューのAdvanced→Root→Force zergRushを実行すると</p>

![](./flashtool.png)

<p>何度か再起動を繰り返して端末のroot化は完了します。</p>

![](./IMG_0518.JPG)

<p>&nbsp;</p>
<p>&nbsp;</p>
<p>いろいろ触ってみましたが、とても気になることがありました。</p>

![](./device-2013-05-18-173322.png)


![](./device-2013-05-18-173334.png)


![](./device-2013-05-18-173346.png)


![](./device-2013-05-18-173356.png)

<p>噂には聞いていましたが、auファームってここまで○だったとは・・・</p>
<p>いくら何でも<span style="font-size:24px;">「消せないプリイン」</span>が多くないですか？？</p>
<p>&nbsp;</p>
<p>たぶん僕は一生auのお世話にはならないと思います。</p>
