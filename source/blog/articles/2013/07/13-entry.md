---
title: RaspberryPi開封の儀＆とりあえずRaspbian動かしてみた
date: 2013-07-13 12:15:17 JST
tags: Linux,RaspberryPi
---
<p>どーもです〜</p>
<p>&nbsp;</p>
<p>1月早い誕プレであの「RaspberryPi」と「東芝製SDHCカード」貰いました！</p>
<p><a href="https://picasaweb.google.com/lh/photo/DzBXY88WASdxJgAfZ1Yu5tMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-HHT7NI4WGGE/UeCtax5hf2I/AAAAAAAACbU/13uyZRUMcp8/s400/IMG_0815.JPG" height="300" width="400" /></a></p>
<p><a href="https://picasaweb.google.com/lh/photo/6DETuZ4K0E2XUFNwJVqvudMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-FIgxRzTCkyo/UeCtZV9LAVI/AAAAAAAACbU/mIKvYccv3JY/s400/IMG_0816.JPG" height="300" width="400" /></a></p>
<p>本当にありがとう御座います！！</p>
<p>&nbsp;</p>
<p>長くなるのと画像が20枚近くあるので、記事の続きは↓からどうぞ。</p>
<p>&nbsp;</p>
<!-- pagebreak -->
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>RaspberryPiはピンク色のポリプロピレンの箱に入っていました。</p>
<p>固定されているテープを剥がし箱を開くと、帯電袋に入った本体のほか、Quick start guide、Regulatory ompliance and Safety Information(規制準拠と安全性に関する情報)が入っていました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/utDWJxYd5jm0q1mylaxR_NMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-3VTCwWYF1Sk/UeCtYTL4QhI/AAAAAAAACbU/qOnSf6d5EBs/s400/IMG_0817.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>本体を取り出してみました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/w2WXTgONYyUsuZNQhC8DqtMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-nOTrIeURHO0/UeCtwUSzukI/AAAAAAAACbU/f-944bwdEzQ/s400/IMG_0818.JPG" height="300" width="400" /></a></p>
<p><a href="https://picasaweb.google.com/lh/photo/B1BzTpurIKIc5VA6xIQKc9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh3.googleusercontent.com/-mz-rLpA_a18/UeCt0puEYoI/AAAAAAAACbU/tcD6VHn6Glk/s400/IMG_0819.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>SDカードスロットは基板裏面にありました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/NHgMLGc2vr4c1h_9PPbA1dMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-rfE9IWKd0qw/UeCt19AamTI/AAAAAAAACbU/UBNs4Gv2AN8/s400/IMG_0820.JPG" height="300" width="400" /></a></p>
<p>結構キツ目のスロットなのでSD落下とかはないかもしれませんが、挿入確認用と思われる端子が露出していて少し怖いです。</p>
<p><a href="https://picasaweb.google.com/lh/photo/Pcer8Fw-d5dg59Un17n73tMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-IekZaS9xUxw/UeCu7CFTDHI/AAAAAAAACbU/IeJxvlediM4/s400/IMG_0828.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>電源用のmicroB端子</p>
<p><a href="https://picasaweb.google.com/lh/photo/DWFmC9mPybw8gl7Mt6F4fdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-DZjHAcAeSBo/UeCuG3sQzOI/AAAAAAAACbU/lkf1N4tmDMg/s400/IMG_0821.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>HDMI端子</p>
<p><a href="https://picasaweb.google.com/lh/photo/ArWqLeujlnZRP3KDvZAexNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-N6Y6_Zej0k4/UeCuKnaCHOI/AAAAAAAACbU/F4f7qAbu9PQ/s400/IMG_0822.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>EthernetとUSB</p>
<p><a href="https://picasaweb.google.com/lh/photo/fRD47i9LTuQLxhDASW8hNdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh3.googleusercontent.com/-JsYKsBc3d68/UeCuLWRtIGI/AAAAAAAACbU/0OTWxHEJEC0/s400/IMG_0823.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>アナログ音声出力にコンポジット映像出力端子もあります。懐かしいです。</p>
<p><a href="https://picasaweb.google.com/lh/photo/ZLg-kbl8TQX_anafreGxMtMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-XCRl0zeOhLU/UeCuaOeBiHI/AAAAAAAACbU/6h6A6TvCCDQ/s400/IMG_0824.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>たくさんのGPIOピンもついています。調べてみる限り、普通にマイコンボードのような使い方もできそうですね。</p>
<p><a href="https://picasaweb.google.com/lh/photo/ZvTCKtAGhFcTk_LtO117bNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-OVOvE_AfCTc/UeCuhAacIdI/AAAAAAAACbU/g7V_HEyScYk/s400/IMG_0825.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>SDカードも開けてみました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/EwCYshEbEk1Zq3nFqOmWwNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-4BCDOkCrli4/UeCuhPs_sjI/AAAAAAAACbU/FBK7AttvqVA/s400/IMG_0826.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>UHS-I Class1対応です。ウチには対応機器ないのでちょっともったいないですね。</p>
<p><a href="https://picasaweb.google.com/lh/photo/FGi2DbKnxQNJlaabefPZaNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-fNJwFRLMigg/UeCuunwOJZI/AAAAAAAACbU/T0JMch_76v8/s400/IMG_0827.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>RaspberryPiのケースにSDカードを固定する場所がありました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/xp8SXiIc2TiuBOsCaThGKNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh3.googleusercontent.com/-V3DeMwCUVt4/UeCu5XNVe-I/AAAAAAAACbU/yHWJPK1wcHQ/s400/IMG_0829.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>本体も取り付けられました。でも割れてた・・・</p>
<p><a href="https://picasaweb.google.com/lh/photo/TagiAStTObBgWVarZxWy7tMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-8sQfi0vc7ms/UeCvQeTWO5I/AAAAAAAACbU/BW3CT27J4ag/s400/IMG_0831.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>では早速動かしてみようと思います。</p>
<p><a href="https://picasaweb.google.com/lh/photo/ywtpZC4yeVjoFlAuvGHU7tMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-PU4_Awze-ts/UeCvOzNcpaI/AAAAAAAACbU/bA7neZaK44w/s400/IMG_0832.JPG" height="300" width="400" /></a></p>
<p><del>ArchLinux焼いて添い寝・・・ハァハァ///</del>とりあえずRaspbian（RaspberryPi向けにカスタムされたDebian）を動かしてみます。</p>
<p>ddコマンドもないWindowsは用なしです。Windowsでも方法はありますが、それをやる気はありません。</p>
<p>素晴らしいLinuxやUnix系のOSが入ってるPCで作業します。</p>
<p>&nbsp;</p>
<p>ターミナルを開きます。作業ディレクトリはどこでもいいですが、僕はHomeフォルダにraspberrypiフォルダを作りました。</p>
<p>jaistのミラーから最新版のイメージをDL、展開します。</p>
<pre class="prettyprint">
$ mkdir raspberry
$ cd raspberry 
$ wget http://ftp.jaist.ac.jp/pub/raspberrypi/raspbian/2013-05-25-wheezy-raspbian/2013-05-25-wheezy-raspbian.zip
--2013-07-13 09:37:20--  http://ftp.jaist.ac.jp/pub/raspberrypi/raspbian/2013-05-25-wheezy-raspbian/2013-05-25-wheezy-raspbian.zip
Resolving ftp.jaist.ac.jp (ftp.jaist.ac.jp)... 150.65.7.130, 2001:df0:2ed:feed::feed
Connecting to ftp.jaist.ac.jp (ftp.jaist.ac.jp)|150.65.7.130|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 518462948 (494M) [application/zip]
Saving to: ‘2013-05-25-wheezy-raspbian.zip’

