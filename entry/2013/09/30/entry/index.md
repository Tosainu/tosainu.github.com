---
title: Node.jsとSocket.IOで遊んでた
date: 2013-09-30 18:02:21+0900
---
<p>どもども〜</p>
<p>&nbsp;</p>
<p>昨日の記事にも書いたように、ブラウザから操縦するラジコン的なものの制作を計画しています。</p>
<p>今日はそれで使おうと思っている<a href="http://nodejs.org/">Node.js</a>と<a href="http://socket.io/">Socket.IO</a>を使ってプログラムを書いていました。</p>
<p>&nbsp;</p>
<p>興味ある方だけ続きからどうぞ。</p>
<!--more-->
<p>&nbsp;</p>
<h2>Node.jsとは？</h2>
<p>簡単に言えば、</p>
<p><span class="fontsize6">「JavaScriptを使ったサーバーが構築できる言語」</span></p>
<p>のことらしいです。</p>
<p>「アクセスされるごとにどのような処理をさせるか」といったことがjsで書けるほか、</p>
<p>Socket.IOなどの組み合わせで、簡単にリアルタイムWeb（主にSNSなど）が構築できます。</p>
<p><span class="fontsize1">※すいませんうまく説明できません・・・気になったらググってください</span></p>
<p>&nbsp;</p>
<h2>Arch LinuxでNode.jsを動かす</h2>
<p>pacman(yaourt)で簡単にインストール出来ました。</p>
<pre class="prettyprint linenums">
<code>$ yaourt -Sys nodejs         
community/nodejs 0.10.19-1
    Evented I/O for V8 javascript
...

$ yaourt -S nodejs
...

$ node -v           
v0.10.19
</code></pre>
<p>&nbsp;</p>
<h2>htmlを表示するだけ</h2>
<p>動作確認に、同じディレクトリにあるhtmlファイルを開くだけのコードを書いてみます。</p>
<pre class="prettyprint linenums">
<code>/*
  test.js
*/

var app = require('http').createServer(handler)
  , fs = require('fs')

app.listen(3000);

function handler (req, res) {
  fs.readFile('index.html',
  function (err, data) {
    if(err) {
      res.writeHead(404);
      return res.end('index.html not found.');
    }
    res.writeHead(200);
    res.write(data);
    res.end();
  });
}

console.log('Server start...');
</code></pre>
<p>また、このtest.jsと同じディレクトリにhtmlファイルをindex.htmlという名前で保存しておきます。</p>
<p>&nbsp;</p>
<pre class="prettyprint linenums">
$ node test.js
</pre>
<p>でサーバーを起動させます。</p>
<p>http://127.0.0.1:3000にアクセスすると、用意したhtmlファイルが表示されるはずです。</p>
<p>&nbsp;</p>
<h2>Socket.IOでリアルタイムで通信を行う</h2>
<p>まず、npmでSocket.IOをインストールします。jsを置くディレクトリでこのコマンドを打ちます。</p>
<p>root権限が必要でした。</p>
<pre class="prettyprint linenums">
$ sudo npm install socket.io
</pre>
<p>&nbsp;</p>
<p>さて、今日書いたプログラムです。</p>
<p><img src="https://lh3.googleusercontent.com/-PoZ-ymBXQN4/Ukk81_JSGnI/AAAAAAAACnU/FfGkx9Qeh3c/s640/Screenshot%2520from%25202013-09-30%252017%253A55%253A27.png" /></p>
<p>ブラウザのフォームにテキストを入れてボタンを押すと、サーバーのlogにそのテキストが表示されます。</p>
<p>また、フォームに「ping」と入力しボタンを押すと、サーバーが「pong」を返しフォームに表示させるようになってます。</p>
<p>※エラー処理等、細かいことはあまり気にしてませんw</p>
<pre class="prettyprint linenums">
<code>/*
  main.js
*/

var app = require('http').createServer(handler)
  , io = require('socket.io').listen(app)
  , fs = require('fs')

app.listen(3000);

function handler (req, res) {
  fs.readFile('index.html',
  function (err, data) {
    if(err) {
      res.writeHead(404);
      return res.end('index.html not found.');
    }
    res.writeHead(200);
    res.write(data);
    res.end();
  });
}

console.log('Server start...');

io.sockets.on('connection', function (socket) {
  socket.on('data1', function (data) {
    console.log(data);
    if(data == 'ping') {
      socket.emit('data2', 'pong');
    }
  });
});
</code></pre>
<p>&nbsp;</p>
<pre class="prettyprint linenums">
<code>/*
  index.html
*/

&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;
&lt;html xmlns="http://www.w3.org/1999/xhtml"&gt;
  &lt;head&gt;
    &lt;title&gt;WebSocket Test&lt;/title&gt;
    &lt;script src="/socket.io/socket.io.js"&gt;&lt;/script&gt;
    &lt;script&gt;
      var socket = io.connect('http://localhost');
      function OnButtonClick() {
        var data1 = document.send.text.value;
        socket.emit('data1', data1);
      }
      socket.on('data2', function (data2) {
        document.send.text.value = data2;
      });
    &lt;/script&gt;
  &lt;/head&gt;
  &lt;body&gt;
    &lt;h1&gt;Testing...&lt;/h1&gt;
    &lt;form name="send"&gt;
      &lt;input type="text" name="text" size="40"&gt;
      &lt;input type="button" value="Exec" onclick="OnButtonClick();"/&gt;
    &lt;/form&gt;
  &lt;/body&gt;
&lt;/html&gt;
</code></pre>
<p>&nbsp;</p>
<p>いやぁ〜、これはおもしろいです。</p>
<p>jsなんてほとんど書いたことないですが、結構簡単に書くことができました。</p>
<p>これだけできれば、遠隔操作のシステムもほとんどできたといってもいいようなものですね。</p>
<p>&nbsp;</p>
<p>ではでは〜</p>
<p><del><span class="fontsize1">あれ、明日TOEICだった気が・・・</span></del></p>
<p>&nbsp;</p>
<p>参考</p>
<p><a href="http://nodejs.org/">node.js</a></p>
<p><a href="http://socket.io/">Socket.IO: the cross-browser WebSocket for realtime apps.</a></p>
<p><a href="http://mdlab.jp/project/node_js/01.html">第一回 Node.jsでどんなことができる？｜マルチデバイスLab. - Multi Device Lab.</a></p>
