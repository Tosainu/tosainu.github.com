---
title: カスタムROMを書き込んでみる
date: 2013-06-29 15:45:12+0900
tags: Xperia2011, Xperia arc
---

## もう躊躇いなんていらない

カスタムカーネルも焼けるようになったことですし, カスタムROMも焼いちゃいましょう!  
実際にXperiaArcにCyanogenMod7.2を焼きながら解説したいと思います.

## カスタムROMの選び方

カスタムカーネルと同様に, カスタムROMにもその端末で使えるものを選ばなければなりません.

* どの端末向けか
* どんな仕様のROMか
* カーネルは何を使わなければいけないか
* 別途用意するもの(gapps等)はあるか

に注意しましょう.

### ROMの種類と焼き方

カスタムROMには大きく分けて2つあります.

* 公式ベースのもの
* それ以外のもの

公式ベースのものは, 多くの場合それらのベースになったファーム向けのカスタムカーネルが流用できます.  
ベースになったファームウェアを一度端末に書き込み, CWMリカバリの使えるカスタムカーネルを焼く, その後ROMを焼くという流れになります.

一方, 公式ベースでないものは, 公式ベース向けのカスタムカーネルは基本的に使えません.  
そしてその仕様に合わせて焼き方が異なってきます.

ROMの解説をよく読むようにしましょう.

### カスタムROM選びのコツ

執筆中.......

## OfficialCyanogenmod 7.2を焼いてみる

今回は公式ベースでないカスタムROMで有名な**CyanogenMod7.2**を焼いてみましょう.

### カスタムROMとその他必要なものをダウンロードする

今回焼くCyanogenMod系のカスタムROMは, 公式サイトやXDAで配布されているROM本体と, Playストアを始めとするGoogle系アプリの入ったgappsを用意します.

今回は[CyanogenMod Downloads](http://download.cyanogenmod.com/?device=anzu&type=stable)からcm-7.2.0-anzu.zipを,  
ここから[gapps-gb-20110828-signed.zip](https://basketbuild.com/gapps)をダウンロードしました.

これらを端末のSDカードに, またcm-7.2.0-anzu.zipを解凍すると出てくるboot.imgは付属のカーネルになります.  
コピーしてPC上に保存しておきます.

### アプリのバックアップ

主にゲーム等, 設定後と移行させる必要があるアプリのバックアップを行います.  
[TitaniumBackup](https://play.google.com/store/apps/details?id=com.keramidas.TitaniumBackup)使用すると便利でしょう.  
![titanium](https://lh6.googleusercontent.com/-27-ErcCevCs/UjMpo6-flrI/AAAAAAAACjY/QqXMjmlp8ZI/s640/device-2013-09-14-000422.png)

### ROMのバックアップ

CWMリカバリ等を使いROMごとバックアップを取ります.  
カスタムROM導入に失敗した場合や気に入らなかった場合にすぐ戻せるようにするためです.  
![bkup](https://lh3.googleusercontent.com/-lZm7hroXGfE/UjMqehvBRTI/AAAAAAAACjk/_xawE2n_9nw/s640/IMG_0995.JPG)

### SIMを抜く (不正通信を防止するため)

これは重要です.

大抵のカスタムROMは初期状態でデータ通信が有効になっていますが, APN設定が不完全な場合があります.  
下手すると請求額青天井になりかねませんので取り外します.

### ROMを焼く

いよいよです. 一気にやっちゃいましょう!!

まず, BBバージョンの都合で起動しない場合があるので一度公式ファームを焼きます.  
GBカスタムROMなら公式GBファーム, ICS以降のカスタムROMなら公式ICSファーム焼いてください. (ROMによっては予め焼くファームを指定されている場合もあります)

特にICS以降のカスタムROMでこのようなことが起きやすいので注意します.

次に用意したカスタムカーネルを焼きます. 手順は前回のページを参考に.  
![kernel](https://lh5.googleusercontent.com/-QO3rCaPuPE0/UjMwy8AyDbI/AAAAAAAACj0/EIjKMXR95nA/s640/IMG_0997.JPG)

カーネルを焼いたら, そのままCWMリカバリに入ります.  
そうしたら

1. factory reset
2. wipe cash
3. wipe dalvik-cache
4. Wipe Battery Stats
5. format /system

を実行します. (カスタムリカバリに項目がない場合はとばす)  
![clean](https://lh5.googleusercontent.com/-W5UF5bGZxb8/UjMw19HaUhI/AAAAAAAACj8/wfRS8jhzDD8/s640/IMG_0998.JPG)

次にダウンロードしたZIPを焼く作業に移ります.  
今回のような場合は

1. ROMメインファイル(cm-7.2.0-anzu.zip)
2. gapps(gapps-gb-20110828-signed.zip)

の順番で焼きます.  
![flash](https://lh6.googleusercontent.com/-FHMx9SSpz9Q/UjMxJgQQdMI/AAAAAAAACkU/iCmC3YnVVeI/s640/IMG_1000.JPG)

焼き終わったら再起動です.

初回起動は時間のかかる場合がありますが, 待ちましょう.  
(さすがに10分以上かかっても起動しない場合は失敗している可能性があります)  
![boot](https://lh6.googleusercontent.com/-O2s0A4CafHg/UjMxEwlnOVI/AAAAAAAACkM/DMmek-d-b_s/s640/IMG_1001.JPG)

### 焼き上がり✌('ω'✌ )三✌('ω')✌三( ✌'ω')✌

![home](https://lh3.googleusercontent.com/-y_QnQXHl_Ic/UjMxN6BMrTI/AAAAAAAACkc/EFeDqPyFYm8/s640/IMG_1002.JPG)

![sysinfo](https://lh4.googleusercontent.com/-BNrf7PCGyTk/UjMzSi0imNI/AAAAAAAACkw/rL7gXEH-PDU/s640/screenshot-1379086754663.png)

あとは思いっきりカスタマイズしちゃってくださいw  
↓ネタで草書体フォントを設定した例  
![sousho](https://lh6.googleusercontent.com/-WEb9a84Ve-Y/UjMyuMUSLfI/AAAAAAAACko/Ef4bihwBvMk/s640/screenshot-1347605209424.png)

