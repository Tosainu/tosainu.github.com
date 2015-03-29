---
title: 【Arduino】Linuxで快適Arduino開発（Vim + Makefile）
date: 2013-08-02 16:27:48 JST
tags: Linux,Arduino
---
<p>どーもです。</p>
<p>&nbsp;</p>
<p>夏休みになり、勝手に参加させてもらってる部活で「Arduino」を使うことになりました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/5cxtUWYiDjfujGX0tojb8NMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-IQ9K6n2YQC0/UftB6_srH8I/AAAAAAAACec/Q7ulhUZeVWo/s400/IMG_0870.JPG" height="300" width="400" /></a></p>
<p>↑秋月LCD実験中</p>
<p>&nbsp;</p>
<p>さて、Arduinoを動かすには「スケッチ」と呼ばれるプログラムを書かなければいけませんが、</p>
<p><a href="https://picasaweb.google.com/lh/photo/-g0f_JC4LdPZVeqyqpO5kNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-OmwidzOAiEE/UftF465elnI/AAAAAAAACes/uxFcNKOBbXU/s400/Screenshot%2520from%25202013-08-02%252014%253A35%253A39.png" height="400" width="333" /></a></p>
<p>&nbsp;</p>
<p><span style="font-size:36px;">標準エディタ使いにくい</span></p>
<p>&nbsp;</p>
<p>Tabがすぐにスペースに変換されるとかホント許せないです。</p>
<p>ってことで快適にスケッチを書けないものかといろいろ粘った結果、</p>
<p>&nbsp;</p>
<p><span style="font-size:36px;">Vim + Makefile</span></p>
<p>&nbsp;</p>
<p>が個人的に使い勝手が良かったので紹介します。</p>
<p>&nbsp;</p>
<h3>準備</h3>
<p>Arduino IDEをインストールしておいてください。</p>
<p>MakefileがArduino 1.5.xに対応していないようなので、それ以外を選んでください。</p>
<p>また、MakefileのREADMEからの抜粋になりますが、自分の環境に合わせてパッケージを追加してください。</p>
<pre>
On Debian or Ubuntu:
   apt-get install libdevice-serialport-perl

On Fedora:
   yum install perl-Device-SerialPort

On openSUSE:
  zypper install perl-Device-SerialPort

On Mac using MacPorts:
   sudo port install p5-device-serialport

  and use /opt/local/bin/perl5 instead of /usr/bin/perl
</pre>
<p>&nbsp;</p>
<h3>Makefileを使えるようにする</h3>
<p>Sudar氏の作成したArduino-Makefileを使わせてもらいました。</p>
<p><a href="https://github.com/sudar/Arduino-Makefile">https://github.com/sudar/Arduino-Makefile</a></p>
<p>&nbsp;</p>
<p>右側に「Download ZIP」ボタンがあるので、ここからダウンロードします。</p>
<p><a href="https://picasaweb.google.com/lh/photo/ZXJkaGxtnEWlVccx2bYYmNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-SAUiS5YlTsg/UftKCqUAdMI/AAAAAAAACe8/m1_G1z_YPas/s800/Screenshot%2520from%25202013-08-02%252014%253A55%253A17.png" height="192" width="270" /></a></p>
<p>&nbsp;</p>
<p>僕はDocumentsフォルダにarduinoフォルダを作成し、その中に解凍して出てくる全てのファイル・フォルダをコピーし、さらにsourceフォルダを作成しました。</p>
<p><a href="https://picasaweb.google.com/lh/photo/18GiNvpkAen5whISfHTjOdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-eeXCb6A2vW0/UftTus-6YdI/AAAAAAAACfw/qqiRGK236e8/s400/Screenshot%2520from%25202013-08-02%252015%253A35%253A09.png" height="239" width="400" /></a></p>
<p>&nbsp;</p>
<p>このsourceフォルダの中に、こんな感じでスケッチを書いていきます。</p>
<pre>
source
  ├─スケッチ01
  |   ├─スケッチ01.ino
  |   └─Makefile
  ├─スケッチ02
  |   ├─スケッチ02.ino
  |   └─Makefile
  └─スケッチ03
      ├─スケッチ03.ino
      └─Makefile
</pre>
<p><span style="color:red;">必ず、フォルダと中のスケッチのファイル名は同じにします。</span></p>
<p>&nbsp;</p>
<p>Makefileの中身はこんな感じにします。他にもオプションはありますが、最低限コレだけ書いておけば問題ないです。</p>
<pre class="prettyprint">
BOARD_TAG    = nano328
MONITOR_PORT = /dev/ttyUSB*
ARDUINO_LIBS =
AVR_TOOLS_DIR= /usr

