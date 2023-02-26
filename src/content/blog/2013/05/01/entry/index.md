---
title: VcoreをOffsetModeで指定してみた
date: 2013-05-01 19:24:25+0900
noindex: true
tags: DIY PC
---
<p>どーもです～</p>
<p>&nbsp;</p>
<p>2013年4月のアクセス数ですが、</p>
<p><img src="https://lh3.googleusercontent.com/-3KVTZdreAsw/UYDlF8-v52I/AAAAAAAAB_w/yDVPKn-nnig/s640/201304.png" /></p>
<p><span style="font-size:36px;">10,000超えたwww</span></p>
<p>&nbsp;</p>
<p>とはいうものの、全然嬉しくないですね。</p>
<p>記事別のアクセス数をみてみると、</p>
<p><img src="https://lh4.googleusercontent.com/-JwpAAe1U0S4/UYDlcMPP2qI/AAAAAAAACAA/jFicZibNMNo/s640/content.png" /></p>
<p><a href="http://tosainu.wktk.so/view/266">スパムが来ている記事</a>のアクセス数が<span style="font-size:24px;">桁違いに多い</span></p>
<p>&nbsp;</p>
<p>スパム対策をしたものの、相変わらず当サイトへのアクセスは続いているようです。</p>
<p>困ったもんですね・・・</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>本題に入ります。</p>
<p>&nbsp;</p>
<p>自作機1号では、せっかくのK石ってことで、現在4500MHzまでオーバークロックしています。</p>
<p>実際、ベンチマークでスコアが上がるだけで、「速くなった」と体感することは少ないのですが。</p>
<p>&nbsp;</p>
<p>当然、ここまでクロックを上げようとなると、電圧を盛る必要がありまして、</p>
<p>例えばCPUのcore電圧はManualModeで1.420[V]まで盛っています（詳しいパラメーターは知りたい人がいたら公開するかも）。</p>
<p>&nbsp;</p>
<p>ですが、このように設定した場合、</p>
<p><span style="font-size:24px;">アイドルでも電圧が一定</span></p>
<p>になってしまいます。</p>
<p>&nbsp;</p>
<p>そこで調べていて気になったのが、「OffsetMode」による電圧の設定。</p>
<p>自分自身、この方法による設定についてよくわからなかったのでメモ。</p>
<p>&nbsp;</p>
<h3>OffsetModeとは</h3>
<p>調べてわかったことを簡単に説明すると、</p>
<p><span style="font-size:24px;">VID±指定値[V]</span></p>
<p>って感じの設定方法らしいです。</p>
<p>また、VIDは</p>
<p>CPUがマザーに送っている<span style="font-size:24px;">動作に必要な電圧</span></p>
<p>の情報のことで、動作クロックなどによって変化するものみたいです。</p>
<p>&nbsp;</p>
<p>つまり、OffsetModeで設定すると、</p>
<p><span style="font-size:24px;">動作クロックに合わせて電圧が変化させられる</span></p>
<p>ということがわかりました。</p>
<p>&nbsp;</p>
<h3>じゃあVIDはいくつなのか？</h3>
<p>どんな盛り方を設定するものかわかったものの、<span style="color:red;">VID</span>がどのくらいか調べないと盛る量の検討がつきません。</p>
<p>調べると、<a href="http://www.hwinfo.com/download64.html">「HWINFO64」</a>が便利そうです。</p>
<p>ダウンロードし、Sensors-onlyのチェックを入れて起動するとこんなウィンドウが出てきます。</p>
<p><img src="https://lh3.googleusercontent.com/-ek8rXrXmfmI/UYDlGJF-0BI/AAAAAAAAB_0/s6IrGbHaNfA/s640/hwinfo64.png" /></p>
<p>Core #x VID ・・・のところがコアごとのVIDです。</p>
<p>BCLK100MHZ、TurboRatio45の状態でOCCTをかけるとVIDは1.382[V]まで上昇しました。</p>
<p>ということで今回は余裕を持たせ、VcoreをOffsetMode:+0.020[V]にしてみました。</p>
<p>&nbsp;</p>
<h3>結果</h3>
<p><u>Prime95をかけてみたところ</u></p>
<p><img src="https://lh6.googleusercontent.com/-1MeUWNSrcCA/UYDynBslRdI/AAAAAAAACAQ/6UjmydXxtAs/s640/full.png" /></p>
<p>4500MHzでのVIDである1.382[V]に確かに約0.02[V]盛られています。</p>
<p>Maxが1.424[V]になっていますが、おそらくLLCが働いたのでしょう。</p>
<p>&nbsp;</p>
<p><u>アイドル</u></p>
<p><img src="https://lh6.googleusercontent.com/-81aFihsGa7I/UYDyna7I81I/AAAAAAAACAU/Kd711y6vgYo/s640/idle.png" /></p>
<p><span style="font-size:24px;">キター</span></p>
<p>ちゃんと電圧が下がっています！</p>
<p>また、アイドルでのCPU温度は5度くらい下がりました♪</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>とりあえずこの状態でPrime95は1時間半完走でしたが、CINEBENCHで若干のスコア低下とLLCで1.424[V]まで上がった形跡があったため、</p>
<p>OffsetMode:+0.025[V]にして様子を見たいと思います。</p>
<p>また、海外のフォーラムを見ていると、PLL Voltageを結構盛ってる人が多いみたいなので（現在1.825[V]）、その辺りの検証もしてみたいと思います。</p>
<p>PLLはアイドル時の安定性が向上するとかなんだとか・・・</p>
<p>&nbsp;</p>
<p>今のマザーボードはかなり高性能になってますね。</p>
<p>Sandy、Ivyのクロックの上げやすさも驚きです。</p>
<p>&nbsp;</p>
<p>このマシンを組む前、よくソケ478の北森pen4とかソケ939のあちゅろんで遊んでましたが、500MHzUPくらいが精一杯でしたからね・・・</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>※今回の記事で出てきた値は、</p>
<p><span style="font-size:36px;">僕の環境</span></p>
<p>での値ですので、他の環境では上手く動かない場合があると思います。</p>
<p>特に、この3930kたんは「Vcore上げるだけじゃクロック上げにくい（僕の経験上）」ので、注意が必要です。</p>
<p>&nbsp;</p>
<p>また、一応オーバークロックは<span style="color:red;">自己責任で挑戦するもの</span>です。</p>
<p>僕の環境でCPUが盛りすぎで死んだとかはないですが、話を聞く限り<span style="color:red;">死ぬときは死ぬ</span>らしいです・・・</p>
