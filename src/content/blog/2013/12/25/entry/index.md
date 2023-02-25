---
title: 最近のArch Linuxのインストールで注意すること＆Arch LinuxをSDカードにインストールするときに注意すること
date: 2013-12-25 00:02:07+0900
noindex: true
tags: Linux, Arch Linux
---
どーもです。

昨年の冬休みと同様に、また風邪ひきましたwww

皆さんも風邪には気をつけましょう。

&nbsp;

## 最近のArch Linuxのインストールで注意すること

grub-mkconfigにバグ(のようなもの)があり、以下のようになり正しく動作しません。

```
sh-4.2# grub-mkconfig -o /boot/grub/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-linux
Found initrd image: /boot/initramfs-linux.img
error: out of memory.
error: syntax error.
error: Incorrect command.
error: syntax error.
Syntax error at line 164
Syntax errors are detected in generated GRUB config file.
Ensure that there are no errors in /etc/default/grub
and /etc/grub.d/* files or please file a bug report with
/boot/grub/grub.cfg.new file attached.done
```

これを解決するには、/etc/default/grubの最終行にGRUB_DISABLE_SUBMENU=yを追記してやることで解決します。

<a href="https://bbs.archlinux.org/viewtopic.php?id=174298">[SOLVED]Anyone else having problem with grub-mkconfig? (Page 1) / Applications & Desktop Environments / Arch Linux Forums</a>

```
# echo "GRUB_DISABLE_SUBMENU=y" >> /etc/default/grub
```

&nbsp;

## Arch LinuxをSDカードにインストールするときに注意すること

例のサーバOSもArch Linuxでいこうとしたのですが、BootDriveをSDにしたせいかうまく起動できない！！

<img src="https://lh4.googleusercontent.com/-YG2zx1ZTavo/UrmeUr08vHI/AAAAAAAAC1A/fzFBQenHK9I/s640/DSC_0249.JPG" />

こんな感じにEmergencyModeに入ってしまいました。

&nbsp;

これを解決するには、SDカード上のパーティションのJournalingを無効化する必要があるようです。

また、もしかしたらSDカードに作るパーティションは1つだけのほうが無難かもしれません。

Ext4の場合のJournaling無効の手順はこちらを参考にさせて頂きました。

<a href="http://fenidik.blogspot.jp/2010/03/ext4-disable-journal.html">just another blog: ext4 disable journal</a>

&nbsp;

```
// 対象のディスクは/dev/sdaとする
// fdiskでパーティション作成
# fdisk /dev/sda

// ext4でフォーマット
# mkfs.ext4 /dev/sda1

// writeback modeを有効にする。パフォーマンスに貢献してくれるらしい。
# tune2fs -o journal_data_writeback /dev/sda1

// ジャーナル削除
# tune2fs -O ^has_journal /dev/sda1

// Fuckが必要らしい(よくわかんない><)
# e2fsck -f /dev/sda1

// ディスクの詳細がこのコマンドで確認できる
# dumpe2fs /dev/sda1 |more
```

そして、fstabの設定も修正しておきます

```
UUID=hogehogehogehoge / ext4 defaults,data=writeback,noatime,nodiratime 0 0
```

この対処により、見事起動するようになりました。

やったね！

&nbsp;

あ、日付がたった今変わりました。

<span class="fontsize7">メリークルシミマス！！！！！</span>
