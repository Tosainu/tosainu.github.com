---
title: VAIO ZのOSをすべて再インストールした(Windows7編)
date: 2014-03-18 20:13:00+0900
tags: VAIO Z2
---
どーもです

あまりにも暇だったんで、これでもう3年目になるVAIO ZたんのOS再インストールをすることにしました。

&nbsp;

## 環境等
僕の使うVAIO ZはVPCZ23AJ、Webからのオーナーメイドモデルです。

標準状態のRAIDを解除し、Arch Linux/Windows7hp/WindowsXPproのトリプルブート状態で使っていました。

今回は再びRAID0を組み、Arch LinuxとWindows7hpのデュアルブートさせることにします。

またWindows7は、リカバリディスクからインストールした場合、Photoshop体験版だとかでとんでもなく重くなるほか、デュアルブートを組むにあたってインストール時のパーティションを細かく組みたいなどの理由からクリーンインストールを行うことにしました。

<!--more-->

&nbsp;

## 準備
### Arch Linux
/home下の必要なファイルや、grub等の設定をUSBフラッシュメモリにコピーしました。

### Windows7
Sonyの壁紙等

    C:\Windows\Web\Wallpaper\Sony
    C:\Windows\System32\oobe\info
    C:\Windows\System32\system_control_panel.bmp

そして以下のレジストリをエクスポートしておきます。

    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation

また、OEMライセンスの引き継ぎのため、

    C:\Windows\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareProtectionPlatform\tokens.dat

