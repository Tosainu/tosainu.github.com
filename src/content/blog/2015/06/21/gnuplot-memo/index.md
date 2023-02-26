---
title: Gnuplotおぼえがき
date: 2015-06-21 08:55:00+0900
tags:
  - Arch Linux
---

僕はそういう学校に通っていることもあって, 毎週指導書に従った実験を行ってはレポートに追われるという日々を過ごしています.  
そのレポートには結果をグラフにせよという場合があるわけですが, 今年の実験は測定値の増加や複雑な指示があるなどの理由から, 今までのように手書きでグラフを描くのが流石に辛くなってきました.

例えば...

> オシロスコープから直接出力したCSV形式のファイル(**データ数500件超**)をグラフにせよ

だとか,

> (上のオシロから出力したデータより) CH1 - CH2をグラフにせよ

みたいなもの. また,

> 測定値Aの関係をグラフにせよ  
> また, 測定値Bの関係を片対数グラフにせよ

といった, **いくつ用紙の種類用意すればいいんだよ!**などなど... (まぁ甘えといえば甘えですが)

グラフ作成といったら**Excel**のイメージが強いんですが, イケイケのクールな学生を目指して(???)Gnuplotを使ってみたところ最高だったので忘れないようにメモしておきます.

<!--more-->

## インストール

僕はArch Linuxを使っているので以下のコマンドで一発でした.  
最近のバージョンからQt化されたようで, 大量のQtってるパッケージが突っ込まれた気がします.

```
% yaourt -S gnuplot
```

他のLinuxディストリビューションでも大抵は公式のパッケージとして用意されているだろうし, MacではHomebrew等で入れられると思います.  
Windowsは頑張ってください.

## とりあえずなにか描いてみる

とりあえずターミナルからGnuplotを起動し, こんな感じに打ち込んでみます.

```
% gnuplot

	G N U P L O T
	Version 5.0 patchlevel 0    last modified 2015-01-01 

	Copyright (C) 1986-1993, 1998, 2004, 2007-2015
	Thomas Williams, Colin Kelley and many others

	gnuplot home:     http://www.gnuplot.info
	faq, bugs, etc:   type "help FAQ"
	immediate help:   type "help"  (plot window: hit 'h')

Terminal type set to 'qt'
gnuplot> set grid
gnuplot> plot 10 * sin(x) with line, \
10 * >cos(x) with point, \
>tan(x) with linespoints
```

