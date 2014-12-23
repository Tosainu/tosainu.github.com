---
title: VaioZのOSをすべて再インストールした(ArchLinux編)
date: 2014-03-20 12:41:43 JST
tags: ArchLinux,Linux,Vaio-Z2
---
どもども

&nbsp;

早速メインOSであるArchlinuxたんをインストールしていきます。

尚、細かいインストール手順は今回は書きません。

READMORE

&nbsp;

## RAIDに関する注意
### RAIDドライブの場所
RAIDドライブを組んだ場合、そのRAIDアレイはもちろん`/dev/sda`等からアクセスはできません。

VaioZのようなIntel Rapid Storage TechnologyのRAIDの場合、`/dev/md`以下を見てやるとわかりやすいです。

RAIDボリュームの名前をVolume0で組んでいる僕の環境では、次のようになりました。(おそらく環境によって値は異なります)

```
# ls -l /dev/md
total 0
lrwxrwxrwx 1 root root  8 Mar 20 19:48 imsm0 -> ../md127
lrwxrwxrwx 1 root root  8 Mar 20 19:48 Volume0_0 -> ../md126
lrwxrwxrwx 1 root root 10 Mar 20 19:48 Volume0_0p1 -> ../md126p1
```

パーティションをfdisk等で変更してやる場合、`/dev/md/VolumeName_0`またはリンク元の`/dev/md126`を指定してやります。

    # fdisk /dev/md/VolumeName_0

ちなみに、パーティションを増やしていくとmd126p1,md126p2...と増えていくようです。

### initramfs関連
boot時に一時的なrootfsとして読み込まれるinitramfsですが、ここにRAID関連のモジュールを入れてやらないと起動しません。

これを対処するために`/etc/mkinitcpio.conf`をエディタで開き、MODULESに`dm_mod`、HOOKSのudevの後ろに`mdadm_udev`を追記します。

```
MODULES="dm_mod"

HOOKS="base udev mdadm_udev autodetect modconf block filesystems keyboard fsck"
```

そして

    # mkinitcpio -p linux

してやります。

### Grubのインストール先等
先程も書きましたが、`/dev/sda`等は存在していますが、RAIDドライブ自体は`/dev/md/VolumeName_0`です。

    # grub-install --boot-directory=/boot --recheck --debug /dev/md/VolumeName_0

&nbsp;

## Windows7とのデュアルブート
`/dev/disk/by-uuid`を覗き、Windows7をインストールしたパーティションのUUIDを確認します。

```
$ ls -l /dev/disk/by-uuid | grep md126p1
lrwxrwxrwx 1 root root 13 Mar 20 20:47 0123456789abcdef -> ../../md126p1
```

この場合、`0123456789abcdef`がUUIDになります。

`/etc/grub.d/40_custom`をエディタで開き、

```
menuentry "Windows 7" {
  insmod part_msdos
  insmod ntfs
  search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 0123456789abcdef
  ntldr /bootmgr
}
```

を追記して

    # grub-mkconfig -o /boot/grub/grub.cfg

を実行します。

こうすることで起動時のGrubメニューにWindows7が表示されるようになり、Windows7も起動できるようになります。

&nbsp;

## その他設定
### Xwindow上でのキーボード配列
Xorg上でも日本語配列を使えるよう設定します。

    $ localectl set-x11-keymap jp

これで、再起動後からは日本語配列が使えるようになります。

### ハードウェアクロックをJSTで使う
Windowsと共存させてしまう以上、ハードウェアクロックをUTCに設定するのはめんどくさいです。

仕方がないのでハードウェアクロックをJSTのまま使えるように設定します。

    $ yaourt -S ntp
    $ sudo timedatectl set-local-rtc true
    $ sudo ntpd -qg
    $ sudo hwclock --systohc

&nbsp;

## 追加したソフトウェア等

これらをpacmanやyaourtを使いインストールしました。

### xorg、デスクトップ環境等

* xorg-server
* xorg-utils
* xorg-server-utils
* xf86-video-intel
* xf86-input-synaptics
* xf86-input-wacom
* awesome
* slim
* archlinux-themes-slim
* lxappearance
* adwaita-x-dark-and-light-theme (AUR)
* gnome-colors-icon-theme (AUR)
* adobe-source-code-pro-fonts
* ttf-migu (AUR)
* fontconfig-infinality (AUR)
* lib32-freetype2-infinality (AUR)

### ツール類

* zsh
* vim (using this [PKGBUILD](https://gist.github.com/Tosainu/8894892 "PKGBUILD"))
* git
* terminator
* mariadb
* thunar
* tumbler
* thunar-volman
* gvfs
* uim-mozc (AUR)
* unzip-iconv (AUR)
* sl (AUR)

### コンパイラ等

* gcc
* clang
* nodejs
* rugy
* ghc
* jdk7-openjdk
* icedtea-web-java7

### マルチメディア関連

* gimp
* inkscape
* viewnior
* blender
* gnome-mplayer

### ネットワーク関連

* google-chrome (AUR)
* firefox
* dnsutils
* nmap
* openssh
* wireshark-gtk
* filezilla
* skype

とりあえず主要ソフトウェアはこのくらいでしょうか。

&nbsp;

それにしても、RAID有効にしたVaioたん速いです。

ではでは〜
