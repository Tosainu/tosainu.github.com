---
title: Arch Linuxインストールめも (2013版)
date: 2013-11-07 21:28:09+0900
tags: Arch Linux
---

**この記事は古いです. 新しい記事をどうぞ.  
[Arch Linuxインストールめも (2014秋版)](/entry/2014/10/06/archlinux_installation_memo_2014/)**


2013/11/17 (Sun) 9:45:29 誤字をいくつか修正

2013/12/7 (Sat) 0:48:19 誤字修正および一部の環境での対処を追記

2014/1/25 (Sat) 1:23:52 インストールするパッケージ等を追記・修正

&nbsp;

どーもです。

以前、とても役立たない記事をかいてすいませんでした。

今回はマトモに書こうと思います、はい。

&nbsp;

※あくまで一例ですので・・・

<!--more-->

&nbsp;

## 本記事と合わせて読みませう

<a href="https://wiki.archlinux.org/index.php/Installation_Guide">Installation Guide - ArchWiki</a>

<a href="http://extrea.hatenablog.com/entry/2013/09/16/020230">Arch Linuxインストールメモ （archlinux-2013.09.01） - 海馬のかわり</a>

&nbsp;

## 準備

インストールディスクのイメージをダウンロードします。<a href="https://www.archlinux.org/">Arch Linux</a>の上部左側Downloadsへ移動し、ページ中央ほどにあるJapanのどちらかのミラーサーバーからarchlinux-yyyy.mm.dd-dual.isoをダウンロード、CD-Rなどのディスクに書き込みます。

しかし、原因は不明ですが、ディスクに書き込んだ場合ちゃんと起動しない現象に遭遇する気がします。

<a href="https://wiki.archlinux.org/index.php/USB_Installation_Media">USBフラッシュメモリでの起動</a>や、DriveDroidでのインストールをおすすめします。

&nbsp;

インストール先のPCは、インストールディスクから起動できるようBIOS等の設定を確認しておきます。

&nbsp;

## インストールディスクでの作業

今回も<a href="http://extrea.hatenablog.com/">海馬のかわり</a>管理人のextreaさんの記事を参考にさせていただきました。

&nbsp;

### 初期設定

```
// 日本語キーボードの配列を読み込む
# loadkeys jp106

// 無線LANによる接続を行う
# wifi-menu

// 接続できたかの確認 (Ctrl+cで中断)
# ping www.archlinux.org
PING gudrun.archlinux.org (66.211.214.131) 56(84) bytes of data.
64 bytes from gudrun.archlinux.org (66.211.214.131): icmp_seq=1 ttl=42 time=197 ms
64 bytes from gudrun.archlinux.org (66.211.214.131): icmp_seq=2 ttl=42 time=199 ms
64 bytes from gudrun.archlinux.org (66.211.214.131): icmp_seq=3 ttl=42 time=202 ms
^C
--- gudrun.archlinux.org ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 197.006/199.529/202.143/2.098 ms
```

&nbsp;

### パーティションの作成

今回はこのようにパーティションを切りました。

デバイス | 容量 | ファイルシステム | マウント先
----- | ------ | ---  | -------------
/dev/sda1 | 100MB | ext4 | /boot
/dev/sda2 | 50GB | ext4 | /
/dev/sda3 | 残り | ext4 | /home

インストール先がSSD、またRAM自体十分な容量であるためswapは作成していません。

```
// インストール先のディスクの再確認
# fdisk -l

// パーティションを切る
# fdisk /dev/sda
・・・略

// すべてext4でフォーマットする
# mkfs.ext4 /dev/sda1
・・・略

// マウント
# mount /dev/sda2 /mnt
# mkdir /mnt/boot
# mount /dev/sda1 /mnt/boot
# mkdir /mnt/home
# mount /dev/sda3 /mnt/home
```

&nbsp;

### システムのインストール

ついでに最強のエディタも入れちゃいます

```
# pacstrap /mnt base base-devel
# pacstrap /mnt grub-bios
# pacstrap /mnt net-tools netctl dnsutils sysstat mlocate openssh

// 最強のエディタ
# pacstrap /mnt vim

// wifi-menuに必要
# pacstrap /mnt dialog wpa_supplicant
```

&nbsp;

### システムの設定

