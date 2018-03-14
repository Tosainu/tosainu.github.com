---
title: 'Android 4.4 KitKat on Xperia Ray'
date: 2014-07-05 21:44:07+0900
tags: Xperia2011,Android
---
前回の記事

* [Ubuntu Touch on XPERIA Ray](http://tosainu.wktk.so/view/295)
* [Android 4.4 KitKat on Xperia Ray](http://tosainu.wktk.so/view/333)

どーも.  
木曜の授業中に背中の痛みと息苦しさを訴え病院に行ったところ "軽い気胸" と診断されたとさいぬです.  
現在は激しい痛みもなくなりましたが, 気胸特有の違和感は消えませんねぇ....

さてさて, 早い段階からXperia2011にKitKatの移植に成功していた[LegacyXperia Project](http://legacyxperia.github.io/)グループですが, 気づかないうちにどんどん更新されているのに気づきまして, 昨年12月末のレビューに続き, 今回もXperia RayにKitKatを焼いてみました.

## Info

もう世の中はSony Xperiaというニセエクスペリアばっかりですので, ここで改めてXperia 2011の紹介を軽くしたいと思います.

実験端末
:   Sony Ericsson Xperia Ray

**Spec**

* Qualcomm Snapdragon MSM8255 1GHz Single
* 512MB RAM
* 3.3 inches 480 x 854 pixels Display
* 100[g]
* 3G/2g通信
* 海外で公式ICSファームウェアが公開されるも日本ではGB止まり
* CyanogenMod公式はCM10-nightlyが公開されるもサポート中止

今回は6/20に公開されたファームウェアを使いましたが, 7/3にまた新しくファームウェアが更新されています.

## Video

<div class="video-container"><iframe width="560" height="315" src="https://www.youtube.com/embed/OK8Kvb9O10U?rel=0" frameborder="0" allowfullscreen></iframe></div>

READMORE

## Impressions

前回のファームウェアでは確認できませんでしたが, 今回はARTモードを使って起動することに成功しました.  
開発者設定から "Use ART" を選択し再起動, 2,30分掛かりますw.

ARTモードでは非常に快適に動作し, CPUは1.4GHzにオーバークロックしているもののベンチマークでは1.6GHz以上に相当するほどのスコアを出すことが出来ました. CPUのスコアは1500程度も向上しているので驚きです.

![dalvik](https://lh5.googleusercontent.com/-U-jK-6jrSw4/U7fr8excTHI/AAAAAAAADYQ/HlEWnPXXPUg/s800/Screenshot_2014-06-30-21-14-51.png "dalvik")  
![art](https://lh6.googleusercontent.com/-mTQVqCVBEO4/U7fr8qPsuqI/AAAAAAAADYU/yVXi0MXThWs/s800/Screenshot_2014-06-30-21-37-08.png "art")

しかしながらARTモードで動作させるのにも欠点がありまして.  
まず, Androidは内部でapkファイルをインストールすると端末に最適化されたdexファイルを生成します. これがdalvik-cacheと呼ばれるわけです.  
ARTで起動させた場合, この中間ファイルがdalvikと比べ少々容量が大きくなるようで, ただでさえ少ない内蔵ストレージを圧迫します.  
画像のようにTwitterクライアントと日本語IMEを入れることしかできないような状態です. もちろん, システムアプリのアップデートなどできる訳ありません.  
![In](https://lh5.googleusercontent.com/-Ls1WEFi1tL8/U7fuoK6x7hI/AAAAAAAADYg/5yRvWksJLE0/s800/Screenshot_2014-07-04-10-17-00.png "In")

さらに, 以前のバージョンであればS2E等のアプリによりSDカード上に作成したext4パーティションにデータを移す等のことも出来ましたが, KitKatでは未対応らしくそれらの手段も難しいと思われます. (すべて確認したわけではないが)  
僕は今のところ大きな不満もなく使っていますが, アプリをガンガン入れたい方にはARTは厳しいかもしれません.

その他の面に関しては高評価で, 特に前回のレビューの時に確認されたブラウザの動作が非常に思いなどのバグも解消され, また3G通信, 通話なども問題なくでき, 十分実用レベルに達しているということに驚くばかりです. LegacyXperiaさんヤベェわマジで.

僕も同じXperia2011ファンとしてこっちの方に仲間入りしたいと思うばかりです. 技量をつけなければ.

ではでは〜
