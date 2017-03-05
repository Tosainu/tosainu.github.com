---
title: RPi(Arch Linux)でmjpg_streamerのビルドにつまづいた
date: 2013-10-31 20:12:29 JST
tags: Arch Linux, Raspberry Pi
---
どもどもー

&nbsp;

例のラジコンの件です。

ソフトウェアはほぼ完成しているのに、回路ができていないという非常に謎い状態ですw

文化祭は明後日、今日中にでも完成させなくては・・・

&nbsp;

今回のラジコンにはカメラも搭載し、コントロールページから確認できるようにしようと思っています。

ここ数日、できるだけ負荷の少なくかつ遅延のすくないストリーミング配信方法を探っていたところ、mjpg_streamerが負荷も少なく遅延も数秒程度で優秀ということがわかりました。

<span class="fontsize1">（ちなみにffmpeg+ffserverでは5秒以上の遅延が発生、さらにx264を使い出すと驚きの重さでしたので常用は不可と判断しました。）</span>

<img src="https://lh6.googleusercontent.com/-aYVsWTDc084/UnI4sFLXKqI/AAAAAAAACrc/uqHlrYcMCRo/s640/IMG_1235.JPG" />

しかしこのmjpg_streamer、インストールに躓いたのでメモです。

&nbsp;

mjpg_streamerはAURにあったので、RaspberryPiにABSを入れて、makepkgでパッケージ生成をすることにしましたが・・・

なんと、ソース内でインクルードされているファイルのファイル名が変わっているため、パッケージは生成されるものの、一部ライブラリがコンパイルできていませんでした。

仕方ないので、一部コードを書き換えることで対処しました。

&nbsp;

```
// 関係ありそうなパッケージのインストール
$ sudo pacman -S base-devel abs file

// AURからmjpg_streamerのtarballを持ってくる
$ wget https://aur.archlinux.org/packages/mj/mjpg-streamer/mjpg-streamer.tar.gz
$ tar zxvf mjpg-streamer.tar.gz
$ cd mjpg-streamer

// ソースをダウンロード、解凍
$ wget http://downloads.sourceforge.net/project/mjpg-streamer/mjpg-streamer/Sourcecode/mjpg-streamer-r63.tar.gz
$ tar zxvf mjpg-streamer-r63.tar.gz
$ cd mjpg-streamer-r63

// ソースコード内のlinux/videodev.hをlinux/videodev2.hに書き換える
$ grep -rl "linux/videodev.h" . | xargs sed -i 's|'linux/videodev.h'|'linux/videodev2.h'|g'

// A:アーキテクチャを無視、c:パッケージ生成後クリーン、s:依存パッケージのインストールオプションを指定してmakepkg
$ cd ../
$ makepkg -Acs

// 生成されたパッケージをインストール
$ sudo pacman -U mjpg-streamer-r63-4-armv6h.pkg.tar.xz
```

これでmjpg-streamerがちゃんとインストールできました。

&nbsp;

実際に使ってみます。/dev/video0に接続したカメラの映像を、320x184で8080番ポートから配信する例です。

```
mjpg_streamer -i "input_uvc.so -d /dev/video0 -r 320x184 -f 2 -y" -o "output_http.so -w /usr/share/mjpeg-streamer/www -p 8080"
```

マシンの8080ポートにブラウザからアクセスすると、こんな感じに見ることができます。

<img src="https://lh3.googleusercontent.com/-En1A7SAN2kg/UnI48-656hI/AAAAAAAACrk/GeVxj6A628s/s640/2013-10-31-195706_1920x1080_scrot.png" />

また、このように記述してhtmlにimgタグを使って埋め込むこともできました。

```html
<img src="http://MachineIP:Port/?action=stream" />
```

さて、あとは急いで回路を作って組み立てなければ・・・

ではでは〜