```
// fstabの生成
# genfstab -p /mnt >> /mnt/etc/fstab

// 新しい環境にchroot
# arch-chroot /mnt

// Hostname
sh-4.2# echo "vpcsb.localdomain" >> /etc/hostname

// Timezone
sh-4.2# ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

// ロケールと言語
sh-4.2# echo "LANG=en_US.UTF-8" > /etc/locale.conf
sh-4.2# vim /etc/locale.gen
en_US.UTF-8 UTF-8をコメントアウト

sh-4.2# locale-gen

// Ram Image
sh-4.2# mkinitcpio -p linux

// grubをインストール
sh-4.2# grub-install --target=i386-pc --boot-directory=/boot --recheck --debug /dev/sda
sh-4.2# grub-mkconfig -o /boot/grub/grub.cfg
sh-4.2# cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
sh-4.2# cd /boot/grub/locale
sh-4.2# gzip en.mo

// rootのパスワード設定
sh-4.2# passwd

// chroot環境を抜けて再起動
sh-4.2# exit
# umount /mnt/{boot,}
# reboot
```

ここで、再びインストールディスクで起動してしまわないよう注意しましょう。

&nbsp;

## グラフィック環境を整えるまでの作業

ネットワークへの接続は、インストールディスクでの作業と同様に済ませておきます。

### ミラーサーバの設定とyaourtのインストール

```
// rankmirrorsを使って速いミラーサーバを探す
# cp -p /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.org
# rankmirrors -n 3 /etc/pacman.d/mirrorlist.org > /etc/pacman.d/mirrorlist

// yaourtのインストール
# pacman -Sy base-devel diffutils gettext yajl curl wget

# wget https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
# tar xvzf package-query.tar.gz
# cd package-query
# makepkg --asroot ; echo $?
# pacman -U package-query-(バージョン).pkg.tar.xz
# cd ../

# wget https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
# tar xvzf yaourt.tar.gz
# cd yaourt
# makepkg --asroot ; echo $?
# pacman -U yaourt-(バージョン)-any.pkg.tar.xz
# yaourt --stats
```

&nbsp;

### makepkg.confとfstabの調整

makepkgに関しては以前の記事を参考に→<a href="http://tosainu.wktk.so/view/272">【Arch Linux】makepkg.confを弄る</a>

fstabをUUIDで設定、さらにはSSDのTRIMを有効に、

そして/tmpと/var/tmpをtmpfs(ramdisk)に当てるように修正します。

$ sudo vim /etc/fstabで開き、

```
# 
# /etc/fstab: static file system information
#
# <file system>	<dir>	<type>	<options>	<dump>	<pass>
# UUID=hogehogehogehogehogehoge
/dev/sda2           	/         	ext4      	rw,relatime,data=ordered	0 1

# UUID=fugafugafugafugafugafuga
/dev/sda1           	/boot     	ext4      	rw,relatime,data=ordered	0 2

# UUID=myonmyonmyonmyonmyonmyon
/dev/sda3           	/home     	ext4      	rw,relatime,data=ordered	0 2
```

これを、

```
# 
# /etc/fstab: static file system information
#
# <file system>	<dir>	<type>	<options>	<dump>	<pass>
UUID=hogehogehogehogehogehoge           /         	ext4      	discard,noatime,errors=remount-ro	0 1

UUID=fugafugafugafugafugafuga           /boot     	ext4      	discard,noatime,errors=remount-ro	0 2

UUID=myonmyonmyonmyonmyonmyon           /home     	ext4      	discard,noatime,errors=remount-ro	0 2

tmpfs	/tmp		tmpfs	defaults	0 0
tmpfs   /var/tmp	tmpfs   defaults        0 0
```

のようにします。

```
$ sudo rm -rf /tmp/*
$ sudo rm -rf /var/tmp/*
$ sudo mount -a
```

でエラーが出なければ問題無いです。

&nbsp;

### zshのインストール

```
# pacman -S zsh
# chsh -s /bin/zsh

// .zshrcを持ってくる
# wget http://tosainu.wktk.so/files/medias/.zshrc
# exit
// 反映させるためにログインし直す

# echo $SHELL
/bin/zsh
```

&nbsp;

### 一般ユーザの作成

常にrootを利用するのはアレなので、一般ユーザを作成します。

ユーザー名は仮に"myon"とします。

```
// 個人のグループの作成
# groupadd myon

// ユーザーの作成
# useradd -m -g myon -s /bin/zsh myon
# gpasswd -a myon users
# gpasswd -a myon wheel

// パスワードの設定
# passwd myon

// wheelグループのユーザがパスワードなしでsudoを使えるようにする
# EDITOR=vim visudo
%wheel ALL=(ALL) NOPASSWD: ALLをコメントアウト

// .zshrcをコピる
# cp ~/.zshrc /home/myon/
# cd /home/myon
# chown myon:myon .zshrc

# reboot
```

