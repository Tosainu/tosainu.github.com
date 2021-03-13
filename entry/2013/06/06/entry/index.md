---
title: Ubuntu Touch on XPERIA Ray
date: 2013-06-06 20:24:03+0900
noindex: true
tags: Android,Linux
---
<p>どーもです〜</p>
<p>&nbsp;</p>
<p>さっき寝ると書いたな、あれは嘘だ。</p>
<p>あれです、嫌なことが終わった瞬間テンションがおかしくなって眠気が吹っ飛ぶってやつです。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>今回は友人のXPERIA RayにUbuntu Touchを焼いてみます。</p>
<p>今回はRayたんを使いますが、2011XPERIAならどれでも試せます。通信とか困らない人はやってみよう！</p>
<p>&nbsp;</p>
<h3>準備</h3>
<p>用意するもの</p>
<ul>
<li><u><span style="color:red;">Unlocked</span></u> XPERIA2011（<span style="color:red;">アンロック必須</span>）</li>
<li>4GB以上のmicroSDカード（フォーマットしてもおkなもの、推奨8GB以上）</li>
<li>Linux系のOSがインストールされたPC（MACも大丈夫かな？）</li>
<li>AndroidSDK又はFlashtool（fastbootコマンドでカーネルを焼きます）</li>
<li>簡単な英語を読む程度の能力（"copy the downloaded files onto sd-card"程度のものが理解できればおk）</li>
</ul>
<p>&nbsp;</p>
<p>端末は、一度ICS系のファームを焼いてください。BBバージョン等の関係で起動しない場合があるかもしれません。</p>
<p>&nbsp;</p>
<p>SDカードには第2パーティションを作成します。これはLinuxを使わないとできません。</p>
<p>第1パーティションの後ろに2GB以上のパーティションを作成し、第1パーティションはFAT32、第2パーティションはext4でフォーマットします。</p>
<p>&nbsp;</p>
<p>ちなみに、今回パーティション変更にはGPartedを使いました。ここまで高性能なパーティション変更ソフトはWindowsのシェアウェアにもないはずです。</p>
<p>&nbsp;</p>
<h3>必要なファイルのダウンロード</h3>
<p>XDAフォーラムの記事<a href="http://forum.xda-developers.com/showthread.php?t=2226406">Ubuntu-touch for all Xperia2011 devices</a>にアクセスし、</p>
<p>The generic ubuntu part（一番上のリンク）と、自分の端末に合わせたファイル、To fix the resolution for hdpi（一般的？な大きさで表示される）又はTo fix the resolution for mdpi（文字などが小さくなる）の3つのファイルを適当な場所に保存します。</p>
<p>そうしたら、その3つのファイルをSD（FATファイルシステムの方）にコピーします。</p>
<p>&nbsp;</p>
<h3>カーネルを焼く</h3>
<p>先程ダウンロードしたファイルの中に、cm-10.1-xxxxxx-UNOFFICIAL-xxxxxx-ubuntu.zipのような名前のファイルがあると思います。</p>
<p>そのを解凍してboot.imgを取り出します。</p>
<p>それをfastbootコマンドで端末に書き込みます。</p>
<p>コマンドは</p>
<pre class="prettyprint linenums">
$ fastboot flash boot boot.img
sending 'boot' (6946 KB)...
(bootloader) USB download speed was 9201kB/s
OKAY [  0.781s]
writing 'boot'...
(bootloader) Download buffer format: boot IMG
(bootloader) Flash of partition 'boot' requested
(bootloader) S1 partID 0x00000003, block 0x00000148-0x00000179
(bootloader) Erase operation complete, 0 bad blocks encountered
(bootloader) Flashing...
(bootloader) Flash operation complete
OKAY [  1.339s]
finished. total time: 2.121s
$ fastboot reboot             
rebooting...

finished. total time: 0.001s
</pre>
<p>です。（カーネル焼きに関しては<a href="http://tosainu.wktk.so/page/customkernel">ここ</a>で詳しく解説する記事を書いている途中です・・・）</p>
<p>&nbsp;</p>
<p>端末が再起動しますので、Vol-ボタンを何度か押してCWMリカバリに入ります。</p>
<p>&nbsp;</p>
<h3>Ubuntu Touchを書き込む</h3>
<p><img src="https://lh6.googleusercontent.com/-yng6DtLu0uw/UbBv8WT4GqI/AAAAAAAACMo/mdfsv1zwm2E/s640/DSC_0002.JPG" /></p>
<p>CWMリカバリに入ったら、</p>
<ol>
<li>Factory Reset</li>
<li>Format /System</li>
</ol>
<p>をしてください。そうしたら、</p>
<ol>
<li>cm-10.1-xxxxxxxx-UNOFFICIAL-xxxxxx-ubuntu.zip</li>
<li>quantal-preinstalled-phablet-armhf.zip</li>
<li>ubuntutouch_screen_fix_HDPI_jasousa.zip又はubuntu-touch-scaling-fix_by_Kakalko4.zip</li>
</ol>
<p>の順にzipを焼いてください。</p>
<p>書き込みが終わったら再起動です。</p>
<p>&nbsp;</p>
<h3>起動！！</h3>
<p>Rayたんの場合、カーネルのロゴはまるで画面が割れたかのようにバグるし、ブートアニメーション等もなく黒画面が続くなどで不安でしたが、なんとか起動しますた。</p>
<p><img src="https://lh5.googleusercontent.com/-x0pcfU8RUzc/UbBv8V53XXI/AAAAAAAACMk/qOgprFG6iA0/s640/DSC_0003.JPG" /></p>
<p>&nbsp;</p>
<h3>感想</h3>
<p>XDAフォーラム内での言葉を使うとすれば、</p>
<p><span style="font-size:36px;">it is so laggy</span></p>
<p>動作がクッソ重いです。</p>
<p>まぁ、端末の性能も今となってはアレですし、ROMの容量の関係かUbuntuシステムはSDの第2パーティションにインストールされてしまいますので、遅くて仕方ないですが。</p>
<p>&nbsp;</p>
<p>使い勝手ですが・・・</p>
<p><span style="font-size:36px;">「何もわかりません」</span></p>
<p>とりあえずWiFi接続、ブラウザ起動はできました。</p>
<p>カメラも起動してみましたが白画面、その他アプリもクッソ重く使い物には程遠そう・・・</p>
<p>&nbsp;</p>
<p>まぁ、</p>
<p><span style="font-size:36px;">起動だけさせてドヤァしてAndroidに戻す</span></p>
<p>パターンとなるのが大半かと。</p>
<p>&nbsp;</p>
<p>今後の進化に期待です。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>そういえば作業しながら気づいたのですが、</p>
<p><span style="font-size:36px;">カメラどこだ？？？</span></p>
<p>いつも通学用のカバンの右ポケットに入っているのですが。</p>
<p>あれ、そういえば学校の時からなかったような・・・</p>
<p>・・・・・</p>
<p>・・・</p>
<p>・・</p>
<p>えっ、もしかして</p>
<p><span style="font-size:36px;">落とした！！！！？？？？</span></p>
<p>もうやだ首吊りたい・・・</p>