include ../../arduino-mk/Arduino.mk
</pre>
<h4>BOARD_TAG</h4>
<p>そのまんまです。ここに開発しているArduinoの種類を書きます。</p>
<p>ここに書き込む文字列は、「make show_boards」とスケッチの入ったフォルダで実行するか、↓を参考にしてください。</p>
<div class="hidearea">
<pre>
uno
atmega328
diecimila
nano328
nano
mega2560
mega
leonardo
mini328
mini
ethernet
fio
bt328
bt
lilypad328
lilypad
pro5v328
pro5v
pro328
pro
atmega168
atmega8
</pre>
</div>
<p>&nbsp;</p>
<h4>MONITOR_PORT</h4>
<p>Arduinoが接続されているデバイス名を書きます。</p>
<p>僕の環境（Fedora17 x86_64）だと、Unoは/dev/ttyACM*、Nanoは/dev/ttyUSB*でした。</p>
<p>&nbsp;</p>
<h4>ARDUINO_LIBS</h4>
<p>ライブラリが置かれているディレクトリを書きます。</p>
<p>標準状態で/usr/share/arduino/librariesと/home/UserName/sketchbook/librariesを参照しているようなので、特に書き込む必要はないと思います。</p>
<p>&nbsp;</p>
<h4>AVR_TOOLS_DIR</h4>
<p>avrdudeが入っているディレクトリを指定します。僕の場合は/usrでした。</p>
<p>&nbsp;</p>
<h3>VimでArduinoスケッチをシンタックスハイライトさせる</h3>
<p>Sudar氏のvim-arduino-syntaxを使わせてもらいました。</p>
<p><a href="https://github.com/sudar/vim-arduino-syntax">https://github.com/sudar/vim-arduino-syntax</a></p>
<p>&nbsp;</p>
<p>同様にzipファイルをダウンロードします。</p>
<p>&nbsp;</p>
<p>ホームフォルダに「.vim」という名前でフォルダを作成し、先ほどダウンロードしたzipファイルを解凍して出てくる「ftdetect」と「syntax」フォルダを突っ込みます。</p>
<p>Linuxの世界ではファイル・フォルダ名の1文字目を「.」にすると隠しファイルの扱いになるので、ファイラーによっては設定を変更しないと表示されない場合があります。注意してください。</p>
<p><a href="https://picasaweb.google.com/lh/photo/rdUiKslrl4134PI7pwQRZNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-x1uFDeEt59Y/UftLbb-hL4I/AAAAAAAACfM/cAa_DmiYK8s/s400/Screenshot%2520from%25202013-08-02%252014%253A59%253A26.png" height="199" width="400" /></a></p>
<p>&nbsp;</p>
<p>また、これは個人の好みによりますが、ホームフォルダに「.vimrc」という名前でファイルを作成し、中身にコレだけは書いておくことをおすすめします。</p>
<pre class="prettyprint">
set autoindent
set smartindent
</pre>
<p>これで、自動インデントが有効になります。</p>
<p>その他の設定に関しては、<a href="http://vimblog.hatenablog.com/">Vimのブログ</a>が参考になるので、試してみるといいと思います。</p>
<p>&nbsp;</p>
<p>これで、VimでArduinoのスケッチファイル（拡張子ino）を開くと色が付いているはずです。</p>
<p><a href="https://picasaweb.google.com/lh/photo/taoPGIDYOHDbZ0B9NXcfENMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-sBUXuvwQraQ/UftM6_sG7aI/AAAAAAAACfc/uqb4MVwKVwY/s400/Screenshot%2520from%25202013-07-29%252018%253A52%253A07.png" height="240" width="400" /></a></p>
<p>&nbsp;</p>
<h3>ビルド&書き込み</h3>
<p>スケッチのある（inoファイルのある）ディレクトリでTerminalを開き、</p>
<pre class="prettyprint">
$ make
</pre>
<p>でビルドです。</p>
<pre class="prettyprint">
AVR Memory Usage
----------------
Device: atmega328p

Program:    4092 bytes (12.5% Full)
(.text + .data + .bootloader)

Data:        501 bytes (24.5% Full)
(.data + .bss + .noinit)

</pre>
<p>こんな感じの文章が出力されたらビルド成功です。エラーが出たらスケッチを確認してください。</p>
<p>&nbsp;</p>
<p>次は書き込みです。</p>
<pre class="prettyprint">
$ make upload
</pre>
<p>で接続されたArduinoにスケッチを書き込むことができます。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>一応全て書いたつもりですが、わからないことなどあったら遠慮なくコメントやTwitter、メールなどで連絡ください。（メールかTwitterの返事はかなり早いと思いますw）</p>
<p>では、快適なArduinoライフを〜</p>
