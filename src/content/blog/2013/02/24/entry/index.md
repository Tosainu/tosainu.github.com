---
title: 今更な感じはするけど玄箱で動かすOSを考える Gentoo編
date: 2013-02-24 20:41:52+0900
noindex: true
tags:
  - Linux
---
<p>どーもです。</p>
<p>&nbsp;</p>
<p>今日はずっと玄箱弄ってました。</p>
<p><img src="https://lh6.googleusercontent.com/-IVEbesdqREM/USnx7gF6eyI/AAAAAAAABKY/8N40UCmY6t0/s640/DSC07136.JPG" /></p>
<p>あの超geek向けのLinuxディストリ<a href="http://www.gentoo.org/">Gentoo</a>を動かそうと粘ってました。</p>
<p>日本の玄箱関係のサイトが減り始めている中、未だ<a href="http://buffalo.nas-central.org/wiki/Install_The_2007_PPC_Gentoo">外国のWikiにこんな記事</a>があったらやるしか無いじゃないですか！</p>
<p>&nbsp;</p>
<p>とりあえず今日の活動を細かく書くと・・・</p>
<div class="hidearea">
<p>Wikiをスーパー流し読みする</p>
<p>↓</p>
<p>適当にファイルをダウンロードして玄箱にうp</p>
<p>パーティション切ってtarball展開</p>
<p>↓</p>
<p>やったーchrootできたー！</p>
<p>適当に設定してemerge --syncだー！</p>
<p>↓</p>
<p>あるぇ？おかしいぞぉ〜？</p>
<p>さっきからエラーしか出てないぞぉ？</p>
<p>↓</p>
<p>もーいーや</p>
<p>やり直し</p>
<p>&nbsp;</p>
<p>4時間経過・・・</p>
<p>&nbsp;</p>
<p>この作業を3回繰り返し、自分がWikiと違うことをしていることにやっと気づく</p>
<p>↓</p>
<p>まず、ブートローダーであるubootが古いことに気づく</p>
<p><a href="http://downloads.buffalo.nas-central.org/">ここ</a>から玄箱無印（LS1_PPC）のuboot1.2を拾ってきて書き込む</p>
<p>↓</p>
<p>次に、展開しているファイルが違うことに気づく</p>
<p><a href="http://downloads.nas-central.org/ALL_LS_KB_PPC/Distributions/Gentoo/gentoo-20071104-uboot.tar.bz2">これ</a>をrootとなるディレクトリに展開、</p>
<p><a href="http://www.gentoo.org/main/en/mirrors.xml">適当なミラーサイト</a>から最新のportageのtarballを落として/usrとなるディレクトリに解凍</p>
<p>↓</p>
<p>設定ファイルをいじって再起動</p>
<p>↓</p>
<p>一応netcatから玄箱がカーネルを読んでいるのを確認するが、sshでアクセスできない</p>
<p>↓</p>
<p>3時間粘る</p>
<p>↓</p>
<p>諦めて夕飯を食べる</p>
<p>↓</p>
<p>今に至る</p>
</div>
<p>実際、パッケージを一つづつビルドしていくOSが200MHzプロセッサには厳しいのはわかってますが、動いたら面白いよな〜っていう好奇心でやりましたはい。</p>
<p>&nbsp;</p>
<p>Debianの場合は簡単で何度も試してますが、</p>
<p>fedoraなどのRedhat系のディストリに慣れてしまうと使いにくく感じてしまうほか、</p>
<p>ありきたりなの事が嫌いな僕ですので、なにか許せない。ただそれだけの理由でこんな事やってます。</p>
<p>&nbsp;</p>
<p>しっかしどうしようかなぁ・・・</p>
<p>玄箱でphp、mysqlなどのアプリケーションをガッツリ動かすとなると、性能面で厳しいものがあり、</p>
<p>鯖目的で1台PCを用意するか、Amazon EC2のようなちょっと変わったレン鯖を借りたほうがいい気がしてきました。</p>
<p>&nbsp;</p>
<p>まぁ、もう少し粘って見ます。</p>