100%[======================================>] 518,462,948 1.70MB/s   in 5m 33s 

2013-07-13 09:42:53 (1.48 MB/s) - ‘2013-05-25-wheezy-raspbian.zip’ saved [518462948/518462948]

$ ls
2013-05-25-wheezy-raspbian.zip
$ sha1sum 2013-05-25-wheezy-raspbian.zip 
131f2810b1871a032dd6d1482dfba10964b43bd2  2013-05-25-wheezy-raspbian.zip
$ unzip 2013-05-25-wheezy-raspbian.zip 
Archive:  2013-05-25-wheezy-raspbian.zip
  inflating: 2013-05-25-wheezy-raspbian.img  
</pre>
<p>SDカードにddコマンドでイメージを焼きます。もしSDカード上のパーティションがマウントされていたらアンマウントしてください。sudoを使ったほうがいいかもしれませんが、僕の環境にはまだ入れてなかったのでsuしました。</p>
<p>言わなくてもいいかもしれませんが、僕の環境ではSDカード上のカードが/dev/sdfでしたが、環境によって絶対に違ってくるので注意。</p>
<p>syncコマンドはキャッシュを書き込むコマンドのようです。</p>
<pre class="prettyprint">
$ su 
Password: 
# dd bs=1M if=2013-05-25-wheezy-raspbian.img of=/dev/sdf
1850+0 records in
1850+0 records out
1939865600 bytes (1.9 GB) copied, 233.945 s, 8.3 MB/s
# sync
# exit
exit
$ 
</pre>
<p>&nbsp;</p>
<p>SDを取り出してRaspberryPiに取り付け。microBから給電すると起動します。</p>
<p>HDMIでつないだディスプレイにはこんな画面が出て来ました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/cu44sgntV2XP2uqjGFuBh9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh3.googleusercontent.com/-b5YB1VGlZck/UeCvpeWBQmI/AAAAAAAACbU/7vCBS5QzMcM/s400/IMG_0833.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>今回は動作確認なので、適当に初期設定を済ましてしまいましょう。</p>
<p>まず、1 Expand Filesystemを実行します。今の状態ではイメージが書き込まれた部分しか使うことができないので、利用可能な領域までパーティションを拡大します。</p>
<p>これが終わったら一度Finishを選択し再起動しました。</p>
<p>再び起動すると、CUIでのログイン画面が表示されます。User:pi、 Pass:raspberryでログインし、再び設定を行います。</p>
<pre class="prettyprint">
$ sudo raspi-config
</pre>
<p>で先程の画面がまた出てきます。</p>
<p>&nbsp;</p>
<p>2 Change User Password:ユーザーパスワードの変更</p>
<p>&nbsp;</p>
<p>4 Internationalisatin Options:Locale、Timezone、Keyboard Layout</p>
<p>Locale:en-US.UTF8、 Timezone:Asia Tokyo、Keyboard Layout:101</p>
<p>&nbsp;</p>
<p>3 Enable Boot to Desktop:ブート後デスクトップを表示する</p>
<p>今回は動作テストなので、GUIも有効にしてみます。</p>
<p>&nbsp;</p>
<p>パッケージのアップデートや時刻の設定（初期状態ではメチャクチャずれてる）もありますが、RaspberryPiをネットワークに接続する環境がなかったため今回はパスします。</p>
<p>Finishを選択して再び再起動させます。</p>
<p>&nbsp;</p>
<p>デスクトップが表示されました！</p>
<p>&nbsp;</p>
<p><a href="https://picasaweb.google.com/lh/photo/qjcpmVSEh5LxrH7uA7l8CdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-ZdYA6f-WruQ/UeCvnivBidI/AAAAAAAACbU/EdEQ7R3oJBs/s400/IMG_0835.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>ちなみにcpuinfoとか</p>
<p><a href="https://picasaweb.google.com/lh/photo/YtdD66CsB-oFOsN_roA8x9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-J9xdIct9snk/UeCvnkyatpI/AAAAAAAACbU/lmA-kAuOlcY/s400/IMG_0834.JPG" height="300" width="400" /></a></p>
<p>&nbsp;</p>
<p>さて、これからどうしましょうね。</p>
<p><a href="http://xe.bz/">某改造アホさん</a>がマザーボードやNAS走らせてますが、それと同じようなことができたらなぁと思います。</p>
<p>現時点でそんな予算全くありませんが。</p>
<p><del>とりあえずはArchLinux焼いて添い寝・・・ハァハァ///</del></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>ではでは〜</p>