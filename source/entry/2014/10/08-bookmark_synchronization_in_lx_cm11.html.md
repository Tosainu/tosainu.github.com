---
title: LegacyXperia-CM11の標準ブラウザでブックマークの同期をする
date: 2014-10-08 23:12 JST
tags: Xperia2011, Android
---

どもども.

Xperia2011使いにはお馴染みの[LegacyXperia Project](http://legacyxperia.github.io/).  
つい先日もXperia2011向けCyanogenMod11の最新ビルドを公開したりと, 非常に活発ですごいです.

さて, 僕も愛用しているLegacyXperia-CM11ですが, 標準ブラウザでChromeのブックマークを同期することができません. (というかAndroid4.4自体から消された? 要検証)  
おそらくGoogleさんはブックマークの同期をしたいならAndroid版Chromeを使ってねということなんでしょうが, 僕達Xperia2011ユーザにはAndroid版Chromeはいろいろと厳しい物があります.  
![install faild](https://lh4.googleusercontent.com/-z4KW8NmtgjI/VDVGEcEp6oI/AAAAAAAADkM/_S9QmnPODxw/s640/Screenshot_2014-10-08-22-37-31.png)

ということで, CM11でも標準ブラウザでブックマークの同期をする方法を紹介したいと思います.

## 手順

Android4.4で消えたのなら, つまりそれ以前のバージョンから持ってくればいいだけです.  
まず, [ここ](https://s.basketbuild.com/gapps)からCM10.2(Android4.3)用のgappsをダウンロードしてきます.

次に, ダウンロードしたzipを解凍し, `/system/app/ChromeBookmarksSyncAdapter.apk` を取り出します.

端末に先ほど取り出した `ChromeBookmarksSyncAdapter.apk` を転送し, `/system/app/` にコピーします.  
パーミッションの設定を644にするのも忘れずに.

adbコマンドを使うならこんな感じ.

```
// とりあえずapkをSDカードに転送
$ adb push ChromeBookmarksSyncAdapter.apk /sdcard/

// 端末に入ってrootになる
// Superuserの設定でADBからもrootアクセスできるように設定を変えておくのを忘れずに
$ adb shell
(ADB)$ su -
(ADB)#

// /systemを書き込み可でリマウント
(ADB)# mount -o remount,rw /system

// コピる
(ADB)# cp /sdcard/ChromeBookmarksSyncAdapter.apk /system/app/
(ADB)# chmod 644 /system/app/ChromeBookmarksSyncAdapter.apk 

// 戻す
(ADB)# mount -o remount,ro /system

// 再起動
(ADB)# reboot
```

再起動後, 同期設定のところにBrowserという項目が出現しているのでチェックを入れるとブックマークが同期されます.  
![sync](https://lh6.googleusercontent.com/-lXdicTyc14o/VDVEPguSNXI/AAAAAAAADj8/x2fNLHiWcUA/s640/Screenshot_2014-10-08-22-49-55.png)

![browser](https://lh3.googleusercontent.com/-L0mVjVb9rJA/VDVEPuDXFII/AAAAAAAADj4/c7zBjuklDII/s640/Screenshot_2014-10-08-22-50-18.png)

わーいヾ(o´∀｀o)ﾉ  
ではでは〜
