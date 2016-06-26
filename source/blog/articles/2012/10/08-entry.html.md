---
title: VAIO Z(VPCZ2)使っている人！RAIDドライバアップデートしよう！
date: 2012-10-08 11:02:10 JST
tags: VAIO-Z2, Windows
---
<p>おひさしぶりです</p>
<p>僕がメインで使っているパソコンはVAIO Zシリーズ（VPCZ23AJ）です。</p>
<p>厚さが1cmとちょっとでありながら通常電圧版のcorei7（2コア）が載っているのに惹かれ買ってしまいました。</p>
<p>財布が・・・痛いです・・・</p>
<p>&nbsp;</p>
<p>このZたんですが、<u>サムチョンのSSD2台</u>を<span style="color:red;">RAID0</span>しており、信頼性はないものの驚きのスピードをたたき出していました。</p>
<p>購入直後ではありませんが、DiskMarkかけてみたらこんな数字が</p>
<p><img src="https://lh5.googleusercontent.com/-OI0eczb2NQk/UHIqHZptnyI/AAAAAAAAA2E/ZMrnuoaqeFg/s640/diskmark.png" /></p>
<p>www</p>
<p>何も言うことあるまい</p>
<p>&nbsp;</p>
<p>ですが最近、特に書き込みが遅い気がしたのです</p>
<p>あまりにも気になったので調べてみると・・・</p>
<p><img src="https://lh6.googleusercontent.com/-qzKImyW5pSQ/UHIqHqT1I5I/AAAAAAAAA2M/uXg7jwtRzX0/s640/namidame.png" /></p>
<p><strong><span style="font-size:14px;">うおおおおおおおおおおおおおおおおおお！！！！！！</span></strong></p>
<p>なんなんだこれは！！！</p>
<p>&nbsp;</p>
<p>SSDだからいつかこうなると思っていました。</p>
<p>できる限り書き込みは減らすよう心がけてはいましたが。</p>
<p>&nbsp;</p>
<p>しかし疑問が一つ。</p>
<p><span style="font-size:24px;">「TRIM効いてないのか？」</span></p>
<p>&nbsp;</p>
<p>あくまで僕の推測ですが、TRIMが効いてないか、IRST系と思われるアプリケーションがエラーを起こして一度ブルースクリーンになったのが原因ではないかと。</p>
<p>今回はTRIMとドライバを疑ってみます。</p>
<p>SSDには物によりますが、TRIMという機能がついています。</p>
<p>ざっくり説明すると、「長期使用による速度低下を防ぐもの」です。（長くなるので興味がある人は各自調べてください）</p>
<p>CrystalDiskInfoを使って、ZたんのSSDがTRIMに対応しているか調べると・・・</p>
<p><img src="https://lh3.googleusercontent.com/-IMSWP9YHe68/UHIuI_TBF1I/AAAAAAAAA2k/fyshHv0mVqg/s640/trim.png" /></p>
<p>よしよし、ではなぜだ？</p>
<p>&nbsp;</p>
<p>http://www.station-drivers.com/forum/viewtopic.php?f=32&t=3910</p>
<p>上のリンクによると、RAIDドライバであるIntel® Rapid Storage Technology（以下IRST）のバージョンv11.5.x.xxxxからRAID0でもTRIM効くようになるとのこと。</p>
<p>ZたんのIRSTは・・・10.7.x.xxxxでした。（詳しいバージョンのメモ忘れました）</p>
<p>&nbsp;</p>
<p>ということで、試して見みることにした。</p>
<p>まず、インテルのサイトから最新のIRSTを拾ってきます。</p>
<p>下のリンクのページへ進み、暫く待つと最新のダウンロードの項目にある「ドライバーやソフトウェのダウンロード」が「Intel® Rapid Storage Technology xxx, xx xxx 20xx（xxは最新版の日付）」に変わるので、そのリンクに進みます。</p>
<p>http://www.intel.com/p/ja_JP/support/highlights/chpsts/imsm</p>
<p>&nbsp;</p>
<p>いくつかあるダウンロードの中から、ファイル名がiata_cd.exeとなっているリンクをクリックしてダウンロード、インストールします。</p>
<p>インストールが終わると再起動するように言われるので再起動します。</p>
<p>&nbsp;</p>
<p>PCが起動しても終わりではありません。RAIDアレイのドライバーのインストールが終わるとまた再起動するように言われたので再起動。</p>
<p>&nbsp;</p>
<p>さて、ベンチしてみようか。</p>
<p><img src="https://lh5.googleusercontent.com/-mdK6yB6vPzw/UHIqHjlgz7I/AAAAAAAAA2I/FnhdwVb_3D0/s640/fuka-------------tsu.png" /></p>
<p><span style="font-size:24px;">キタ━━━━(゜∀゜)━━━━！！！！！！！</span></p>
<p>復活です。よかったよかった。</p>
<p>&nbsp;</p>
<p>てなわけで、Zたん使っている人はドライバアップデートしたほうがいいかもしれません。</p>
<p>僕自身、これがTRIMが有効になったために回復したかはわかっていません。</p>
<p>調べてみても、RAIDされたSSDでTRIMが有効になるかどうかの情報はページによって異なります。</p>
<p>まぁ、結局速度は回復したのでよしとしましょう。</p>
