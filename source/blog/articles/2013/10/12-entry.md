---
title: Node.jsで遊んだ (2)
date: 2013-10-12 21:32:39 JST
tags: JavaScript,RaspberryPi
---
<p>どもどもー</p>
<p>&nbsp;</p>
<p>前回書いたコードにとんでもない問題があったんで修正したメモです。</p>
<p>興味ある人だけ続きをどうぞ。</p>
READMORE
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>とりあえず前回書いたコードを見なおしてほしい。</p>
<p>&nbsp;</p>

```javascript
/*
  main.js
*/

--- 略 ---
// httpリクエストが来た時の動作
function handler (req, res) {
  // index.htmlを読み込んで
  fs.readFile('index.html',　function (err, data) {
    if(err) {
      // 無かったら404
    }
    // 表示する
    res.writeHead(200);
    res.write(data);
    res.end();
  });
}
--- 略 ---
```

<p>さて、これの何が問題かといいますと、例えばTwitterBootstrapを使ったhtmlを表示させようとしてみます。</p>
<p><a href="https://picasaweb.google.com/lh/photo/6x_lr6ieDuk3lVHgHFOdGdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-ajr-72FwfBM/UlkzRSxfFVI/AAAAAAAACqQ/g4kv_bqTFQg/s400/Screenshot%2520from%25202013-10-10%252022%253A42%253A21.png" height="302" width="400" /></a></p>
<p>すると・・・</p>
<p>&nbsp;</p>
<p><a href="https://picasaweb.google.com/lh/photo/a2WMUL7Hc7UjP973-fFjtdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-ydbOXvhzto8/UlkzMRk6jLI/AAAAAAAACqE/hw8Maybzp-Y/s400/Screenshot%2520from%25202013-10-12%252020%253A24%253A11.png" height="400" width="348" /></a></p>
<p>こうなります。</p>
<p>&nbsp;</p>
<p>理由は簡単です。このサーバーは「どんなリクエストに対してもindex.htmlを返す」仕様です。</p>
<p>外部のcssやjs、画像まで。読み込もうとしたファイルはすべてindex.htmlになりますw</p>
<p><a href="https://picasaweb.google.com/lh/photo/J8JZ3tVC2xQ8zH2yNZvYDNMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-SdU-defLp-Y/UlkzMgowgdI/AAAAAAAACqI/vKHAgVNgzds/s400/Screenshot%2520from%25202013-10-12%252020%253A27%253A22.png" height="170" width="400" /></a></p>
<p>&nbsp;</p>
<p>さすがにこれでは使い物にならないので修正しました。</p>
<p>&nbsp;</p>

```javascript
/*
  main.js
*/

var app = require('http').createServer(handler)
  , io  = require('socket.io').listen(app)
  , fs  = require('fs')
  , mime= require('mime')

app.listen(3000);

function handler (req, res) {
  // Check File Path
  var path;
  if(req.url == '/') {
    path = './index.html';
  }
  else {
    path = '.' + req.url;
  }

  // Read File and Write
  fs.readFile(path, function (err, data) {
    if(err) {
      res.writeHead(404, {"Content-Type": "text/plain"});
      return res.end(req.url + ' not found.');
    }
    var type = mime.lookup(path);
    res.writeHead(200, {"Content-Type": type});
    res.write(data);
    res.end();
  });
}
```

<p>&nbsp;</p>
<p>各部分ごとの解説をしていきます。</p>

```javascript
var app = require('http').createServer(handler)
  , io  = require('socket.io').listen(app)
  , fs  = require('fs')
  , mime= require('mime')

app.listen(3000);
```

<p>サーバーの作成、必要なモジュールのロード、及びサーバーのポート設定等を行っている部分です。</p>
<ul>
<li>socket.io：Socket.IO通信を使うためのモジュール</li>
<li>fs：ファイル読み込みなどのファイルシステム操作モジュール</li>
<li>mime：ファイルタイプ判断（後述）のためのモジュール</li>
</ul>
<p>app.listen(3000);はサーバーのポート設定。今回は3000番ポートです。</p>
<p>&nbsp;</p>

```javascript
function handler (req, res) {
  // Check File Path
  var path;
  if(req.url == '/') {
    path = './index.html';
  }
  else {
    path = '.' + req.url;
  }
```

<p>ここから、リクエストに対する動作の部分になります。</p>
<p>ここではファイルパスの判断を行っています。</p>
<p>まず、req.urlはアクセスされたURLを取得取得するものです。http://hoge.com/fuga/myon.htmlへのアクセスがあった時、req.urlを使うと/fuga/myon.htmlという文字列を取得することができます。</p>
<p>/、つまり何もファイルを指定されなかったらindex.htmlを、そうでなかったら指定されたファイルパスを変数pathに代入しています。</p>
<p>ドキュメントルートはmain.jsと同じディレクトリなので、./filenameのように相対パスで設定しています。</p>
<p>&nbsp;</p>

```javascript
  // Read File and Write
  fs.readFile(path, function (err, data) {
    if(err) {
      res.writeHead(404, {"Content-Type": "text/plain"});
      return res.end(req.url + ' not found.');
    }
```

<p>ファイルの読み込みをおこない、見つからなかった時（他の要因も考えられるけど）の動作です。</p>
<p>fs.readFileで先ほどのpathに代入されたファイルを読み込み、エラーだったら「○○ not found.」と表示させています。</p>
<p>&nbsp;</p>

```javascript
    var type = mime.lookup(path);
    res.writeHead(200, {"Content-Type": type});
    res.write(data);
    res.end();
  });
}
```

<p>ファイルが存在していた時の動作です。ここで注目するのがvar type = mime.lookup(path);です。</p>
<p>pathにより様々なファイルが読み込めるようになったわけですが、Content-Typeを区別してやらないといけないようです。</p>
<p>そこでmimeというモジュールをnpmでインストール、先頭にmime= require('mime')と記述して、mime.lookup(ファイルパス);でContent-Typeを判断できるようです。</p>
<p>ここでは変数typeにContent-Typeを代入し、res.writeHead(200, {"Content-Type": type});というようにしてContent-Typeを指定して出力しています。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>現在作成しているラジコンのコントロールページはほぼ完成といった感じです。</p>
<p>あとはRasPiで動かして、またピン制御等のコードを追加するだけです。</p>
<p>&nbsp;</p>
<p>さーて、SDはの修理が終わるまでにAVRでのPWM制御をマスターせねば。</p>
<p>ではでは〜</p>
