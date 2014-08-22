---
title: XperiaAcroのRoot取得とか
date: 2013-05-18 18:32:48 JST
tags: Android
---
<p>どーもです。</p>
<p>&nbsp;</p>
<p>友人から、</p>
<p>「Acroのroot取得頼んだ！」</p>
<p>と、XperiaAcro（au IS11S）を預かりました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/R-DP9WrfhsvS5iD4V2a0D9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-gnhfVJSQoEs/UZc_76aCN1I/AAAAAAAACIo/tW6J5yTE_Jk/s400/IMG_0517.JPG" height="300" width="400" /></a></p>
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
<p><a href="https://picasaweb.google.com/lh/photo/6Ye-hf8w9LYMChP53lAlwdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-erk4RgZS1SM/UZdFbxrieZI/AAAAAAAACJA/dMDl96BkKs8/s400/flashtool.png" height="233" width="400" /></a></p>
<p>何度か再起動を繰り返して端末のroot化は完了します。</p>
<p><a href="https://picasaweb.google.com/lh/photo/AL9OKZ0cskt_zWsfVOF38tMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-AA3TAJaAGC8/UZc__JWurbI/AAAAAAAACIw/W9wj3qjXzJQ/s400/IMG_0518.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>いろいろ触ってみましたが、とても気になることがありました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/XTUWGEFkPCpEyU7CM12_4tMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-KROtIUXfeZE/UZc_Q-gz2LI/AAAAAAAACIA/0VDl7COpOLI/s400/device-2013-05-18-173322.png" height="400" width="225" /></a></p>
<p><a href="https://picasaweb.google.com/lh/photo/IDfsZge2j_Sum0uZN5pum9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-_atuOmW0kVM/UZc_Qx39g1I/AAAAAAAACII/lTKD-eN6JIw/s400/device-2013-05-18-173334.png" height="400" width="225" /></a></p>
<p><a href="https://picasaweb.google.com/lh/photo/aGYzw6JtScbPMfQk0Q0-zdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-f0Jbbj5PxHQ/UZc_Qxu_sNI/AAAAAAAACIE/cn39ItSujE0/s400/device-2013-05-18-173346.png" height="400" width="225" /></a></p>
<p><a href="https://picasaweb.google.com/lh/photo/HDPwvkcAmLt3k1Dj2aQwZNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh3.googleusercontent.com/-MYeFO7jlir8/UZc_R69Y6MI/AAAAAAAACIY/huMFBnvcCaM/s400/device-2013-05-18-173356.png" height="400" width="225" /></a></p>
<p>噂には聞いていましたが、auファームってここまで○だったとは・・・</p>
<p>いくら何でも<span style="font-size:24px;">「消せないプリイン」</span>が多くないですか？？</p>
<p>&nbsp;</p>
<p>たぶん僕は一生auのお世話にはならないと思います。</p>