以後、ここで作成したユーザーから環境を作っていきたいと思います。

&nbsp;

### グラフィック環境を整える

今回はログインマネージャにgdm、デスクトップ環境にはCinnamonを使うこととします。

wifi-menuなどによるネットワーク接続も忘れずに。

（なぜnetctlの自動起動を有効にしないかというと、グラフィック環境を整えてからはNetworkManagerを使う予定だからです）

```
// multilibを有効にする
$ sudo vim /etc/pacman.conf
// 以下の部分をコメントアウト
[multilib]
Include = /etc/pacman.d/mirrorlist

// xorgの基本的パッケージとドライバのインストール(すいませんRADEON・ATI系は確認できません)
$ yaourt -Sy xorg-server xorg-utils xorg-server-utils (nvidia xf86-video-intel xf86-video-ati)
:: There are 3 providers available for libgl:
:: Repository extra
 1) mesa-libgl 2) nvidia-304xx-utils 3) nvidia-libgl

// nvidia系VGAを積んでいない場合はそのままEnter, 最近のnvidiaVGAは3でEnter
Enter a number (default=1): 

・・・略

// Syapticsタッチパッドドライバ
$ yaourt -S xf86-input-synaptics

// Wacomタブレットドライバ
$ yaourt -S xf86-input-synaptics

// gdmとCinnamon
$ yaourt -S cinnamon gdm

// gdmとNetworkManagerの有効化
$ sudo systemctl enable gdm.service
$ sudo systemctl enable NetworkManager

// 再起動
$ sudo reboot
```

次からはgdmによるログイン画面が表示されるはずです。

Sign Inボタン左側の歯車アイコンから、"Cinnamon"を選択してログインします。

<img src="https://lh6.googleusercontent.com/-5i55N68kJc8/UnxCdZtgN9I/AAAAAAAACss/djZT31p2mdw/s640/IMG_1258.JPG" />

&nbsp;

## 必要なソフトウェアや開発環境の整備

あくまで一例ですが、僕が普段使っているソフトウェア類を紹介したいと思います。

### フォントの調整

日本語フォントのmigu、ターミナル/コード表示用にSourceCodeProを追加します。

```
$ yaourt -S ttf-migu
// Edit PKGBUILD?やEdit ttf.install?にはn、Continue installing ttf-migu?にはyでインストール

$ wget http://downloads.sourceforge.net/sourceforge/sourcecodepro.adobe/SourceCodePro_FontsOnly-1.017.zip
$ unzip SourceCodePro_FontsOnly-1.017.zip
$ cd SourceCodePro_FontsOnly-1.017
$ sudo cp TTF/* /usr/share/fonts/TTF/
$ fc-cache -vr
```

あとはWMの設定等でフォントを設定してください。参考までに、僕はこのように設定しました。

<img src="https://lh4.googleusercontent.com/-MvMSiayJbe0/UnxuQ80kJNI/AAAAAAAACtE/k-zp1JtsTUo/s640/Screenshot%2520from%25202013-11-08%252013%253A50%253A59.png" />

&nbsp;

また、フォントレンダリングをより綺麗にするためにinfinalityパッチセットを追加します。

```
$ yaourt -S fontconfig-infinality lib32-freetype2-infinality
```

&nbsp;

### IME

<sp style="color:red;"><u>注:いろいろあって非常に導入が難しくなっています。</u></span>

僕の環境ではこれで動きましたが、環境によっては動かないかもしれません・・・

もし困ったら、メールやtwitterで連絡ください。

```
$ yaourt -S uim-mozc
```

また、~/.xinitrcを

```
#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
# Make sure this is before the 'exec' command or it won't be executed.
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile
```

~/.xprofileを

```
#!/bin/sh

export XMODIFIERS="@im=uim"
export GTK_IM_MODULE="uim"
// 【追記】↑でダメならば GTK_IM_MODULE=xim を試してみてください

export QT_IM_MODULE="uim"
uim-xim &
uim-toolbar-gtk3-systray &
```

にします。

uimの設定画面を開き、

```
$ uim-pref-gtk3
```

<img src="https://lh4.googleusercontent.com/-WgcwXU-Udhg/UnyAz8swZ9I/AAAAAAAACtU/71g0Lp_D_e8/s640/Screenshot%2520from%25202013-11-08%252015%253A07%253A06.png" />

