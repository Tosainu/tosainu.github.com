---
title: VGN-CR52B CPU換装（CelM550→C2DT9300）
date: 2013-06-10 22:49:00 JST
---
<p>どーもです。</p>
<p>&nbsp;</p>
<p>ウチにはVAIO VGN-CR52Bというノーパソがあります。</p>
<p>父親が糞ーテックをから乗り換えたPCです。（今はまた別なのを使ってる）</p>
<p>&nbsp;</p>
<p>いまや週末のSkype専用マシンとなってしまいましたが、</p>
<p>今回、いろいろあって友人からCore2Duo T9300を貰うことができたので換装してみます。</p>
<p>&nbsp;</p>
<p><span style="color:red;">CPU換装はメーカーの</span>(ry</p>
<p>&nbsp;</p>
<h3>作業開始♪</h3>
<p>まず裏蓋を開けます。本体をひっくり返して、EnterキーのようなL型の部分のネジ6箇所を外します。</p>
<p><img src="https://lh5.googleusercontent.com/-WuU26DWrid0/UbXUeoKJv7I/AAAAAAAACOo/oJwYYGsE9ZY/s640/IMG_0583.JPG" /></p>
<p>&nbsp;</p>
<p>そしたら、クーラーを固定している5箇所のネジとファンのコネクタを外します。</p>
<p>ネジは1,2,3,4,6と番号が振ってあるのでわかりやすいです（5はどこだ？？？）</p>
<p><img src="https://lh4.googleusercontent.com/-O5IToaWmntM/UbXUaUsJeVI/AAAAAAAACOY/POoAf-hDBrg/s640/IMG_0584.JPG" /></p>
<p>&nbsp;</p>
<p>CPUを載せ替えます。上の黒いネジを180度回すと外れるようになります。</p>
<p><img src="https://lh6.googleusercontent.com/-vEAjxy-lmN0/UbXUeGk8IRI/AAAAAAAACOg/4RRc11BeyoY/s640/IMG_0586.JPG" /></p>
<p>グリスにはSilverArrow付属のCF3を使ってみました。</p>
<p><img src="https://lh5.googleusercontent.com/-yjlSzl1Ehhs/UbXVSPorfUI/AAAAAAAACO0/kY5Hr74SR_o/s640/IMG_0582.JPG" /></p>
<p>&nbsp;</p>
<p>逆の手順で戻して換装終了です。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<h3>結果</h3>
<p>このノーパソにはMobile Intel GL960 Expressというチップセットが載っています。</p>
<p>これはFSB533MHｚのものなので動くか不安だったのですが、</p>
<p>なんか知らんが<span style="font-size:36px;">あっさり</span>動いてしまいました</p>
<p>チップセットが勝手にFSBオーバークロックしてくれたんでしょうか？</p>
<p>おまけにメモリクロックも533MHz→667MHzになってました。ラッキー♪</p>
<p><img src="https://lh6.googleusercontent.com/-T_o1RTZnulU/UbXT7ZAjmDI/AAAAAAAACOQ/56yNPSp26-I/s640/%25E7%2584%25A1%25E9%25A1%258C.jpg" /></p>
<p>&nbsp;</p>
<p>ではベンチを回して見ましょう。</p>
<p>換装前、換装後の順でスクショを貼っていきます。</p>
<h4>SuperPi Mod</h4>
<p><img src="https://lh3.googleusercontent.com/-uzqhSt8fX8Q/UbXTxy7ejKI/AAAAAAAACOA/odoTIP93q34/s640/celpi.PNG" /></p>
<p><img src="https://lh4.googleusercontent.com/-o64hDWP7Suw/UbXT3FM6vhI/AAAAAAAACOI/qdC5j9sewr8/s640/superpi1m.PNG" /></p>
<p>&nbsp;</p>
<p><span style="font-size:36px;">32[sec]→23[sec]</span></p>
<p>クロック600MHzとキャッシュ6MB、そして45nmのリソグラフィーの違いはとても大きかった！！！</p>
<p>pi10秒短縮はOCの世界だと物凄いことです。これは驚いた！！！</p>
<p>&nbsp;</p>
<h4>CrystalMark2004</h4>
<p><img src="https://lh4.googleusercontent.com/-bxcKFx2NYjA/UbXTxV_dyiI/AAAAAAAACN0/gJSBXl7_zag/s640/celcry.PNG" /></p>
<p><img src="https://lh5.googleusercontent.com/-VbnHb-1eau4/UbXTxqFtXcI/AAAAAAAACN8/7IZwlH4fMfA/s640/crystalmark2004.PNG" /></p>
<p>&nbsp;</p>
<p><span style="font-size:36px;">ALUスコア2.5倍、</span></p>
<p><span style="font-size:36px;">FPU、MEMスコア2倍</span></p>
<p>とんでもねぇ、驚きのスペックアップwwwwwwww</p>
<p>特にメモリクロックが上がってくれたのも本当に効果デカイ！</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>いや、本当に驚いた！！！</p>
<p>これであと数年は戦えますね！</p>
<p>&nbsp;</p>
<p>CPUを安く譲っていただいた某Kさん、本当にありがとう！！！！</p>
