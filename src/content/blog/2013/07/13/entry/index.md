---
title: RaspberryPi開封の儀＆とりあえずRaspbian動かしてみた
date: 2013-07-13 12:15:17+0900
noindex: true
tags:
  - Raspberry Pi
  - Linux
---
<p>どーもです〜</p>
<p>&nbsp;</p>
<p>1月早い誕プレであの「RaspberryPi」と「東芝製SDHCカード」貰いました！</p>

![](./IMG_0815.JPG)


![](./IMG_0816.JPG)

<p>本当にありがとう御座います！！</p>
<p>&nbsp;</p>
<p>長くなるのと画像が20枚近くあるので、記事の続きは↓からどうぞ。</p>
<p>&nbsp;</p>
<!--more-->
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>RaspberryPiはピンク色のポリプロピレンの箱に入っていました。</p>
<p>固定されているテープを剥がし箱を開くと、帯電袋に入った本体のほか、Quick start guide、Regulatory ompliance and Safety Information(規制準拠と安全性に関する情報)が入っていました。</p>

![](./IMG_0817.JPG)

<p>&nbsp;</p>
<p>本体を取り出してみました。</p>

![](./IMG_0818.JPG)


![](./IMG_0819.JPG)

<p>&nbsp;</p>
<p>SDカードスロットは基板裏面にありました。</p>

![](./IMG_0820.JPG)

<p>結構キツ目のスロットなのでSD落下とかはないかもしれませんが、挿入確認用と思われる端子が露出していて少し怖いです。</p>

![](./IMG_0828.JPG)

<p>&nbsp;</p>
<p>電源用のmicroB端子</p>

![](./IMG_0821.JPG)

<p>&nbsp;</p>
<p>HDMI端子</p>

![](./IMG_0822.JPG)

<p>&nbsp;</p>
<p>EthernetとUSB</p>

![](./IMG_0823.JPG)

<p>&nbsp;</p>
<p>アナログ音声出力にコンポジット映像出力端子もあります。懐かしいです。</p>

![](./IMG_0824.JPG)

<p>&nbsp;</p>
<p>たくさんのGPIOピンもついています。調べてみる限り、普通にマイコンボードのような使い方もできそうですね。</p>

![](./IMG_0825.JPG)

<p>&nbsp;</p>
<p>SDカードも開けてみました。</p>

![](./IMG_0826.JPG)

<p>&nbsp;</p>
<p>UHS-I Class1対応です。ウチには対応機器ないのでちょっともったいないですね。</p>

![](./IMG_0827.JPG)

<p>&nbsp;</p>
<p>RaspberryPiのケースにSDカードを固定する場所がありました。</p>

![](./IMG_0829.JPG)

<p>&nbsp;</p>
<p>本体も取り付けられました。でも割れてた・・・</p>

![](./IMG_0831.JPG)

<p>&nbsp;</p>
<p>&nbsp;</p>
<p>では早速動かしてみようと思います。</p>

![](./IMG_0832.JPG)

<p><del>Arch Linux焼いて添い寝・・・ハァハァ///</del>とりあえずRaspbian（RaspberryPi向けにカスタムされたDebian）を動かしてみます。</p>
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

![](./IMG_0833.JPG)

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

![](./IMG_0835.JPG)

<p>&nbsp;</p>
<p>ちなみにcpuinfoとか</p>

![](./IMG_0834.JPG)

<p>&nbsp;</p>
<p>さて、これからどうしましょうね。</p>
<p><a href="http://xe.bz/">某改造アホさん</a>がマザーボードやNAS走らせてますが、それと同じようなことができたらなぁと思います。</p>
<p>現時点でそんな予算全くありませんが。</p>
<p><del>とりあえずはArch Linux焼いて添い寝・・・ハァハァ///</del></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>ではでは〜</p>
