---
title: Arch Linuxインストールめも (2014秋版)
date: 2014-10-06 00:51:00+0900
tags: Arch Linux, DIY PC
---

どーもです.

メイン機のArch Linuxを再インストールをしたのでメモ.  
今回はUEFI-BootだとかBtrfsだとか, いろいろナウい感じにインストールしてみました.

## System Environment

* Intel Core i7-3930k
* Asus Rampage IV Formula (BIOS 4901)
* Geforce GTX 660 Ti
* 32GB RAM
* 256GB SSD
* 3TB HDD
* HHKB Lite 2 (US-Layout)

## Feature

* GPTなディスクでUEFI-Boot
* システムドライブにBtrfs
* Win10TPとDualBoot
* LightDM & Cinnamon

<!--more-->

## Before Installation

BIOSの設定を開いて,

* **Secure Bootを無効に**
* CSMで各デバイスをUEFI-Firstに
* FastBootも一時的に切ったほうが良いかも

気をつけなければいけないのは, 各インストールメディアをUEFIモードでBootさせなければいけないことです.  
UEFIなシステムと認識されず, GPTなディスクにインストールできません.

あと, 先にWinをインストールしておくとDualboot環境が組みやすいです.

## \#archinstallbattle, はっじまるよ〜

```
// 無線LANにつなぐ
# wifi-menu

# ping -c 3 www.archlinux.org
PING gudrun.archlinux.org (66.211.214.131) 56(84) bytes of data.
64 bytes from gudrun.archlinux.org (66.211.214.131): icmp_seq=1 ttl=44 time=217 ms
64 bytes from gudrun.archlinux.org (66.211.214.131): icmp_seq=2 ttl=44 time=213 ms
64 bytes from gudrun.archlinux.org (66.211.214.131): icmp_seq=3 ttl=44 time=215 ms

--- gudrun.archlinux.org ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 213.972/215.602/217.699/1.602 ms

// ミラーサーバの設定
// jaistを一番上に
# vi /etc/pacman.d/mirrorlist
```

## Configure Partition

こんな感じにした

| Device | Capacity | Filesystem | Mountpoint | Memo |
| ------ | -------: | ---------- | ---------- | ---- |
| /dev/sda | 256GB |  |  | SSD |
| /dev/sda1 | 512MB | FAT32 | /boot/efi | ESP(EFI System Partition)ってやつ |
| /dev/sda2 | 64GB | Btrfs | / |  |
| /dev/sda3 | 64GB |  |  | もう一つOS入れる予定 |
| /dev/sda4 | 残り | NTF\*ckSystem |  | Win用 |
| /dev/sdb | 3TB |  |  | HDD |
| /dev/sdb1 | 1.5TB | EXT4 | /home |  |
| /dev/sdb2 | 50GB | EXT4 | /var | BOINCの関係でSSDとは別にした |
| /dev/sda3 | 250GB |  |  | 予備 |
| /dev/sdb4 | 残り | NTF\*ckSystem |  | ゴミFSに大事なデータなんて置けない |

```
// パーティション作成
# gdisk /dev/sda
# gdisk /dev/sdb

// フォーマット
# mkfs.vfat -F32 /dev/sda1
# mkfs.btrfs /dev/sda2
# mkfs.ext4 /dev/sdb1
# mkfs.ext4 /dev/sdb2

// マウント
# mount -o noatime,discard,ssd,autodefrag,compress=lzo,space_cache /dev/sda2 /mnt
# mkdir -p /mnt/boot/efi
# mount /dev/sda1 /mnt/boot/efi
# mkdir /mnt/home
# mount /dev/sdb1 /mnt/home
# mkdir /mnt/var
# mount /dev/sdb2 /mnt/var
```

## pacstrap

わかりやすいようにコマンド分けたけど, 一発でもおk

```
// base
# pacstrap /mnt base base-devel

// ブートローダ関係
# pacstrap /mnt grub efibootmgr

// ファイルシステム関係
# pacstrap /mnt dosfstools btrfs-progs lzo

// ネットワーク関係
# pacstrap /mnt openssh dialog wpa_supplicant

// その他
# pacstrap /mnt vim-python3 zsh git
```

