---
title: VAIOに入れたLinuxで静音モードやバッテリーケアを有効にする
date: 2014-01-15 00:48:27 JST
tags: VAIO Z2,Linux
---
どーもです

&nbsp;

VAIO ZにArch Linuxを入れて幸せなのですが、

<span class="fontsize6">「バッテリーがあまり保たない」</span>

んですよね。

（と言ってもVim+Chrome動かしている程度で2.5hは保ちますけど）

&nbsp;

何とかならないかなーと調べていると、

<a href="http://simon.schllng.de/2013/10/31/battery-care-limit-ubuntu-sony-vaio-pro/?lang=en">Set battery charging limit in Ubuntu on Sony VAIO Pro | simon.schllng.de</a>

という記事を見つけました。

ここに書いてあるのはバッテリーの充電量に制限をかける「バッテリーケア」の方法なのですが、

どうも/sys/devices/platform/sony-laptop/内のファイルがVAIO固有の設定するものらしく、弄っていると静音モードやバッテリーケアの有効化に成功したのでメモしておきます。

## 動作モードの変更

<img src="https://lh6.googleusercontent.com/-smQYlaCva2I/UtVUmz7NAmI/AAAAAAAAC68/Cpe3iXQnlh4/s640/Untitled.png" />

Windowsの付属ソフトに「VAIO Control Center」ってのがありますが、その中の設定項目である電源オプションの設定は

```
/sys/devices/platform/sony-laptop/thermal_control
```

のようです。

選択できる値がこんな感じに確認できるので、

```
$ cat /sys/devices/platform/sony-laptop/thermal_profiles
balanced silent performance
```

例えばsilentモードにしたいときはこうしてやります。

```
$ echo silent | sudo tee /sys/devices/platform/sony-laptop/thermal_control
```

## バッテリーケア(充電量の制限)

充電量の制限の設定ファイルは

```
/sys/devices/platform/sony-laptop/thermal_control
```

のようです。

Max80％にしたいというときはこうします。

```
$ echo 80 | sudo tee /sys/devices/platform/sony-laptop/battery_care_limiter
```

## タッチパッドの有効無効

これも同様にこんな感じにできます。

```
// 無効
$ echo 0 | sudo tee /sys/devices/platform/sony-laptop/touchpad 
0
// 有効
$ echo 1 | sudo tee /sys/devices/platform/sony-laptop/touchpad
1
```

## これらを起動時に有効にする

Arch Linuxの場合、これらの設定項目をShellScriptでまとめてSystemdのサービスとして実行させることで起動時に有効にすることができます。

僕は、

<a href="http://ssig33.com/text/VAIO%20Pro%20%E3%82%92%20Linux%20%E3%81%A7">ssig33.com - VAIO Pro を Linux で使う + バッテリー延命</a>

を参考にして、このようなファイルを起動時に設定しました。

<a href="https://gist.github.com/Tosainu/8419179">Tosainu / powersave</a>

powersaveを/usr/sbinに置き、

```
$ sudo chmod +x /usr/sbin/powersave
```

等で実行権限を与えてやります。

powersave.serviceは/etc/systemd/system/に置き、

```
$ sudo systemctl enable powersave.service
```

とすれば起動時に実行できるようになるはずです。

&nbsp;

他にもいろいろありましたが、全ては検証できませんでした。

いろいろ試してみるといいかもしれませんね。

&nbsp;

さて、これでバッテリーの保ちがどう変わってくるか.....気になりますねえ
