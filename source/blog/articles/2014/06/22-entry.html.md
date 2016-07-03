---
title: ｳｨﾝﾄﾞｰｽﾞのurlmon.dllのエラー対処法をググるとヤバイ件
date: 2014-06-22 22:36:33 JST
tags:
---
どーも

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p>妹氏のPC, ｳｨﾝﾄﾞｰｽﾞｱｯﾌﾟﾃﾞｰﾄかけたらﾊﾞｶﾌｨｰｲﾝﾀｰﾈｯﾄｾｷｭﾘﾃｨが起動しなくなった, マジわけわかめ</p>&mdash; nuıɐsoʇ (@myon___) <a href="https://twitter.com/myon___/statuses/480590370846171136">June 22, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p>妹氏のPCでﾊﾞｶﾌｨｰが死んだというか, urlmon.dllが消滅したせいでIE異存のアプリケーションすべて死んだっぽい&#10;解決方法ググってるんだけど, 怪しいサイトからurlmon.dllをダウンロードして云々みたいな手順が出てくるしｳｨﾝﾄﾞｰｽﾞ怖すぎる</p>&mdash; nuıɐsoʇ (@myon___) <a href="https://twitter.com/myon___/statuses/480603000700813313">June 22, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

えーと, PCをまともに管理できる人が今家に僕くらいしかいないもんで, 妹らのゲーム用であるGomindowsPCの管理も僕がするわけです.  
更新するたびに不都合が出ることで有名のGomindowsですが, 今回も早速やらかしてくれえました.

更新後最初の起動で "urlmon.dllが見つかんねーぞハゲ" とﾃﾞｨｪｰｰｰﾝwwwwwwwのエラー音とともに表示され, ﾊﾞｶﾌｨｰｲﾝﾀｰﾈｯﾄｾｷｭﾘﾃｨが起動しないじゃありませんか.

ってことでググる. すると・・・

[緊急です。url.mondllが見つからない・・・。 IEエクスプローラや、フレッツウイ...](http://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q1320411148)

> 下記のページの中段あたりの  
> ダウンロード urlmon.dll  
> をクリックして、保存。

まぁヤホー知恵遅れなんで仕方ないですが, urlmon.dllと検索して出てくる日本語ページはコレくらいしか無いんで, ホイホイ釣れそうですね.  
他にも "DOWNLOAD urlmon.dll !!!" なんてリンクばっかりですから本当にアレです.

リンク先のファイルに悪意があるものかは知りませんが, ネットから拾ってきたシステムのバイナリファイルを突っ込んで対処なんて危険すぎるのでやめましょう.どうなっても知りません.  
結局, インストールされていたIEが古かったのもありIE8→IE11の更新を行ったところ解決しました. おそらく他の環境でもIE再インストール等で解決すると思います.

## 今回わかったこと(裏的な意味で)

IEが壊れただけでﾊﾞｶﾌｨｰは死ぬ
:   IEを破壊するプログラムでﾊﾞｶﾌｨｰのセキュリティ突破できる可能性が微レ存？ というかﾊﾞｶﾌｨｰクソすぎる

エラーメッセージで "hogehoge.dllが見つからないよ" と出すとユーザは "○◯.dll" 等で検索する
:   怪しいサイトの "DOWNLOAD ○◯.dll" なページに誘導できる

## 結論

*こんなOS早く捨てろ*
