---
title: SlackのBotを書いてみた
date: 2016-01-24 14:44:00+0900
tags: Slack, Ruby
---

今までメッセージのやり取りをL○NEで行っていた某所が, ついにSlackに移行しました. 非常にめでたい.

んで, 個人的に **SlackといったらBot** みたいなのがあるので, とりあえずサクッとBot書いてみた時のメモです.  
ぶっちゃけ, この手の記事は全世界各言語でいくつもあると思いますが.

<!--more-->

## Real Time Messaging API

SlackのBotを書き始める前に, まずSlackのAPIがどんな感じになっているかを調べておきます.

SlackにはいくつかのAPIが用意されていますが, その一つである**[Real Time Messaging API](https://api.slack.com/rtm)**(以後RTM)は, その名の通りリアルタイムにSlackの各イベントを受け取ることのできるAPIです.

APIは他にもありますが, 何かイベントが合った時にHTTP POSTリクエストが行われるという各**Webhook**や**Slash Command**は, 外からアクセスできるWeb鯖を立てにくい環境にある身としては敷居が高かったので, 今回はRTMを利用することにしました.

### Event

RTMを使うことでSlack上で起きた出来事をリアルタイムで取得できるわけですが, それらは**Event**で区別されています.  
受け取ることのできるEventは[ここ](https://api.slack.com/rtm#events)に全て載っていますが, 今回は接続を確認するために`hello`, 投稿されたメッセージの情報を受け取るために`message`を使いました.

#### [hello event](https://api.slack.com/events/hello)

サーバとの接続ができた時に送られてくるイベントです.

#### [message event](https://api.slack.com/events/message)

新しいメッセージが投稿されたり, 編集/削除されたときに送られてきます.  
受け取ることができる主な情報は

| プロパティ名 | 受け取れるデータ |
| :-: | --- |
| `channel` | メッセーが投稿されたチャンネル固有のID (名前ではない) |
| `user` | メッセージを投稿したユーザ固有のID (@hogefugaではない) |
| `text` | メッセージの本文 |
| `ts` | メッセージが投稿された時間 |

メッセージが編集/削除された時やStarされたメッセージなどはもう少し取れる情報が増えたり形式が変わったりするようですが, その辺に関しては割愛します.

## SlackにBot userを追加する

今回作成するBot用のユーザを追加します.

[Build Your Own | Slack](https://slack.com/apps/build)を開き, 右側の**Make a Custom Integration**ボタンをクリックします.  
![custom integratioon](https://lh3.googleusercontent.com/-Sxa9w1uvrHo/VqQ_9dhamrI/AAAAAAAAF3s/1sZ7DV8R1hA/s800-Ic42/2016-01-24-114429_1920x1080_scrot.png)

追加したいチームのBuild a Custom Integrationページに移動したら, **Bots**を選択.  
![make bot](https://lh3.googleusercontent.com/-nM0fG2rMQoI/VqQ_9dI2L5I/AAAAAAAAF34/TccwmkxdEXY/s640-Ic42/2016-01-24-114447_1920x1080_scrot.png)

任意のUsernameを設定して完了です.  
![username](https://lh3.googleusercontent.com/-ww7BaymaO1Q/VqRBVQTXbZI/AAAAAAAAF4I/JDrZTjgvB0Y/s640-Ic42/2016-01-24-114610_1920x1080_scrot.png)

Integration Settingsの**API Token**を後で使うので控えておきます.  
![token](https://lh3.googleusercontent.com/-law3zjyOKrA/VqQ_95TedcI/AAAAAAAAF30/ADnOK5nRJ5o/s640-Ic42/2016-01-24-114704_1920x1080_scrot.png)

## slack-ruby-clientでBotを書く

Twitter APIのときみたいに **C++でOAuthから手書き~** みたいなことも考えましたが, 今回使いたかったRTMはWebSocketベースのAPIらしく, 暇もないしちょーっと大変そうだなーと思ったので, 今回はRubyで書きました.  
Slackの利用者にプログラマが多いせいか, `Node.js`や`Ruby`といったWebアプリ界隈に人気の言語を中心に各言語でライブラリが揃っており, 比較的扱いやすいプラットフォームなのではないかなーという印象を受けました.  

* Ruby 2.3.0p0 (2015-12-25 revision 53290) [x86\_64-linux]
* Bundler 1.11.2
* [slack-ruby-client](https://github.com/dblock/slack-ruby-client) 0.5.4

### RTM Clientを使う

まぁ公式の[README](https://github.com/dblock/slack-ruby-client/blob/faab93a33f59ef89bc97f985437e476b048a086a/README.md#realtime-client)やドキュメントを見ればいいのですが, こんな感じに書くようです.

```ruby
require 'slack-ruby-client'

Slack.configure do |conf|
  # 先ほど控えておいたAPI Tokenをセット
  conf.token = 'API Token'
end

# RTM Clientのインスタンスを生成
client = Slack::RealTime::Client.new

# hello eventを受け取った時の処理
client.on :hello do
  puts 'connected!'
end

# message eventを受け取った時の処理
client.on :message do |data|
  case data['text']
  when 'にゃーん' then
    # textが 'にゃーん' だったらそのチャンネルに 'Λ__Λ' を投稿
    client.message channel: data['channel'], text:'Λ__Λ'
  end
end

# Slackに接続
client.start!
```

こんな感じの`Gemfile`を作成して

```ruby
source 'https://rubygems.org'

gem 'slack-ruby-client'

# RTM Clientを使うとき必要
gem 'eventmachine'
gem 'faye-websocket'
```

こんな感じに実行すれば...

```
// 依存するGemのインストール (最初だけ必要)
$ bundle install --path vendor/bundle

// Botの実行 (上のソースをbot.rbで保存している場合)
$ bundle exec ruby bot.rb
```

<blockquote class="twitter-tweet tw-align-center" data-partner="tweetdeck"><p lang="ja" dir="ltr">Botつくれたヾ(๑&gt;◡&lt;)ﾉ&quot; <a href="https://t.co/4d2Bj0NF2I">https://t.co/4d2Bj0NF2I</a> <a href="https://t.co/WrB8ciXJCi">pic.twitter.com/WrB8ciXJCi</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/690577036096614400">January 22, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## コードを実行して結果を返すBot作った

某所Slackに **C++で困ったら誰かが教えてくれる場所** というチャンネルを立てたので, 他所のSlackで見たことのある見出し通りのBotがあると便利そうだなーと思っていたので作りました.  
<https://gist.github.com/Tosainu/6b9eb76e56bdceaacb15>

![slack](https://lh3.googleusercontent.com/-TZACTTl9x8U/VqQuqtcW7WI/AAAAAAAAF3E/S3TdUEotdig/s800-Ic42/2016-01-23-132924_1920x1080_scrot.png)

Bot宛のDM, もしくはBotを招待したチャンネルで

> run C++ code

もしくは

> run:language code

といったメッセージを投稿すると, オンラインコンパイラ[Wandbox](http://melpon.org/wandbox/)のAPIを叩き, 結果を投稿してくれます!!

## おわり

Slack便利すぎる...

* [Real Time Messaging API | Slack](https://api.slack.com/rtm)
* [dblock/slack-ruby-client - Ruby](https://github.com/dblock/slack-ruby-client)
* [Slack Bot Real Time Messaging API Integration in Ruby Tutorial – code.dblock.org | tech blog](http://code.dblock.org/2015/04/28/slack-bot-real-time-messaging-api-integration-tutorial.html)
