---
title: 進行状況的な
date: 2013-10-20 20:50:34 JST
tags: Raspberry Pi
---
どーもです

RaspberryPiで遠隔ラジコン計画がかなり進んだので報告しようかと。

&nbsp;

まず、モーター制御には重要なPWM制御です。

これには、[wiringPi](http://wiringpi.com/ "wiringPi")に付属するgpioコマンドを使いました。

なお、PWMが使えるのはGPIO18pinのみです。（ソフトウェアでの制御を組めば他のpinでもPWM制御をすることができます）

```
// GPIO18をPWMpinとして設定
$ gpio -g mode 18 pwm

// range(0〜1024)でPWM出力
$ gpio -g pwm 18 range
```

&nbsp;

これを使って、ShellScriptでLEDの輝度制御をしてみました。

ディレイは入れてません。

```
#!/bin/zsh

gpio -g mode 18 pwm
i=0
while :
do
	while [ $i -lt 1024 ]
	do
		i=`expr $i + 10`
		gpio -g pwm 18 $i
	done
	while [ $i -gt 1 ]
	do
		i=`expr $i - 10`
		gpio -g pwm 18 $i
	done
done
```

<iframe width="560" height="315" src="https://www.youtube.com/embed/6d-ysRDLh0c?rel=0" frameborder="0" allowfullscreen></iframe>

&nbsp;

このgpioコマンドをNoe.jsから動かしてみます。

このサイトを参考にさせてもらいました。

[Raspberry Piに接続したフルカラーLEDをNode.jsから制御する - 人と技術のマッシュアップ](http://tomowatanabe.hatenablog.com/entry/2013/01/21/221722 "Raspberry Piに接続したフルカラーLEDをNode.jsから制御する - 人と技術のマッシュアップ")

<iframe width="560" height="315" src="https://www.youtube.com/embed/qi4fIWwi0es?rel=0" frameborder="0" allowfullscreen></iframe>

&nbsp;

また、TA7291Pを使い、DCモーターの制御もしてみました。

プログラム及び回路はまだ試作段階なので、後日うpということで。

<iframe width="560" height="315" src="https://www.youtube.com/embed/zzh_jgLDq3w?rel=0" frameborder="0" allowfullscreen></iframe>

&nbsp;

ではでは〜
