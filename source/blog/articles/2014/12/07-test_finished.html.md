---
title: てすとおわりました
date: 2014-12-07 16:26 JST
tags: C++
---

みょん.

後学期の中間テストが終わりました.  
今回のテストはそんなに辛くなかったというか, 来週の専門科目の小テのほうが怖かったりします. はい.

## ✿ 最近のこと

* FE合格しました
* VAIO ZたんからWindowsが消滅しました
* 寒いですね
* Boost.Xpressiveつよい
* [Tosainu/twitpp](https://github.com/Tosainu/twitpp)を再び弄りはじめました(後述)
* [BS11にて「ご注文はうさぎですか？」再放送決定！ -TVアニメ「ご注文はうさぎですか？」公式サイト-](http://www.gochiusa.com/news/hp0001/index02610000.html)
* ∩(＞◡＜✘)∩∩(＞◡＜✘)∩∩(＞◡＜✘)∩

## twitpp

最近全く弄っていなかったのですが, あることが一段落したのでどんどん改良しています.  
8月に書いたコードが汚すぎて手を付けられないくらいひどいので.....

改めてtwitppの紹介をすると, C++11以降(not VC++)でTwitterを扱うためのライブラリです.  
開発当初はlibcurlを使っていましたがBoost.Asioに切り換え, Userstream接続なんかにも対応しました.

```cpp
// consumer_key等をセット
twitpp::oauth::account account("CONSUMER", "CONSUMER_SECRET");
// access_tokenも設定できる
// twitpp::oauth::account account("CONSUMER", "CONSUMER_SECRET", "ACCESS", "ACCESS_SECRET");

// authorization urlを取得
account.get_authorize_url();
std::cout << account.authorize_url() << std::endl;

// PINを渡して認証
account.get_oauth_token(pin);

// oauth::clientクラスに認証したoauth::accountを渡す
twitpp::oauth::client oauth(account);

// ツイートする
auto res = oauth.post("https://api.twitter.com/1.1/statuses/update.json", {{"status", "Test Tweet!"}});
std::cout << res.response_body << std::endl;

// userstreamに接続
oauth.get("userstream.twitter.com", "/1.1/user.json", [](int& status, std::string& text) {
  std::cout << text << std::endl;
  text.clear();
});
```

ある程度いい感じになってきたと思っているので, 近いうちにこれを組み込んだあるものを作っていきたいなぁと思っています.

また, twitppは何度も言うようにコードが汚い部分が多く, 特に`twitpp::net::async_client`とか`twitpp::oauth::client`のlambda式を渡す`get()`と`post()`は早急に改善したいなぁって感じです.

ではではー.