## Configure New System

```
// fstab作る
# genfstab -p /mnt >> /mnt/etc/fstab
# echo 'tmpfs /tmp  tmpfs defaults,noatime,nosuid  0 0' >> /mnt/etc/fstab
# echo 'tmpfs /var/tmp  tmpfs defaults,noatime,nosuid  0 0' >> /mnt/etc/fstab
// /dev/sda*ではなくUUID=のように書き換える(fstab見ればわかる)
# vi /mnt/etc/fstab

// W-LAN接続の設定も持ってくる
# cp /etc/netctl/CONNECTION_CONFIG_FILE /mnt/etc/netctl/Kokoro-PyonPyon

// chroot!!!
# arch-chroot /mnt

// root password
(chroot)# passwd

// hostname
(chroot)# echo 'RabbitHouse' > /etc/hostname

// Timezone
(chroot)# ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

// Locale
(chroot)# echo 'LANG=en_US.UTF-8' > /etc/locale.conf
(chroot)# sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
(chroot)# locale-gen

// initramfs
// HOOKSのfsckの後ろにbtrfsを加える
(chroot)# vim /etc/mkinitcpio.conf
(chroot)# mkinitcpio -p linux

// gurbのインストール
(chroot)# mkdir /boot/efi/EFI
(chroot)# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Grub --recheck --debug
(chroot)# grub-mkconfig -o /boot/grub/grub.cfg

(chroot)# exit
# umount /mnt/{boot/efi,}
# reboot
```

再起動後はrootでログインし, `netctl start Kokoro-PyonPyon` すればW-LANでつながるはずです.

## pacman, makepkg.conf, yaourt

`/etc/pacman.conf` を開き, 以下をアンコメント.

```
Color

[multilib]
Include = /etc/pacman.d/mirrorlist
```

`/etc/makepkg.conf` の `ARCHITECTURE, COMPILE FLAGS` をこんな感じにした.

```shell
#########################################################################
# ARCHITECTURE, COMPILE FLAGS
#########################################################################
#
CARCH="x86_64"
CHOST="x86_64-unknown-linux-gnu"

#-- Compiler and Linker Flags
# -march (or -mcpu) builds exclusively for an architecture
# -mtune optimizes for an architecture, but builds for whole processor family
CPPFLAGS="-D_FORTIFY_SOURCE=2"
CFLAGS="-march=native -O2 -pipe -fstack-protector --param=ssp-buffer-size=4"
CXXFLAGS="${CFLAGS}"
LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro"
#-- Make Flags: change this for DistCC/SMP systems
MAKEFLAGS="-j12"
#-- Debugging flags
DEBUG_CFLAGS="-g -fvar-tracking-assignments"
DEBUG_CXXFLAGS="-g -fvar-tracking-assignments"
```

yaourtのインストールは面倒だからスクリプト書いた.

```
# curl tosainu.bitbucket.org/install_yaourt.sh | bash
```

## Create User

```
// 個人用グループの作成
# groupadd chino

// ユーザの作成
# useradd -m -g chino -G wheel -s /bin/zsh chino

// パスワード
# passwd chino

// sudoersを弄ってwheelグループのユーザがsudoできるようにする
// 78行目あたりの "%wheel ALL=(ALL) NOPASSWD: ALL" をコメントアウト
# EDITOR=vim visudo
```

以後, このユーザで作業していきます.

## Window Manager

Geforce載っけてるのでnvidiaを入れます.  
当然, 他のGPUの場合は以下をコピペしても動きません.

Intelならxf86-video-intel, Radeonならcatalystで良いと思う.

```
// xorg
// libgl云々と聞かれたらnvidia-libglを選択
$ yaourt -Sy xorg-server xorg-server-utils xorg-server-xephyr xorg-utils nvidia

// Wacomペンタブ
$ yaourt -S xf86-input-wacom

// cinnamon
$ yaourt -S cinnamon

// lightdm
$ yaourt -S lightdm lightdm-gtk3-greeter
// 動作確認
$ lightdm --test-mode --debug

// GUI起動してもターミナルエミュレータがないと詰む
$ yaourt -S lilyterm

// いろいろ必要
$ yaourt -S gnome-keyring

// サービスを有効に
$ sudo systemctl enable lightdm
$ sudo systemctl enable NetworkManager

// 再起動
$ sudo systemctl restart
```

