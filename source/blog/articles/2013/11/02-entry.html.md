---
title: RaspberryPiを使ったブラウザから操縦するラジコンカー
date: 2013-11-02 23:58:08 JST
tags: JavaScript, Raspberry Pi
---
どうもです！！

&nbsp;

製作中だったラジコン、ついに完成しました！！！！

<img src="https://lh6.googleusercontent.com/-dJAeA68A4E8/UnUIKJYYchI/AAAAAAAACr0/VsvzuG6xHnc/s640/IMG_1246.JPG" />

今日は中の構造及びどのように制御しているかの解説をしようと思います。

&nbsp;

## 接続しているデバイス類のこと

<img src="https://lh6.googleusercontent.com/-v53_m1ZLoPE/UnUImvwiMkI/AAAAAAAACsE/MMWzG4WSLmI/s640/IMG_1243.JPG" />

まず、今回の主役「RaspberryPi」です。コントロールページのサーバー、コントロールプログラム、Webカメラのライブ配信まですべてこれで行っています。

そして、IOピンに接続された基板がモータドライバ回路になります。

<img src="https://lh3.googleusercontent.com/-RodKAUXIDN8/UnUIlCmVHgI/AAAAAAAACsA/u3wNSGU2mZ4/s640/IMG_1236.JPG" />

RPiから給電できる電力には限界があるため、TA7291Pを2つ使用しモータドライバ回路を作成しました。

一方は駆動輪、もう一方はハンドルのモーターにつながっています。

横から出ているケーブルは電源供給用のUSBケーブルになります。

<img src="https://lh5.googleusercontent.com/-ZdDilnVfoLs/UnUIo1TYDlI/AAAAAAAACsM/OEdILSjrRz0/s640/IMG_1241.JPG" />

本日の事故によりメキョってしまいましたが、このWebカメラを搭載しています。

残念なことに、このカメラは屋外では明るすぎるのか真っ白な画像しか出力してくれませんでした・・・

（屋内では問題ない）

&nbsp;

## ソフトウェア類のこと

### Node.js

JavaScriptの一種で、サーバーを構築することができる言語です。

今回のシステムでは、Node.jdでWebサーバーを構築し、ブラウザ間とSocket.ioで通信することでラジコンの操縦を実現させています。

&nbsp;

### WiringPi

WiringPiは、Cなどの言語においてArduinoのような簡単な文法でIOピンのの制御ができるようになるライブラリです。

今回は、このライブラリに付属するgpioコマンドを使い、IOピンの制御を行っています。

&nbsp;

### mjpg_streamer

接続されたカメラ等のデバイスをjpeg形式でキャプチャして配信することができるソフトウェアです。

そこまで負荷も多くなく、かつ大きな遅延も発生しなかったため導入しました。

使い方及び導入にあたりつまづいたことに関しては前回の記事にまとめてあります。→<a href="http://tosainu.wktk.so/view/323">RPi(Arch Linux)でmjpg_streamerのビルドにつまづいた</a>

&nbsp;

## 実際に動かしてみた

<div class="video-container"><iframe width="560" height="315" src="https://www.youtube.com/embed/wpuF3721WQc?rel=0" frameborder="0" allowfullscreen></iframe></div>

&nbsp;

さて、こんな感じになります。

ソースコード公開ですが、まだ不完全な部分があるためまた後日とします。

明日もTNCTこうよう祭にて展示するので見に来てください〜

それでは〜
