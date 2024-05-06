---
title: StreamingAPIを使ったハッシュタグ監視ツール"htWatch"を作った
date: 2014-03-28 01:08:06+0900
noindex: true
---
どーもです。

夕方あまりにも暇で、何しようかなーとゴロゴロしていましたが、ふと

「勉強会とかで役立つハッシュタグ管理ツールつくって♡」

と某氏に言われていたのを思い出し、サッと書くことにしました。

[Tosainu/htWatch](https://github.com/Tosainu/htWatch "htWatch")


![](./2014-03-27-234612_1920x1080_scrot.png)


## 仕様とか
Node.jsで書きました。  
理由は簡単、僕がNode.jsくらいしかまともにTwitterを扱えないからです()

今回は[node-webkit](https://github.com/rogerwang/node-webkit "node-webkit")というライブラリを使っています。  
これを使うと、HTML+Chromiumベースのアプリケーションが作成できるほか、ブラウザ上のJavaScriptとしてNode.jsの命令を扱うことができます。

公式からの引用ですが、例えばこんなの。

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hello World!</title>
  </head>

  <body>
    <h1>Hello World!</h1>
    We are using node.js <script>document.write(process.version)</script>.
  </body>
</html>
```

こんな感じに、`process.version`(Node.jsのバージョンを取得)のようなNode.jsの命令を混ぜ込んだコードを書くことができます。

## 使い方
GitHubのUsageを見れば実行できると思います。  
するとこんなウィンドウが出るので、


![](./2014-03-28-005230_1920x1080_scrot.png)


このフォームに検索したいハッシュタグ等を入力して`Start`をクリックするとStreamingAPIの接続が開始します。  
全画面表示するなりして使ってください♡

ではでは〜
