---
title: USB3.0ポートでUSB3.0フラッシュメモリが使えなくなった
date: 2014-09-20 01:15 JST
tags: Linux, Arch Linux
---

どもども, テスト真っ只中のとさいぬです.  
今回のテストで一番つらいと思っている最初の2日を無事終え, 大分気が楽になった感じです.  
(まだあと8教科残ってますが....)

さて, 僕は普段, USB3.0対応のUSBフラッシュメモリである**SanDisk Extreme USB 3.0 Flash Drive**を使っているのですが, 近頃Vaio Zに入れたArch LinuxでこれをUSB3.0ポートに挿すと認識してくれなくなってしまったんです(USB2.0のポートだと動く).

いろいろ調べたら簡単に解決したのでメモ.

## かんきょう

* Vaio Z (VPCZ23AJ)
* Arch Linux x86\_64
* linux 3.17.0-rc5 (症状自体はlinux-3.15あたりから)

## かくにん

物理的に壊れているわけではないので, 何かしらは反応しているはずです.  
そこで, USB3.0ポートにUSBフラッシュメモリを接続した後, `dmesg` コマンドでカーネルが吐くメッセージを確認してみます.

```
$ dmesg
- 略 -
[13089.757750] usb 1-2: new full-speed USB device number 7 using xhci_hcd
[13089.869144] usb 1-2: device descriptor read/64, error -71
[13089.970031] xhci_hcd 0000:04:00.0: Setup ERROR: setup context command for slot 1.
[13089.970043] usb 1-2: hub failed to enable device, error -22
[13090.124246] usb 1-2: new full-speed USB device number 8 using xhci_hcd
[13090.235485] usb 1-2: device descriptor read/64, error -71
[13090.336506] xhci_hcd 0000:04:00.0: Setup ERROR: setup context command for slot 1.
[13090.336526] usb 1-2: hub failed to enable device, error -22
[13090.490610] usb 1-2: new full-speed USB device number 9 using xhci_hcd
[13090.490999] usb 1-2: Device not responding to setup address.
[13090.692152] usb 1-2: Device not responding to setup address.
[13090.893087] usb 1-2: device not accepting address 9, error -71
[13091.046211] usb 1-2: new full-speed USB device number 10 using xhci_hcd
[13091.046585] usb 1-2: Device not responding to setup address.
[13091.247865] usb 1-2: Device not responding to setup address.
[13091.448729] usb 1-2: device not accepting address 10, error -71
[13091.448880] usb usb1-port2: unable to enumerate USB device
```

やっぱり何かエラー出ていましたね.

全く関係ないのですが, dmesgコマンドの出力に色がつくようになったんですね.  
ずいぶん見やすくなりました.

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p>見やすいかも <a href="http://t.co/YpooKi08fG">pic.twitter.com/YpooKi08fG</a></p>&mdash; 期末テスト (@myon\_\_\_) <a href="https://twitter.com/myon___/status/512903387856134144">September 19, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## なおす

`device descriptor read/64, error -71` でググってみたところ, この辺の情報がHitしました.

[usb 1-4: device descriptor read/64, error -71 | Guy Rutenberg](http://www.guyrutenberg.com/2008/06/26/usb-1-4-device-descriptor-read64-error-71/)

どうやら `old_scheme_first` を有効にしてやればいいようです.  
え゛っ.... oldって....... ちょっとショック(´・ω・｀)

```
// rootで
# echo Y > /sys/module/usbcore/parameters/old_scheme_first

// やっぱsudo使いたいよね
$ sudo sh -c 'echo Y > /sys/module/usbcore/parameters/old_scheme_first'

// これでもよさそう
$ echo Y | sudo tee /sys/module/usbcore/parameters/old_scheme_first
```

## うごいた

```
$ dmesg
- 略 -
[14028.974874] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
[14028.990757] usb-storage 2-2:1.0: USB Mass Storage device detected
[14028.991517] scsi host7: usb-storage 2-2:1.0
[14029.995418] scsi 7:0:0:0: Direct-Access     SanDisk  Extreme          0001 PQ: 0 ANSI: 6
[14029.996769] sd 7:0:0:0: [sdc] 31277232 512-byte logical blocks: (16.0 GB/14.9 GiB)
[14029.997587] sd 7:0:0:0: [sdc] Write Protect is off
[14029.997601] sd 7:0:0:0: [sdc] Mode Sense: 53 00 00 08
[14029.998310] sd 7:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[14030.003468]  sdc: sdc1
[14030.005791] sd 7:0:0:0: [sdc] Attached SCSI removable disk

$ lsusb | grep SanDisk
Bus 002 Device 002: ID 0781:5580 SanDisk Corp. SDCZ80 Flash Drive
```

注: sysctlの設定とかいじらない限り再起動すると元に戻ってしまうので, 接続するたびにコマンド打たないといけないです

ではではー.
