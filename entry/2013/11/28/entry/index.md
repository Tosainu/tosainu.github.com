---
title: みょん(進捗)
date: 2013-11-28 23:58:50+0900
tags: C++
---
みょん。

&nbsp;

以前から書いていたTwitter関連のプログラムが一歩進んだので報告しておきます。

<!--more-->

&nbsp;

<blockquote class="twitter-tweet tw-align-center" lang="ja"><p>キタ———(゜∀゜)———— !!&#10;アクセストークン取得できたー <a href="http://t.co/ugZn9lqOvx">pic.twitter.com/ugZn9lqOvx</a></p>&mdash; とさいぬ.cc (@tosainu_3930k) <a href="https://twitter.com/tosainu_3930k/statuses/405266490728804352">2013, 11月 26</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet tw-align-center" lang="ja"><p>TestTweet</p>&mdash; とさいぬ.cc (@tosainu_3930k) <a href="https://twitter.com/tosainu_3930k/statuses/405342782400626688">2013, 11月 26</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet tw-align-center" lang="ja"><p>ThisTweetWasPostedFromTosainusProgram.</p>&mdash; とさいぬ.cc (@tosainu_3930k) <a href="https://twitter.com/tosainu_3930k/statuses/405343973524250625">2013, 11月 26</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet tw-align-center" lang="ja"><p>ﾂｲｰﾖができた✌(&#39;ω&#39;✌ )三✌(&#39;ω&#39;)✌三( ✌&#39;ω&#39;)✌ <a href="http://t.co/TtVmSoEKZF">pic.twitter.com/TtVmSoEKZF</a></p>&mdash; とさいぬ.cc (@tosainu_3930k) <a href="https://twitter.com/tosainu_3930k/statuses/405345020418342912">2013, 11月 26</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

&nbsp;

アクセストークン取得および一部のAPIが叩けるようになっただけなので、ソースの公開はまだまだ先の予定ですが、3日間悩んだlibcurlでpostする部分のコードを張っておこうと思います。

```cpp
// Init libcurl
CURL *curl;
CURLcode ret;
struct curl_slist *headers = NULL;

curl_global_init(CURL_GLOBAL_ALL);

curl = curl_easy_init();
string chunk;
if (curl == NULL) {
  cerr &lt;&lt; "curl_easy_init() failed" &lt;&lt; endl;
  return 1;
}

// Set Http-Header
headers = curl_slist_append(headers, "Expect:");
headers = curl_slist_append(headers, "Content-Type: application/x-www-form-urlencoded");
headers = curl_slist_append(headers, "Authorization :(ry");

// Set libcurl Parameter
curl_easy_setopt(curl, CURLOPT_VERBOSE, 1);
curl_easy_setopt(curl, CURLOPT_URL, "URL");
curl_easy_setopt(curl, CURLOPT_POST, 1);
curl_easy_setopt(curl, CURLOPT_HTTPHEADER , headers);
curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "");
curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, 0);
curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_to_string);
curl_easy_setopt(curl, CURLOPT_WRITEDATA, (string*)&amp;chunk);

// Get Data and Clean
ret = curl_easy_perform(curl);
curl_easy_cleanup(curl);
curl_slist_free_all(headers);

if (ret != CURLE_OK) {
  cerr &lt;&lt; "curl_easy_perform() failed." &lt;&lt; endl;
    return 1;
}

// Show Respone
cout &lt;&lt; chunk &lt;&lt; endl;
```

Tweetするときなど、引数を設定しなければいけないときは、

```
curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "送信する引数をurlエンコードしたもの");
curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, ↑の文字数);
```

を設定してやればよいし、

TL取得など、GETmethodを使う場合は

```cpp
curl_easy_setopt(curl, CURLOPT_POST, 1);
curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "");
curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, 0);
```

の行を消せばいけるはずです。

今後、日本語などが扱えるように改良するほか、他のプログラムでも簡単に使えるようにライブラリ化していこうかなーと思っています。

&nbsp;

&nbsp;

全く関係ないのですが、とあるふぉろわーさんの紹介でRubyを触ってみました。

<span class="fontsize7">やばい</span>

「さっ」と気軽に書ける感じがいいですね♪

今後、Rubyも少しずつ勉強していきたいな〜と思います。

&nbsp;

テストも近づいてきたので再び更新頻度は落ちます。

(いつもと変わらずついったーには出現してる気がしますが・・・)

ではでは〜
