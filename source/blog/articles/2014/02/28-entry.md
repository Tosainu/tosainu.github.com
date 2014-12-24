---
title: Twit Plugin for freoが動かなくなったのを修正した
date: 2014-02-28 17:51:34 JST
tags: Website,Programming
---
どーもどーも

&nbsp;

このサイトは<a href="http://freo.jp/">freo</a>を使っています。

また、Twitterへ更新通知するプラグインとして<a href="https://twitter.com/_mo_ka">@_mo_ka</a>氏製作の<a href="http://10prs.com/freo-guide/DL/Twit_Plugin_for_freo">Twit Plugin for freo</a>を利用していたのですが......

最近あったこれ

<blockquote class="twitter-tweet" lang="en"><p>Tomorrow (Jan 14, 2014) all requests to <a href="http://t.co/JJ1WIaJkjK">http://t.co/JJ1WIaJkjK</a> will be restricted to SSL only. Read more: <a href="https://t.co/5bffaNC1i5">https://t.co/5bffaNC1i5</a></p>&mdash; Twitter API (@twitterapi) <a href="https://twitter.com/twitterapi/statuses/422807297048326144">January 13, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

api.twitter.comの接続にSSL必須になったアレですね、これで見事に使えなくなってしまいました。

&nbsp;

仕方ないので、phpは一切触れたことがない僕ですがプラグインの修正を行いました。

また、僕の環境では上記プラグインの導入方法では動かなかったので、その修正方法も公開しておきます。

READMORE

## PEARパスの修正
\libs\PEAR\HTTP\Request2内のException.php 47行目、

\libs\PEAR\HTTP\OAuth内のException.php 24行目にある

```php
require_once 'PEAR/Exception.php';
```

を

```php
require_once 'libs/PEAR/Exception.php';
```

に変更します。

&nbsp;

## TwitterAPIのURL変更
libs/freo/plugins/end.twit\_entry.phpの99行目

```php
$response = $consumer->sendRequest("http://api.twitter.com/1.1/statuses/update.json", array('status' => $status), "POST");
```

を

```php
$response = $consumer->sendRequest("https://api.twitter.com/1.1/statuses/update.json", array('status' => $status), "POST");
```

に、163行目の

```php
$response = $consumer->sendRequest("http://api.twitter.com/1.1/statuses/update.json", array('status' => $status), "POST");
```

を

```php
$response = $consumer->sendRequest("https://api.twitter.com/1.1/statuses/update.json", array('status' => $status), "POST");
```

に変更します。

同様にlibs/freo/plugins/page.twit_entry.phpの39行目の

```php
$consumer->getAccessToken('http://api.twitter.com/oauth/access_token', $_GET['oauth_verifier']);
```

を

```php
$consumer->getAccessToken('https://api.twitter.com/oauth/access_token', $_GET['oauth_verifier']);
```

に、60行目の

```php
$consumer->getRequestToken('http://api.twitter.com/oauth/request_token', $freo->core['http_file'] . '/twit_entry/auth');
```

を

```php
$consumer->getRequestToken('https://api.twitter.com/oauth/request_token', $freo->core['http_file'] . '/twit_entry/auth');
```

に、68行目の

```php
freo_redirect($consumer->getAuthorizeUrl('http://api.twitter.com/oauth/authorize'));
```

を

```php
freo_redirect($consumer->getAuthorizeUrl('https://api.twitter.com/oauth/authorize'));
```

に変更します。

&nbsp;

## ssl\_verify\_peerの無効化
先ほどのURL修正だけでは上手く動いてくれませんでした・・・

[PHPでTwitter APIのOAuthを使う方法まとめ - 頭ん中](http://www.msng.info/archives/2010/01/twitter_api_oauth_with_php.php "PHPでTwitter APIのOAuthを使う方法まとめ - 頭ん中")を参考にさせていただきました。

libs/PEAR/HTTP/Request2.phpの160行目、

```php
'ssl_verify_peer'   => true,
```

を

```php
'ssl_verify_peer'   => false,
```

に変更します。

&nbsp;

こうして、プラグインページの解説と同じ方法でプラグインの設置及び設定を行うと・・・

<blockquote class="twitter-tweet" lang="en"><p>【ブログ更新】 Twit Plugin for freoが動かなくなったのを修正した <a href="http://t.co/G6DxVoz9Z0">http://t.co/G6DxVoz9Z0</a></p>&mdash; X79T (@tosainu_3930k) <a href="https://twitter.com/tosainu_3930k/statuses/439321973399633920">February 28, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

やったね動いたよ！

ではでは〜
