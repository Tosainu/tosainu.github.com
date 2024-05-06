---
title: VGN-CR52B CPU換装（CelM550→C2DT9300）
date: 2013-06-10 22:49:00+0900
noindex: true
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

![](./IMG_0583.JPG)

<p>&nbsp;</p>
<p>そしたら、クーラーを固定している5箇所のネジとファンのコネクタを外します。</p>
<p>ネジは1,2,3,4,6と番号が振ってあるのでわかりやすいです（5はどこだ？？？）</p>

![](./IMG_0584.JPG)

<p>&nbsp;</p>
<p>CPUを載せ替えます。上の黒いネジを180度回すと外れるようになります。</p>

![](./IMG_0586.JPG)

<p>グリスにはSilverArrow付属のCF3を使ってみました。</p>

![](./IMG_0582.JPG)

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

![](./E784A1E9A18C.jpg)

<p>&nbsp;</p>
<p>ではベンチを回して見ましょう。</p>
<p>換装前、換装後の順でスクショを貼っていきます。</p>
<h4>SuperPi Mod</h4>

![](./celpi.PNG)


![](./superpi1m.PNG)

<p>&nbsp;</p>
<p><span style="font-size:36px;">32[sec]→23[sec]</span></p>
<p>クロック600MHzとキャッシュ6MB、そして45nmのリソグラフィーの違いはとても大きかった！！！</p>
<p>pi10秒短縮はOCの世界だと物凄いことです。これは驚いた！！！</p>
<p>&nbsp;</p>
<h4>CrystalMark2004</h4>

![](./celcry.PNG)


![](./crystalmark2004.PNG)

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