<img src="https://lh6.googleusercontent.com/-dmY0qm5-fGc/UnyAzl9z8AI/AAAAAAAACtc/fWflQhMXYqo/s640/Screenshot%2520from%25202013-11-08%252015%253A11%253A12.png" />

という感じに設定し、もう一度ログインすれば・・・・・・・・きっと・・・・・・・・・・

&nbsp;

### ブラウザ

メインはgoogle-chromeですが、表示確認のためfirefoxも入れています。

```
$ yaourt -S google-chrome firefox
```

&nbsp;

### 画像編集ソフト

有名なのはGIMPでしょう。Windows版GIMPはファッキンヘビー（クソおもい）ですが、Linux版は超快適です。

ベクタ画像編集ソフトのInkscapeも入れます。

```
$ yaourt -S gimp inkscape
```

&nbsp;

### オフィス系ソフトウェア

pdf表示に欠かせないAdobeReader、必要があればLibreOfficeも入れておきます。

```
$ yaourt -S acroread-ja
ここでもmesaの選択を要求されますが、何も入力せずEnterで大丈夫です。

$ yaourt -S libreoffice
必要なものを選んでEnter
```

TeX

```
$ yaourt -S texlive-core texlive-langcjk poppler-data

$ vim /etc/texmf/dvipdfmx/dvipdfmx.cfg
// f  cid-x.mapをコメントアウト

$ sudo mktexlsr
```

&nbsp;

### ターミナル

環境によっては少し重いかもしれませんが、標準のものよりも高性能なterminatorを入れます。

```
$ yaourt -S terminator
```

&nbsp;

### メディアプレイヤー

僕はgnome-mplayerが好きです。

```
$ yaourt -S gnome-mplayer
```

Menu→Sound & Video→GNOME Mplayerから起動、

Edit→Preferrencesから設定画面を開いて、MPlayerタブの"MPlayer Default Optical Device"に"/dev/sr0"(マシンのデフォルトの光学ドライブのパス)を設定することで、外部のコーデック等のインストールも必要なくDVDの再生ができることを確認しました。

<img src="https://lh6.googleusercontent.com/-U01WEHhdbfk/UnxCgaN89II/AAAAAAAACs0/YJjjJQ_8NDU/s640/IMG_1260.JPG" />

&nbsp;

### パーティション管理

gpartedが高性能で使いやすいです。

```
$ yaourt -S gparted
```

&nbsp;

### エディタ

すべての機能が有効化されたvim

```
$ yaourt -S vim-full
```

たまに使いたくなるguiのテキストエディタ

```
$ yaourt -S geany
```

&nbsp;

### Git

```
$ yaourt -S git
$ git config --global user.name "Ueo Ai"
$ git config --global user.email hoge@example.com
```

&nbsp;

### コンパイラ等

clang, Ruby, Node.js, Java6

```
$ yaourt -S clang ruby nodejs jdk6
```

AVRマイコン・Arduino関係

こちら→

<a href="http://tosainu.wktk.so/view/320">【Arduino/AVR】Linux環境でAssemblyLangプログラミングしたメモ</a>

<a href="http://tosainu.wktk.so/view/310">【Arduino】Linuxで快適Arduino開発（Vim + Makefile）</a>

Cで開発したい場合、本ブログでは紹介していませんが、avr-gccを入れると幸せになれるとおもいます。

&nbsp;

### AndroidSDK

こちら→<a href="http://tosainu.wktk.so/page/andsdk">Android SDKを整える</a>

&nbsp;

### Virtualbox

```
$ yaourt -S virtualbox virtualbox-host-modules virtualbox-host-dkms linux-headers
$ sudo gpasswd -a myon vboxusers
$ sudo systemctl enable dkms.service
```

&nbsp;

### Boinc

```
$ yaourt -S boinc
$ yaourt -S lib32-glibc lib32-glib2 lib32-pango lib32-libxdamage lib32-libxi lib32-libgl lib32-libjpeg6 lib32-libxmu
$ ln -s /var/lib/boinc/gui_rpc_auth.cfg ~/gui_rpc_auth.cfg
$ sudo chmod 640 ~/gui_rpc_auth.cfg
$ sudo systemctl enable boinc.service
$ sudo gpasswd -a moyn boinc
$ sudo gpasswd -a boinc video
$ echo "xhost local:boinc" >> .xprofile
```

&nbsp;

まぁこんな感じでしょうか。

まぁそれでもわからなかったら連絡ください。

ではでは〜