![1](https://lh3.googleusercontent.com/-K8JOOgQ1Oos/VYYH7TkS9JI/AAAAAAAAE6o/KmOmWZjv9QU/s800/1.png)

グリッド線を表示させる場合は, プロットする前に`set grid`を実行します.  
また, `set grid xtics`や `set grid ytics`とすればx軸のみやy軸のみにグリッド線を表示させることができます.

グラフの描画は`plot データや関数`という文法で行えます.  
また, 複数のデータを描画する場合は`,`で区切るほか, 普段使っているシェルのように`\`で改行して入力できます.

ラインの種類は, `plot データや関数 with ふがふが`で変更できます. 指定できるラインの一例として,

| 種類 | 省略形 | めも |
| --- | --- | --- |
| line | l | 線 |
| point | p | 点 |
| linespoints | lp | 線 + 点 |

などがあります.

## Gnuplotスクリプト

Gnuplotをターミナルで実行した時に出てくるインタプリタは, お世辞にも使いやすいとは言えません.  
Tab補完は効きませんし, ヒストリがあるものの一度終了させると全部打ち直さないといけないのは辛すぎです.

というわけで, テキストファイルにGnuplotの命令を書いて実行するって感じのスタイルをとってみましょう. めっちゃ便利です.

```sh
#!/usr/bin/gnuplot

set terminal png size 800, 600  # データは800x600のpng形式で

set output '1.png'              # ./1.pngに保存

set grid                        # グリッド線を表示

plot 10 * sin(x) with line, \
10 * cos(x) with point, \
tan(x) with linespoints
```

ファイルへの出力も上のサンプル通りです.

ちなみに, Vimではオムニ補完が効くほか, QuickRunのようなプラグインでVimから実行できたり, エラーをquickfixに表示できたりもします. 最高.  
![2](https://lh3.googleusercontent.com/-nuaf5lC0Jlg/VYYSUSdq7LI/AAAAAAAAE64/cP_DVd02oL8/s800/2015-06-21-102251_3840x1080_scrot.png)

## CSV形式のファイルを扱う

最近のデジタルオシロは優秀で, USB端子からUSBフラッシュメモリ等に表示しているデータをCSV形式で出力できたりします.  
実際に[以下のRC回路の過渡現象を観測した時のデータ](https://drive.google.com/open?id=0B2w3TbN4IJZoUGhBc3kzdkRGZkU&authuser=0)がありますので, これで遊んでみましょう.  
![cu](https://lh3.googleusercontent.com/-XZB9bneydzc/VYYYnYiCM8I/AAAAAAAAE7I/gLL5BC4GtbQ/s800/schemeit-project.png)

### CSV形式のファイルを読み込む

まず, CSV形式のファイルが読み込めるようにデータの区切り文字を`,`に変更します.

```sh
set datafile separator ','
```

データをファイルから読み込みプロットするには, `plot`にファイル名を渡してやり, また`using x軸とする列:y軸とする列`というように指定します.  
ちなみに, 2つ目以降のファイル名は省略することができます.

```sh
plot '3_1_2.csv' using 1:2 with l, \
     '' using 1:3 with l
```

### 軸やラインにタイトルをつける

グラフのタイトルは`set title 'ほげ'`, 軸のタイトルは`set xlabel 'ふが'`, `set ylabel 'にゃん'`, ラインのタイトルは`title 'ふぇえ'`のように指定します.

最終的なスクリプトはこうなりました.

```sh
#!/usr/bin/gnuplot

set datafile separator ','
set terminal png size 800, 600

set title 'Figure 1. RC Transients'
set xlabel 't [sec]'
set ylabel 'V(t) [V]'

set output 'rc-tran.png'

plot '3_1_2.csv' using 1:2 with l title 'CH1', \
     '' using 1:3 with l title 'CH2'
```

![rc](https://lh3.googleusercontent.com/-VRxQy1Miecs/VYYfTeT0lWI/AAAAAAAAE7Y/3iwvo3IzEl8/s800/rc-tran2.png)

## その他個人的によく使う機能

### 軸の範囲と間隔の指定

先ほど描画したグラフ, 左右に隙間があって気になりますね.  
描画する範囲は

```sh
set xrange [-4.0e-04:2.0e-03]   # x軸の範囲
set yrange [-1:6]               # y軸の範囲
```

または, プロットするときに

```sh
plot [-4.0e-04:2.0e-03] [-1:6] '3_1_2.csv' using 1:2 with l title 'CH1', \
     '' using 1:3 with l title 'CH2'
```

と指定してやります.

また, 目盛りの間隔は,

```sh
set xtics 1e-3
```

のように指定します.

![rc2](https://lh3.googleusercontent.com/-lqqwCDvAT-c/VYYk0wU24pI/AAAAAAAAE7o/J0mjTOH8Ong/s800/rc-tran.png)

### CSV形式のデータに対して演算を行う

[以下のようなRCローパスフィルタ回路の実験をした時のデータ](https://drive.google.com/open?id=0B2w3TbN4IJZoUEloUHAwV2dZU1k&authuser=0)がありますので, 周波数特性のグラフを作成してみます.  
![lpf](https://lh3.googleusercontent.com/-PYR-ShF1YcM/VYYp3G-TPuI/AAAAAAAAE74/GW9YmO3WxQQ/s800/New-Project.png)

CSV形式のデータに対して演算を行うには, `using ほげ:ふが`の部分を弄ってやります.  
列の値は`$列番号`って感じで取得できますので, 電圧利得`|Gv| = 20 * log10(Vout / Vin) [dB]`は,

```sh
plot [] [:0] './lpf2.csv' using 1:(20 * log10($3 / $2)) with p title 'Gv'
```

となります.

```sh
set logscale x
```

でx軸を対数軸にして出力してやると...  
![lpf](https://lh3.googleusercontent.com/-ppC9QaRRNsE/VYYzRjTSKRI/AAAAAAAAE8E/9jjxHPDgTm0/s800/rc-lpf.png)

### グラフをなめらかにする

先ほどの周波数の特性のグラフを線で結びたいわけですが, この変化はカクカクではないので, 点と点を直線で結ぶわけにはいきません.

そこで, `smooth`を使います.

```sh
plot [] [:0] './lpf2.csv' using 1:(20 * log10($3 / $2)) smooth bezier with l title 'Gv'
```

`smooth`には以下のようなオプションがあるので, 目的やデータに合わせて変更すると良いと思います.  
(ここで紹介しているのは一部です)

| オプション | めも |
| --- | --- |
| unique | 線形補間を行う |
| cspline | スプライン曲線による補間を行う |
| bezier | ベジェ曲線による補間を行う |

そして, 最終的なスクリプトはこうなりました.

```sh
#!/usr/bin/gnuplot

set datafile separator ','
set terminal png size 800, 600

set title 'Figure 2. RC-LPF'
set xlabel 'f [Hz]'
set ylabel 'Gv [dB]'

set logscale x

set output 'rc-lpf2.png'

plot [] [:0] './lpf2.csv' using 1:(20*log10($3 / $2)) smooth bezier with l title 'Gv'
```

![lpf2](https://lh3.googleusercontent.com/-7Q8ZQ0wppOY/VYY4K3Pa5wI/AAAAAAAAE8U/GEZ1pKQQuI4/s800/rc-lpf2.png)

## おわり

Gnuplotにはまだたくさんの機能がありますが, 今日もレポートが忙しいのでこれくらいで.  
すごく電気科電気科してる記事になった気がします.

ではではー.
