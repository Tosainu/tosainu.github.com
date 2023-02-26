---
title: 夏休みが終わる
date: 2014-08-26 18:35:00+0900
noindex: true
tags:
  - Website
---

みょん.

気づけばもうこんな時期ですね.  
僕の学校は夏休みが終わるとテスト2週間前という<del>クソな</del>素晴らしい予定表を作ってるので, とっとと課題片付けてテストの勉強しないとなぁって感じです.  
まぁ例年のように課題の進捗が壊滅的ってわけではないんですが, この先すぐにテストがあると思うと(ヽ´ω`)ﾊｧ…って感じです.

さて, 気づいた方も多いと思いますがこのブログのURL及び使っているツールが変わりました.  
今までは[wktk server](http://www.wktk.so/)さんで[freo](http://freo.jp/)を使っていましたが, 現在は[ConoHa](http://www.conoha.jp/)に建てたWeb鯖に[Middleman](http://middlemanapp.com/)で生成したページを置いて運用しています.

こうした理由はいろいろありますが, freoの場合は細かい拡張をしようと思うとphpを避けては通れないということと, ブラウザから更新っていうのが非常に面倒だと感じるようになってしまったのが大きいです.  
Middlemanはphpの代わりにRubyが使えるし, ローカルでVimを使って記事を書けるし, html等の静的ファイルを置くだけなのでサーバの設定は簡単だし, レスポンスも速いしで最高です.

また, 記事をテキストファイルで保存するのでGit管理ができて便利です.  
僕は自鯖上に作ったGitのリモートレポジトリにこんな感じのHookを設定して, `git push`するだけでサーバで`middleman build`が走ってサイト更新が完了するみたいなこともやっています.  

```
#!/bin/sh

cd /srv/http/blog.myon.info; git --git-dir=.git pull; bundle install --path vendor/bundle; bundle exec middleman build
```

`middleman-deploy`というextensionもあったのですが, sshのポートなどを書いた設定を外部に出したくなかったということや, 面倒なのでローカルで`middleman build`したくなかった等あるのでこうしました.

ではでは, これ以上単位単位落としたくないのでしばらく姿消すかもしれません. 9月末には戻ってきます.  
んじゃ(✿╹◡╹)ﾉｼ