そして、[Keyfinder](http://www.magicaljellybean.com/keyfinder/ "Keyfinder")を使い、CD Keyの部分を控えておきます。

[ちょいマニアックなWindowsの教科書](http://windowstips.web.fc2.com/VISTA7.html "ちょいマニアックなWindowsの教科書")を参考にさせていただきました。

### SSDのゼロフィル
何となく気分的に。

Arch Linuxのインストールディスクから起動させ、

    # dd if=/dev/zero of=/dev/sda
    # dd if=/dev/zero of=/dev/sdb

とコマンドを叩きました。

### RAID0を組む
BIOSに入り(VAIOロゴでF2)、Advanced > RAID ConfigurationをShowにして再起動します。

するとVAIOロゴが表示された後にRAID設定が表示されるので、Ctrl+I(アイ)で設定画面に入ります。

RAIDを組めたらExitし、そのままWindowsインストールに進みます。

尚、RAIDを組んだ後はBIOSのRAID ConfigurationをHideにして問題無いです。

&nbsp;

## Windows7のインストール
インストールディスクから起動し、今すぐインストールと進みます。

ここで、Shift+F10を押しコマンドプロンプトを開き、

    X:\Sources> diskpart
    DISKPART> select disk 0
    DISKPART> create partition primary size 81150
    DISKPART> exit
    X:\Sources>

とコマンドを打ち、パーティションを作成します。今回は約80GBをWindows7用として確保することにしました。

インストール先を選択する際、先ほど作成したパーティションを選択し進みます。

こうすることで、予約領域を作成せずWindows7をインストールすることができます。

&nbsp;

何度か再起動をしWindowsのインストールは終了します。

初期設定画面ではユーザ名等は適当に入力し、プロダクトキー入力の画面で"オンラインになったとき、自動的に windowsの認証の手続きを行う"のチェックを外し、空欄のまま次へ進みます(OEMライセンスを適用するため)。

&nbsp;

## ライセンス認証
先ほどバックアップを取ったtokens.datをバイナリエディタ(今回はWindowsの[Stirling](http://www.vector.co.jp/soft/win95/util/se079072.html "Stirling"))で開きます。

`OEM Certificate`で文字列を検索し、その真上の`<?xml version="1.0" encoding="utf-8" ?>`から`</r:license>`を選択し、右クリック > 選択範囲をファイルに保存として出力します。

<img src="https://lh4.googleusercontent.com/-EKT9kqFqvgk/UygdXiyN9bI/AAAAAAAADGk/qiSiwlX-Qsk/s640/SnapCrab_NoName_2014-3-18_19-16-41_No-00.png" />

ファイル名は先程のサイトと同様に`hoge.xrm-ms`とし、`C:\`に保存しました。

&nbsp;

コマンドプロンプトを管理者権限で開き、

    C:\Windows\System32> slmgr.vbs -ilc c:\hoge.xrm-ms
    C:\Windows\System32> slmgr.vbs -ipk 先ほど控えたCD Key

すると、ライセンス認証が通ったと思います。

&nbsp;

## ドライバのインストール
まずドライバを[ここ](http://www.sony-mea.com/support/product/vpcz227gg "Support for VPCZ227GG : Z Series (VPCZ) : VAIO™ Notebook & Computer : Sony Middle East & Africa")からダウンロードします。

今回は

* Chipset Driver
* Audio Driver
* ME Driver
* Ethernet Driver
* Memory Card Reader Driver
* Wireless LAN Driver
* Pointing Driver
* SFEP Driver
* USB 3.0 Driver
* Intel Bluetooth High Speed Driver

を海外Sonyのサイトからダウンロードし、

* [Intel® HD Graphics Driver](https://downloadcenter.intel.com/Detail_Desc.aspx?lang=eng&amp;changeLang=true&DwnldId=23377 "Intel® HD Graphics Driver")
* [Intel® Rapid Storage Technology (Intel® RST) RAID Driver](https://downloadcenter.intel.com/Detail_Desc.aspx?lang=eng&amp;changeLang=true&DwnldId=23496 "Intel® Rapid Storage Technology (Intel® RST) RAID Driver")

についてはそれぞれインテルのサイトから最新版をダウンロードしました。

Sonyサイトで配布されているドライバはそのまま実行しても良いですが、アーカイバで解凍してやると幸せになれると思います。

他、適宜最新版ドライバを入れてやると良いと思います。

&nbsp;

## Sony製ソフトウェアのインストール
[VAIO Z (VPCZ21) をクリーンインストール：とあるソニー好きなエンジニアの日記：So-netブログ](http://taiseiko.blog.so-net.ne.jp/2011-08-15 "VAIO Z (VPCZ21) をクリーンインストール：とあるソニー好きなエンジニアの日記：So-netブログ")を参考にさせて頂きました。

[mod2win](https://rapidshare.com/download/842p1/180131992/bW9kMndpbS56aXA=/14219/0/0/0/4D70671DFAE4550EDD79FD89CC1CEC9B/referer-16F53E1F3CCCEAA6D40D2646496E1ACB "mod2win")をダウンロードし、1枚目のリカバリディスクからいろいろ吸い出します。

そして[7-Zip](http://www.7-zip.org/ "7-Zip")を使い、以下の順で解凍・インストールします。

1. MODC-178764.no_47 Sony Shared Library
2. MODC-182537.no_95 VAIO Control Center
3. MODC-182533.no_84 VAIO Boot Manager
4. MODC-182536.no_80 VAIO Power Management
5. MODJ-168314.no_82 VAIO Peripherals Metadata
6. MODC-182452.no_77 VAIO Hardware Diagnostics
7. MODC-182535.no_79 ISB Utility

VAIOの型によってフォルダ名は異なってくるようですが、VPCZ23AJでは上記のようでした。

万が一見つからない場合、コンテンツ検索(ファイルの中の文字列を検索)させると出てくると思います。

面倒ですが毎回再起動かけたほうがいいかもしれません。

これで画面輝度調整やコントロールパネルが使えるようになります。

&nbsp;

最初コピーしたSony壁紙やレジストリを復元してやると、リカバリした時とほとんど元通りです。

Windows Updateも一気に済ませて完了です。

&nbsp;

次回はArch Linuxのインストール、そしてWindowsとのデュアルブート設定をしていこうと思います。

ではではー

注:WindowsのOEMライセンス引き継ぎはかなりグレーだと思われるので自己責任で、また悪用は厳禁です。