これで再起動後LightDMのログイン画面やCinnamonが動くはずです.  
GUIが起動したあとはNetworkManagerを使ってインターネッツに接続すると便利.

## Install Useful Softwares

以下をyaourtで入れていきます.

### Font

**フォント**は**ふぉんと(本当)**に大事.

* adobe-source-code-pro-fonts
* ttf-migu (AUR)

infinalityパッチを適用する. 設定はお好みで.

* fontconfig-infinality (AUR)
* lib32-freetype2-infinality (AUR)

### Browser

* chromium
* chromium-pepper-flash (AUR)
* firefox

### IME

* fcitx-im
* fcitx-qt5
* fcitx-configtool
* fcitx-mozc

fcitx入れるとCinnamon氏が勝手に自動起動の設定作ってくれるっぽい.  
今のところ `.xprofile` に環境変数設定しなくても動いてるので, もしかしたらいらないかもしれないけど一応.

```shell
#!/bin/sh
#
# ~/.xprofile
#

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export DefaultIMModule=fcitx
```

```shell
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

### xdg-user-dirs

`~/Music` とかのディレクトリを設定してくれる.  
インストール後 `xdg-user-dirs-update` すると各フォルダが `~/` 下に作成される.  
また, `xdg-user-dirs-gtk-update` とすることでneomo(Cinnamonデフォルトのファイルマネージャ)のサイドバーにもMusic等が表示されるようになる.

* xdg-user-dirs
* xdg-user-dirs-gtk

### Multimedia

* audacious
* audacity
* brasero
* gnome-mplayer
* sound-juicer

### Graphics

* blender
* calligra-krita
* gimp
* inkscape
* rawtherapee
* viewnior

### Office

epdfviewはPDF見るやつ.

* epdfview
* libreoffice-fresh

### Tools

便利なやつら.

* dropbox (AUR)
* file-roller
* filezilla
* gdisk
* gnome-disk-utility
* gnome-system-monitor
* gparted
* iftop
* nemo-dropbox (AUR)
* nmap
* ntp
* sl
* sysstat
* tree
* wireshark-gtk
* xsensors

### Games

あんまりやらないけど.

* steam
* supertuxkart

### libvirt

なんか結構重要な依存パッケージ勝手に入れてくれないっぽい.

* dmidecode
* dnsmasq
* ebtables
* libvirt
* qemu
* virt-manager

```
sudo groupadd libvirt
sudo groupadd kvm
sudo gpasswd -a $USER libvirt
sudo gpasswd -a $USER kvm
sudo systemctl enable libvirtd
```

`/etc/libvirt/libvirtd.conf` を開いて以下をコメントアウト.

```
unix_sock_group = "libvirt"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0770"
auth_unix_ro = "none"
auth_unix_rw = "none"
```

### Programing

このPCはプログラム書くのに使うPCではないので必要最小限.  
Rubyとかは`vim-python3`入れた時に入ってるかも.

* boost
* clang
* ghc
* libc++
* qtcreater
* ruby

## Dual Boot

`/etc/grub.d/40_custom` に以下を追記.

```shell
if [ "${grub_platform}" == "efi" ]; then
menuentry "Windows 10 Technical Preview" {
  insmod part_gpt
  insmod fat
  insmod search_fs_uuid
  insmod chain
  search --fs-uuid --set=root $hints_string $uuid
  chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
fi
```

`$uuid` と `$hints_string` には以下のコマンドを実行した時の結果を設定します.

```
// $uuid
$ sudo grub-probe --target=fs_uuid /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi

// $hints_string
$ sudo grub-probe --target=hints_string $esp/EFI/Microsoft/Boot/bootmgfw.efi
```

設定が済んだらGrubの設定ファイルを再生成します.

```
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
```

再起動してデュアルブートできるか確認.

## Finish!

それでは楽しいArch Linuxライフを〜.
