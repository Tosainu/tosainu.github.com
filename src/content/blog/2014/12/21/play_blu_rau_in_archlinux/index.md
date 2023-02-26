---
title: 対Blu-ray用決戦部隊、通称MakeMKV
date: 2014-12-21 21:39:00+0900
tags:
  - Gochiusa
  - Arch Linux
---

この記事は**[ご注文はBlu-rayですか?](/blog/2014/12/19/gochiusa_blu_ray_photo_review/)**および**[ひと目で尋常でないプロテクトだと見抜いたよ](/blog/2014/12/20/fu_k_power_dvd/)**の続きです.

## まず

このタイプの話題は**著作権法**とかにも関わってきたりで焦げ臭くなりやすいので, 先にいろいろ書いておきます.

2012/10/01からの著作権法の改正で, (コピー|アクセス)ガードの**回避を伴った複製**が違法となったようです.  
嫌いなサイト[^1]の記事を載せるのは気分悪いですが, [この辺](http://weekly.ascii.jp/elem/000/000/110/110332/)がよくまとまっています.

今回の記事最後で紹介する[MakeMKV](http://www.makemkv.com/)というソフトウェアは, **技術的保護手段が施された市販のBlu-rayのコンテンツを複製(リッピング)する行為**も可能であり, 当然このようなことを行うことは違法となります.  
しかし, 今回の記事ではMakeMKVに含まれるLGPLなオープンソースライブラリ**libmmbd**利用し, コピープロテクトの**解除は行うものの複製はしない**(再生するだけ)ため違法にはならないと思われます.

また, 同様の理由でlibaacs等に関しても違法性はないと思われます.

## んで

前回の記事の通り, 合法かつ確実に成功するはずの手段が使えないことが判明してしまいました.  
こうなってしまった以上, 少し特殊な手段を使うしかありません[^2].

また, 僕は普段Arch Linuxを使っているのはアイコンからもわかると思いますが, やっぱり**Arch Linuxでごちうさを見たい**わけです.

ってことで, 今回はそんな方法を探ってみました.

<!--more-->

## 環境

* Arch Linux x86\_64 (linux-3.17.6)
* Pioneer BDR-208BK (SATA)
* Geforce GTX 660 Ti (Driver: 343.36)

## libaacsを試す (失敗)

Arch Linux Wikiには[こんなページ](https://wiki.archlinux.org/index.php/BluRay)があり, libaacsを利用したBDの再生方法が丁寧に書かれています.  
とりあえずその通りの方法で再生を試みました.

```
// 必要なパッケージのインストール
$ yaourt -Sy libbluray libaacs

// KEYDB.cfgをDL
$ mkdir -p ~/.config/aacs
$ cd ~/.config/aacs/ && curl -O http://vlc-bluray.whoknowsmy.name/files/KEYDB.cfg
```

これで準備は完了です.  
その後BDを適当にマウントしてmplayerなどの任意のプレイヤーで再生できるはずでしたが.....

```
$ sudo mkdir /mnt/GOCHIUSA_1
$ sudo mount /dev/sr0 /mnt/GOCHIUSA_1
$ mplayer br:// -bluray-device /mnt/GOCHIUSA_1
MPlayer SVN-r37224 (C) 2000-2014 MPlayer Team
210 audio & 441 video codecs
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing br://.
libaacs: libaacs/aacs.c:426: Error calculating media key. Missing right processing key ?
bluray.c:867: aacs_open() failed!
bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
libavformat version 55.33.100 (internal)
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?
  bluray.c:636: TP header copy permission indicator != 0, unit is still encrypted?

--- 略 ---


  Exiting... (End of file)
```

(´・ω・｀)  
`KEYDB.cfg`に対応したキーが入っていない, もしくはlibaacsがごちうさBDにかかっているAACS v47に未対応なのだと思われます.
## MakeMKVのlibmmbdを使う

何かの助けにならないかと思い, [MakeMKVのLinux版](http://www.makemkv.com/forum2/viewtopic.php?f=3&t=224)をインストールしてみました.  
Arch Linuxの場合はAURから簡単にインストールできます.

```
$ yaourt -S makemkv
```

起動してみると, なんと**ごちうさBDを認識した**のです!!  
![makemkv](https://lh4.googleusercontent.com/-BQH3ACxvq3U/VJa16KpZqUI/AAAAAAAAD1U/BnqS5swRvfs/s640/Screenshot%2520from%25202014-12-21%252020%253A57%253A54.png)

さらになんとかならないかと情報を集めていると, **[MakeMKVに含まれるlibmmbdがlibaacsの代わりに利用でき, シンボリックリンクを張ることでプレイヤー等で再生が可能になる](http://www.makemkv.com/forum2/viewtopic.php?f=3&t=7009)**という情報を発見!  
しかも, Arch LinuxではAURで公開もされているようです.

早速インストール.

```
$ yaourt -S makemkv-libaacs
```

また, BDを再生するにあたって個人的なお気に入りプレイヤーであるmplayer及びgnome-mplayerでは色々つらいものがあったため, vlcをインストールしました.

```
$ yaourt -Sy vlc
```

vlcを起動し, 上部メニューのMedia-\>Open Diskをクリック,  
![menu](https://lh6.googleusercontent.com/-ygC-xWkeAa4/VJa7foJtIqI/AAAAAAAAD1w/aXxNyy_KMmY/s800/menu.png)

Blu-rayにチェックを入れて, またBDドライブのパスを設定してPlayをクリック.  
すると......  
![dialog](https://lh3.googleusercontent.com/-SM-srYEznMg/VJa7fvUS40I/AAAAAAAAD10/bDM3z3RLK78/s800/Screenshot%2520from%25202014-12-21%252021%253A16%253A31.png)

(＾ω＾≡＾ω＾)おっおっ  
![op](https://lh3.googleusercontent.com/-JijMeiq2cJs/VJa7eHYY4II/AAAAAAAAD1s/6-BIo0XGE_I/s640/Screenshot%2520from%25202014-12-21%252021%253A19%253A08.png)

**ｷﾀ━━━━(ﾟ∀ﾟ)━━━━!!**  
![title](https://lh6.googleusercontent.com/-DgJPUivZ3uE/VJa7yRqWidI/AAAAAAAAD18/UGmTK0O76yw/s640/IMG_2638.JPG)

あぁ, 長かった..... やっとごちうさを見ることができるぜ.....  
ではではー[^3]

## 追記 (2015/07/31)

本記事と同様の方法で, Windows環境でもVLCでBDの再生が可能なようです.

<blockquote class="twitter-tweet tw-align-center" lang="en"><p lang="ja" dir="ltr">はてなブログに投稿しました <a href="https://twitter.com/hashtag/%E3%81%AF%E3%81%A6%E3%81%AA%E3%83%96%E3%83%AD%E3%82%B0?src=hash">#はてなブログ</a>&#10;Windowsで無料でBDを再生する - 酢飯をおかずにご飯を食べる。&#10;<a href="http://t.co/Mn8agc4JuP">http://t.co/Mn8agc4JuP</a> <a href="http://t.co/ABGwFBqn1c">pic.twitter.com/ABGwFBqn1c</a></p>&mdash; 宇治松千夜 (@eai04191) <a href="https://twitter.com/eai04191/status/626281660607168512">July 29, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

[^1]: ア○キーは以前[Raspberry Piをバカにする記事](http://weekly.ascii.jp/elem/000/000/140/140621/)書いたりしてたので嫌いですし意識してサイトも見ないようにしています
[^2]: 確実に再生できる有料の再生ソフトや専用の再生機器を購入する方法もありますが, 当初の "録画環境強化するならBD買っても出費は大して変わらなくね?" の意味がなくなってしまうため今回はパスです
[^3]: この記事はもう続きません
