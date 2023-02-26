---
title: ConoHaはじめたからとりあえずbtrfsにArch Linux入れた
date: 2014-07-13 22:29:50+0900
noindex: true
tags:
  - Linux
  - Arch Linux
---
みょーーん.

僕ん家の回線は特に下りが遅く, 何よりプロバイダの都合でウェルノウンポートを開放できないという, イマドキのネット生活には耐え難い仕様をしております.  
そんなこともあり以前からVPSを検討していましたが, 主に資金面での問題やその他諸々で契約できずにいました.

そんな中, 先週のOSC@Nagoyaで, なんとConoHa3,000分のクーポンを頂いてしまいまして...  
![conoha](https://lh6.googleusercontent.com/-VnByMug8FYY/U8Jv_zwgXBI/AAAAAAAADaE/i59wdqiAE1E/s640/IMG_1970.JPG "conoha")

"これは申し込まなきゃいけないッ" ってことでConoHaはじめました.

<!--more-->

## アカウント作成からVPS作成まで

公式のブログがわかりやすいのでそちらを読みませう.  
[第2回：ConoHaでVPSをはじめてみよう！ | ConoHa](https://www.conoha.jp/conoha/learning/1385.html)

気をつけることは, VPS作成の前に電話認証と支払い方法の選択をしておかないといけないことです.

とりあえずデフォルトのCentOS 6.5を選択し起動しました.

## SSH経由シリアルコンソール接続

指定されたユーザと鍵を使ってSSH接続をすると, **SSH経由シリアルコンソール接続**ができます.  
これが凄くて, ただのSSH接続ではなくシリアルコンソール接続, つまりただVPS上のOSにログイン出来るだけでなく起動ログなんかも見れたりします.

"なんか鯖に繋がらない！！" って時も, このSSH経由シリアルコンソール接続をできるようにすればいちいちコントロールパネルのVNCを開かなくて良くなったりとで本当に便利そうです.

## CentOS 7にはまだアップグレードしないほうがいいかも

先日CentOS 7が発表されましたね.  
ってことで早速アップグレードしてみたのですが, うーん.
  
例えば, nginxは標準のCentOSレポジトリからは入れることができず, EPELやNginx公式の用意する外部のレポジトリを追加する必要があります.  
しかし, どちらもCentOS 7対応はまだらしく, 無理やり追加してもCentOS 6用のパッケージを引っ張ってきたりでうまくインストールすることができませんでした.  
おそらく自分でソースを落としてmakeすればいいんでしょうが, ちょっと自信がなかったので諦めることにしました.

## ConoHaにArch Linuxを入れる

慣れたOSってのは最高です.  
近いうちにLPICを受けたいな〜とも思ってるのでRHEL系やDebian系にももっと触れなくてはと思ってはいるんだけれども......

さて今回の #archinstallbattle の目標はこんな感じ

* とりあえずWebサーバとして動かす
* ConoHaのウリでもあるIPv6接続ができるようにする
* 公開鍵認証によるSSH接続やiptables等の最低限のセキュリティ
* ファイルシステムに**btrfs**を使う

### インストーラの起動

[前回のお名前VPS](http://tosainu.wktk.so/view/347)と同様に, 指定されたユーザと鍵でSFTP接続をしてArch Linux Netboot Live Systemのisoをアップロード, メニューからipxe.isoを選んでVPSを起動させます.  
ほんと, 1MBのイメージで済んじゃうのはすごい.

### パーティション

今回はファイルシステムにbtrfsを使うことにしました.

[一部界隈](http://togetter.com/li/513383)ではよく落ちると言われているファイルシステムなので実際不安なんですが, SSDへの最適化だとか魅力的な機能が多く, いずれ使ってみたいと思っていたこともあり今回使うことにしました.  
パーティション構成はこんな感じ.

Device | Capacity | Filesystem | Notes
------ | ----- | ---  | -------------
/dev/vda1 | 2GB | swap | スワップ
/dev/vda2 | 80GB | btrfs | rootにする. /homeと/varはsubvolumeにした.

    # mkfs.btrfs -L "Arch Linux" /dev/vda2
    # mkdir /mnt/btrfs-root
    # mount -o rw,relatime,compress-force=lzo,space_cache,autodefrag /dev/vda2 /mnt/btrfs-root
    
    // subvolume作成のため一時的にマウント
    # mkdir -p /mnt/btrfs-root/__current
    # btrfs subvolume create /mnt/btrfs-root/__current/ROOT
    # btrfs subvolume create /mnt/btrfs-root/__current/home
    # btrfs subvolume create /mnt/btrfs-root/__current/var
    
    // 作成したsubvolumeをマウント
    # mkdir -p /mnt/btrfs-current
    
    # mount -o rw,relatime,compress-force=lzo,space_cache,autodefrag,subvol=__current/ROOT /dev/vda2 /mnt/btrfs-current
    # mkdir -p /mnt/btrfs-current/home
    # mkdir -p /mnt/btrfs-current/var
    
    # mount -o rw,relatime,compress-force=lzo,space_cache,autodefrag,subvol=__current/home /dev/vda2 /mnt/btrfs-current/home
    # mount -o rw,relatime,compress-force=lzo,space_cache,autodefrag,subvol=__current/var /dev/vda2 /mnt/btrfs-current/var

### インストール

pacstrap先のディレクトリには`/mnt/btrfs-current`を指定します.  

    # pacstrap /mnt/btrfs-current base base-devel grub-bios net-tools netctl dhclient dnsutils sysstat openssh vim

`dhclient`がないとIPv6アドレスをDHCPから取得してくれませんでした.

また, btrfsから起動できるようにするために, `/etc/mkinitcpio.conf`をエディタで開き, `HOOKS`の`fsck`を消して`btrfs`を追加し,

    # mkinitcpio -p linux

を忘れずにします.

その他いつもどおりに設定を済ませました.

### netctlでIPv6接続できるようにする

ConoHaのVPSはDHCPでネットワークの設定を全部勝手にやってくれるようです. 便利便利.

    # cd /etc/netctl
    # cp examples/ethernet-dhcp ./eth0
    # vim eth0
    # cat eth0
    Description='A basic dhcp ethernet connection'
    Interface=eth0
    Connection=ethernet
    IP=dhcp
    ## for DHCPv6
    IP6=dhcp
    ## for IPv6 autoconfiguration
    #IP6=stateless
    
    # netctl start eth0
    # netctl enable eth0

### 公開鍵認証によるSSH接続

鍵の作成と配置等の解説は省略. <del>長文記事面倒になってきた</del>

`/etc/ssh/sshd_config`をエディタで開き, 以下をアンコメント及び修正

    Port 114154
    Protocol 2
    PermitRootLogin no
    RSAAuthentication yes
    PubkeyAuthentication yes
    PasswordAuthentication no

### iptables

IPv4用とIPv6用のiptablesで分かれているらしいので, それぞれルールを作成して起動.

    # vim /etc/iptables/iptables.rules
    # vim /etc/iptables/ip6tables.rules
    # systemctl start iptables
    # systemctl start ip6tables
    # systemctl enable iptables
    # systemctl enable ip6tables

### nginx

IPv6アドレスからもページを開けるようにするには`listen`をこんな感じにするらしい.

    server {
      listen 80;
      listen [::]:80;
      ......
    }

### ウェイw

ConoHa良い.  
いずれブログ等をこの鯖に移行するほか, メール鯖とかも動かしてみたいと思っています.

試験稼働中のWebページ

* [http://157.7.235.201/](http://157.7.235.201/)
* [ipv6.myon.info](http://ipv6.myon.info/) (IPv6専用)

ではではー
