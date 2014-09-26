---
title: "2011Xperia(Android2.3.4)のroot権限の取得"
date: 2013-01-08 11:38:09 JST
tags: Xperia2011, XperiaArc
---
いろいろ弄るためにroot権限の取得をします.  
この方法は, root対策前Android2.3.4ファームウェアであればXperia2011のすべてで使えるはずです.

## まず

GomindowsPCの場合はデバッグモード用ドライバがインストールされていることを前提に話を進めます.

## Flashtoolを使ったroot化

Flashtoolを起動し, その状態でデバッグモードを有効にした端末をPCと接続します.  
ここで接続した端末の種類を選択するウィンドウが出ると思いますが, 接続した端末が一覧にない場合は適当なものを選択しておけば大丈夫です. (XperiaArcとか)

上部メニューの`Advanced -> Root -> Force zergRush`を実行すると...  
![flashtool](https://lh5.googleusercontent.com/-erk4RgZS1SM/UZdFbxrieZI/AAAAAAAACJA/dMDl96BkKs8/s640/flashtool.png)


何度か端末が再起動をした後root権限の取得はは完了します. お疲れ様でした。  
![rooted](https://lh6.googleusercontent.com/-AA3TAJaAGC8/UZc__JWurbI/AAAAAAAACIw/W9wj3qjXzJQ/s640/IMG_0518.JPG)
