---
title: uim-mozcのvi-cooperative modeが神ってる
date: 2014-04-14 19:56:08+0900
tags: Linux, Arch Linux, Vim
---
どーもです。

先週木曜から40度近い発熱をし、医者の診察を受けたところインフルエンザ(B)でした。  
今朝やっと熱が下がりましたが、学校に通うには「解熱後2日後」というルールがあるので早くても水曜からですかねぇ。  
初回の授業は今後の理解に大きく関わってくるので、あまり欠席したくはなかったのですが...............

さてまぁ、タイトル通りのこと。

Vimで邪悪な日本語を入力しているとします。  
![insert](https://lh6.googleusercontent.com/-ysBPVyqGOOU/U0u3v09j0TI/AAAAAAAADKo/V_rmuuMacj4/s800/inout.png "insert")

そのままESC等でnomal modeに移り、:w等のコマンドを実行しようとして・・・  
![nomal](https://lh5.googleusercontent.com/-_9FMOYY9hXk/U0u3vxSG1II/AAAAAAAADKw/7sQ1W4bTWtg/s800/nomal.png "nomal")  
こうしちゃうことありますよね。

あまりに不便なのでなにかないかと探したところ、uim-mozcにvi-cooperative modeというものがあるのを発見しました。

uimの設定(mozc設定ダイアログではない)を開き、左側のグループから`Mozc`を選択します。  
その中の設定項目に`Enable vi-cooperative mode`というのがあるのでチェックを入れてみましょう。  
![mozc](https://lh5.googleusercontent.com/-yBXRapBdeZQ/U0u9Ogo7azI/AAAAAAAADLI/FOrRRLqsSBg/s640/2014-04-14-191530_1920x1080_scrot.png "mozc")

すると、Vimでinsert modeからnomal modeに移るとき、自動的に日本語入力がOFFになります！  
便利ですね。

ではでは〜
