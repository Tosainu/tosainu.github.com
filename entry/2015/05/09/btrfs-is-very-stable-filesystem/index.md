---
title: Btrfsが死んだ
date: 2015-05-09 11:45 JST
tags: Linux, Arch Linux
---

## > 突然の死 <

それは昨日の朝のことだった.

<blockquote class="twitter-tweet tw-align-center" lang="en"><p lang="ja" dir="ltr">dmesgがbtrfsのwarningで埋まってるyabai</p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/596480331273740288">May 8, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet tw-align-center" lang="en"><p lang="ja" dir="ltr">ちょっとまって</p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/596480764578955264">May 8, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet tw-align-center" lang="en"><p lang="ja" dir="ltr">chromiumのExtensionがいくつか死んでたり, git statusができなくなったプロジェクトができたりしてる. とりあえず今日作業できない....</p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/596481481041580033">May 8, 2015</a></blockquote>

<blockquote class="twitter-tweet tw-align-center" lang="en"><p lang="ja" dir="ltr">とうとうTweetDeckでTweetできなくなった(Something wrongうんちゃら)から笑えない. とりあえず書いてたプログラムとか実験レポートのコピーだけして復旧は学校から帰ったらだ</p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/596484221675274240">May 8, 2015</a></blockquote>

ちーん

<blockquote class="twitter-tweet tw-align-center" lang="en"><p lang="und" dir="ltr"><a href="http://t.co/rsEztl7HJe">pic.twitter.com/rsEztl7HJe</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/596489983625596928">May 8, 2015</a></blockquote>

READMORE

## 予兆...?

直接大きな影響はなかったものの, 実は少し前から嫌な予感はしていた.

### 4/3 起動しなくなる

<blockquote class="twitter-tweet tw-align-center" lang="en"><p lang="ja" dir="ltr">ｱｱｱｱｱｱｱｱｱｱｱ💓💓💓💓💓💓💓💓💓💓💓💓💓💓 <a href="http://t.co/qyjdr2RIrf">pic.twitter.com/qyjdr2RIrf</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/584013642930069505">April 3, 2015</a></blockquote>

シャットダウンを掛けたところところ, 何故かいつまでたっても電源が切れなかった.  
**ディスクのアクセスランプも消えてるし, まぁいっか**と強制終了させたところ, 次の起動でこうなった.

幸い, この時はArch Linuxのインストールメディアから起動し`btrfs scrub`掛けたりしていたら治った.

### 4/16 checksum errorが出始める

<blockquote class="twitter-tweet tw-align-center" lang="en"><p lang="und" dir="ltr">(･∀･；) <a href="http://t.co/owm0DQNAdt">pic.twitter.com/owm0DQNAdt</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/588888414709157888">April 17, 2015</a></blockquote>

[某活動](/blog/2015-04-11/join-in-robocup-kiks-team/)に参加することになり, その関係でどうしてもWindows環境が必要となった.  
とりあえずの対応としてKVMにWindows 8.1 Enterprise Evaluationを入れて作業をしていたのだが, 余程負荷がエグかったのか, その仮想HDDイメージにchecksum errorが出るようになった.

とはいえ, 特別何か支障があったわけではないので放置していた.  
(KVM上の窓で若干プチフリが起きていた気もするが)

### 5/6 read errorが出始める

<blockquote class="twitter-tweet tw-align-center" lang="en"><p lang="und" dir="ltr"><a href="http://t.co/7RPs8RYrWK">pic.twitter.com/7RPs8RYrWK</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/595868510594674688">May 6, 2015</a></blockquote>

仮想で入れた窓のWindows updateを掛けたところ, Cドライブの空きがやばくなったので, ディスククリーンアップをかけていた.  
しかし, どういう訳か処理に1時間半もかかった.

もしやと思いdmesgを叩いたところ, いつもと違うエラーが出ていた...

## 復旧作業

いろいろ粘ってみたけれど, マウントもできないし`btrfs check --repair`が仕事放棄(スタックトレース?吐いて落ちる)するなど復旧する見込みがなさそうなので, 抜き出せるデータだけ取り出して環境を再構築することにした.

### 環境

エラーを起こした環境

* Arch Linux x86\_64
* linux-4.0.2
* btrfs-progs 4.0

復旧作業に使った環境

* archlinux-2015.05.01-dual.iso
* btrfs-progsは4.0に更新

エラーが起きているファイルシステムは`/dev/md126`で認識されている

### btrfs restore

死にそうなbtrfsからデータを取り出そうとしてくれる`btrfs restore`というコマンドがあるっぽい.

```
$ man btrfs-restore

BTRFS-RESTORE(8)                                    Btrfs Manual                                    BTRFS-RESTORE(8)



NAME
       btrfs-restore - try to restore files from a damaged btrfs filesystem(unmounted)

SYNOPSIS
       btrfs restore [options] <device> <path> | -l <device>

DESCRIPTION
       btrfs restore is used to try to salvage files from a damaged filesystem and restore them into <path> or just
       list the tree roots.

       Since current btrfs-check(8) or btrfs-rescue(8) only has very limited usage, btrfs restore is normally a
       better choice.

           Note
           It is recommended to read the following btrfs wiki page if your data is not salvaged with default option:
           https://btrfs.wiki.kernel.org/index.php/Restore
```

重要なファイルはホームディレクトリ内の幾つかのディレクトリにしか置いていないので, それらを可能な限り抜き出すことを試みた.

```
// バックアップ先となるUSBメモリをマウント
# mount /dev/sdd1 /mnt

// /home/myon/(codes|Documents|Downloads|Pictures)から取り出せそうなファイルを確認する
//  -v : 詳細表示
//  -i : エラーを無視して処理を継続
//  -D : dry-run (復旧できそうなファイルを表示するだけ)
//  --path-regex : 正規表現にマッチするディレクトリ/ファイルのみ抜き出す
# btrfs restore -v -i -D \
    --path-regex "^/(|home(|/myon(|/(codes|Documents|Downloads|Pictures)(|/.*))))$" \
    /dev/md126 /mnt | less

// 抜き出し開始
# btrfs restore -v -i \
    --path-regex "^/(|home(|/myon(|/(codes|Documents|Downloads|Pictures)(|/.*))))$" \
    /dev/md126 /mnt
```

抜き出すことができなかったファイルも多少あったが, 無事データの救出に成功した.

## おわり

Btrfsはまだ開発中/実験的なファイルシステムで, 公式のドキュメントにも**気をつけてね**的な記述がちらほらある.  
Twitterをはじめ, よく落ちたという話も耳にはしていた.

僕はBtrfsにSSD向けのオプションが用意されていることを知った時から非常に魅力を感じていて, 手元のSSDなArch Linuxマシンのファイルシステムは全部(2台しかないけど)Btrfsで運用している.  
実際に使ってみると, SubvolumeやPartitioning?等の機能は本当に便利だし, また管理に必要なコマンドも綺麗にまとまっていて使いやすいなと思った.  
今回ファイルシステムが死んだわけだけど, Btrfsじゃなかったら僕にデータの復旧はできなかったんじゃないか[^1]とまで思っている.

[^1]: そもそもBtrfsにしなかったらファイルシステムは死ななかったんじゃないかというツッコミはなしで

このPCでBtrfsを使い続けるのは流石に不安なのでXFSあたりに乗り換え, また素直にWindowsとのデュアルブート環境を組む予定でいるけれど, いずれはまた, より安定したBtrfsに戻りたいなと思っています.
