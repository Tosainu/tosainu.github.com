---
title: '[ネタ] QWebViewでGUIアプリケーションを作る'
date: 2015-02-28 17:14:00+0900
tags: C++
---

## CocoaTwit

以前から何度かつぶやいていた自作Twitterクライアント, [**CocoaTwit-QWebView**](https://github.com/Tosainu/CocoaTwit/tree/QWebView)を公開しました.  
![img](https://lh4.googleusercontent.com/-jk8X_B1uYi0/VPF3b9cvJII/AAAAAAAAD9U/3zAolbThC8Y/s640/2015-02-28-170528_3000x1920_scrot.png)

**A Simple and Cute Twitter Client**をコンセプトに, シンプルなデザインかつ細かな拡張のしやすいTwitterクライアントを目指しています.  
また, 僕が今まで使ってきたTwitterクライアントの手が届かなかったところを改善して実装していこうと思っています.  
ちなみにCocoaTwitという名前に特別な意味は無いです. ココアさんかわいい.

バイナリ配布は今のところ予定していませんが, 気になるLinux使いの方はビルドしてみてください.  
(Macでもイケると思ったけど, [twitppがApple Clangでビルドできなかった](https://github.com/Tosainu/twitpp/issues/3))

## この記事で紹介する手法はネタです

正月くらいからこのCocoaTwitをタイトル通りの手法で開発していました.  
しかし, もっとよさ気な方法を見つけたため設計を大幅変更することにしました[^1].

この時点でQWebView版CocoaTwitも本記事もある程度出来上がっており, 消してしまうのがもったいなかったためネタ記事として公開することにしました.  
**こんなブッ飛んだこともできるんだな〜**って感じで読んでもらえると良いかと思います.

[^1]: ただし作者は当分Qtってるコードを書きたくない模様

<!--more-->

## C++でGUI is つらい

昨年から[twitpp](https://github.com/Tosainu/twitpp)を書いていますが, これは**C++でTwitterクライアントが作りたかった**ためです.  
それに伴い以前からよさ気なGUIライブラリを探していたのですが, なかなか良いものが見つかりません.

C++には有名な[Qt](http://qt-project.org/)をはじめ[wxWidgets](http://wxwidgets.org/)や[FLTK](http://www.fltk.org/), [gtkmm](http://www.gtkmm.org/)などのGUIライブラリが存在[^2]しますが, これらの中から

* クセの少なく
* マクロを多用していなくて
* 他のC++コードとイイ感じに組み合わせられる

ものに絞っていくと, うーん.......  
悩んだ末, 最近よく耳にしていて個人的に使ってみたかったライブラリでもあったQt5を使うことにしました.

[^2]: [List of platform-independent GUI libraries - Wikipedia](http://en.wikipedia.org/wiki/List_of_platform-independent_GUI_libraries)

## Qtの微妙だった点

### STLと非互換なライブラリ

Qtは独自の文字列型である`QString`をはじめ`QVector`や`QList`などの**STLに代わるクラスを提供**しており, そして**GUI周りのクラスがそれらに依存**しています.  
そのため, 今回のような非Qtなライブラリと組み合わせて使おうとすると**独自型とのキャストが多発**し, あまり気分の良いものではありません.

CocoaTwitでは特に`std::string`と`QString`の相互変換が多発しました.  
僕はこんな感じに対処しましたが, もっと良い物があれば教えてもらえると嬉しいです.

```cpp
// std::string -> QString
std::string foo("foo");
QString bar = QString::fromStdString(foo);

// QString -> std::string
QString hoge = "hoge";
std::string fuga(hoge.toUtf8().constData());
```

### マクロの多用

Qtの代表的な機能であるSignal/Slotなどの実現には**魔術(マクロ等)が多用**されています.  
別にただ単にマクロが使われている分には良いのですが, 実際に副作用的なものに遭遇したため許せませんでした.

特に`Q_OBJECT`マクロが曲者です.  
まず, `Q_OBJECT`が書かれたクラス宣言のあるヘッダファイルで`boost/asio.hpp`をincludeするとビルドが通らなくなることがある現象[^3]に遭遇し1ヶ月悩みました.  
そして, [2015年の目標](/entry/2015/01/02/2015-new-year-resolution/)に書いたようにtemplateを使ったプログラムに力を入れたかったのですが, `Q_OBJECT`の使われたクラス(Qt関連のすべてのクラス)ではClass Templateが使えない[^4]と知って本当にショックでした.

[^3]: <https://svn.boost.org/trac/boost/ticket/10688> includeする場所をソースファイルに変えると解決する
[^4]: <http://qt-project.org/forums/viewthread/14058>

### 命名規則の違い

Qtは**camelCase**なクラス/関数を提供しています.  
しかし, C++標準ライブラリやBoostに合わせて**snake\_case**でコードを書いてきた僕にとっては物凄い違和感に苦しめられました.

命名規則は大体はその言語の標準ライブラリに合わせるのがBestかなと思っているのですが, どうしてこう外部C++のライブラリはcamelCaseのものが多いのか.......  
まぁコンパイラから見れば関係ないんだろうけどさぁ.......

## 複雑なUIを組みたい

camelCaseな書き方を我慢するとしても, マクロの副作用に気をつけたとしても, Class Templateを諦めたとしても, 実際にQtでTwitterクライアント開発を始めて行くと大きな壁にぶつかりました. **Widgetの拡張**です.

単純に[`QPushButton`](http://doc.qt.io/qt-5/qpushbutton.html)等の用意されたWidgetを配置していく程度のアプリケーションなら何の問題もないのですが, 今回作成したいのはTwitterクライアントです.  
例えばタイムライン表示を実装するとします. TweetDeckほど複雑な表示でなくとも, 最低限アイコンとscreen\_name, tweet本文を独立して表示できるListViewが欲しいわけです.  
![tl](https://lh6.googleusercontent.com/-T_p5Iyi_HDc/VMt4Iu1oDLI/AAAAAAAAD7o/SO9a8-u8fbg/s800/twitteritem.png)

QtにこのようなWidgetは用意されていないので, ちょっと弄る必要があります.  
QtのListViewである[`QListView`](http://doc.qt.io/qt-5/qlistview.html)を拡張するには, 必要に応じて[`QAbstractListModel`](http://doc.qt.io/qt-5/qabstractlistmodel.html)等を継承した独自のModelを作成し, また[`QStyledItemDelegate`](http://doc.qt.io/qt-5/qstyleditemdelegate.html)を継承したクラスを適用させて`QListView`のItemをPaintするときの動作を上書きしていくようです. 詳しくは[こちら](http://doc.qt.io/qt-5/model-view-programming.html).

これらの情報を元に, 年末にいろいろ弄ってみました.  
しかし, 僕のQt力が足りないことや, 雑に書いたのもありますがどうも不安定で, コードが予想以上に複雑に....  
ここから表示する情報を増やしたり, Tweetの行数に合わせて高さを可変させるようにしたり, デザインよくしたりと考えていくともう.....\_(:3 」∠)\_

<blockquote class="twitter-tweet tw-align-center" lang="en"><p>それっぽいのできた <a href="http://t.co/7jZU0Iv95o">pic.twitter.com/7jZU0Iv95o</a></p>&mdash; 不正競争防止法 (@myon\_\_\_) <a href="https://twitter.com/myon___/status/550229017098326016">December 31, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

ちなみに, `QListView`と[`QStandardItemModel`](http://doc.qt.io/qt-5/qstandarditemmodel.html)を利用すると, アイコン付きのListは簡単に作れました.  
しかし, 画面端での文字折り返しがどうしてもうまくいかず諦めました. (標準Widgetでは不可能...?)

```cpp
QListView* l = new QListView();
QStandardItemModel* model = new QStandardItemModel();

l->setModel(model);
l->setEditTriggers(QAbstractItemView::NoEditTriggers);
l->setIconSize(QSize(64, 64));

model->insertRow(0, new QStandardItem(QIcon("icon.png"), "myon!!"));
```

<blockquote class="twitter-tweet tw-align-center" lang="en"><p>QtでUserstream流せた∩(＞◡＜\*)∩ <a href="http://t.co/bgbyyh6r7d">pic.twitter.com/bgbyyh6r7d</a></p>&mdash; 不正競争防止法 (@myon\_\_\_) <a href="https://twitter.com/myon___/status/533104702963978241">November 14, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## HTMLでUIを書くという選択肢

さて, 長くなりましたが本題です.

なんとかいい感じに, 思い通りのUIを設計できる方法がないかと探っていると, たまたま開いたQtのドキュメントで[`QWebView`](http://doc.qt.io/qt-5/qwebview.html)というクラスがあるのを見つけます.  
このクラスは名前の通りWebドキュメントを表示したり編集したりするためのものです.

また, `QWebView`に関連したクラスである[`QWebFrame`](http://doc.qt.io/qt-5/qwebframe.html)に, `addToJavaScriptWindowObject()`という何とも怪しいメンバ関数があるのを見つけます.  
このメンバ関数は, なんと[`QObject`](http://doc.qt.io/qt-5/qobject.html)を継承しているObjectを`QWebView`などで表示しているページ内のJavaScript Objectとして追加できるという物凄いものでした.

そして最後に, 上記のメンバ関数の利用例を示した[The Qt WebKit Bridge](http://doc.qt.io/qt-5/qtwebkit-bridge.html)というドキュメントにたどり着きます.  
このページには, `QWebView`内で動くJavaScriptとC++なコードを結びつけてアプリケーションを作る手法のあれこれが記されています.

**あっ, これってつまり..... GUI周りをすべてHTMLで実現できるってことじゃね!!??**

ということで, 上記手法を用いたGUIアプリケーション作成方法について紹介していこうと思います.

## Hello World!

とりあえず`QWebView`を使ってみます.

<script src="https://gist.github.com/Tosainu/8d4bd1e28813d3f93d4e.js"></script>

```
$ qmake
$ make
$ ./QWebView_example
```

![example](https://lh6.googleusercontent.com/-h9rrhxDATYo/VLOHLGrOFxI/AAAAAAAAD4U/cZhcZTFEtHg/s640/2015-01-12-173150_1920x1080_scrot.png)

これだけです. 簡単ですね.  
ちなみに, `main.cc`の8行目の`R"( ... )"`はC++11からのRaw String Literal[^5]と呼ばれるものです.

[^5]: [C++11: Syntax and Feature - 2.8.4.3 生文字列リテラル（Raw String Literal）](http://ezoeryou.github.io/cpp-book/C++11-Syntax-and-Feature.xhtml#raw.string.literal)

## C++からDOM

`QWebView`の中でJavaScriptを動かすって方法もありますが, あくまで今回のメインはC++です.  
DOM要素を扱う[`QWebElement`](http://doc.qt.io/qt-5/qwebelement.html)を使うことでいろいろできます.  
Sample: [Tosainu / QWebView\_dom.pro](https://gist.github.com/Tosainu/1a678513e0496384de7e)

![dom](https://lh4.googleusercontent.com/-z-xsqRJ1v9M/VMxJY2j0WdI/AAAAAAAAD78/Iml4ERjLxxo/s640/out.opt.gif)

### 要素を取得する

JavaScriptでいう`document.getElementById`等に相当するようなものです.  
例えば`list`クラスのついた`<ul>`を取得するにはこんな感じに書きます.

```cpp
auto list = webview->page()->mainFrame()->findFirstElement("ul.list");
```

そのリストの最初の子要素を取得するならこんな感じ.

```cpp
auto item = webview->page()->mainFrame()->findFirstElement("ul.list li");
```

### 要素を挿入する

取得した要素に新しい要素を追加してみます.  
以下のようなHTMLで, (a)の位置に挿入するには`QWebElement::prependInside()`, (b)の位置に挿入するには`QWebElement::appendInside()`を使います.

```html
<ul class="list">
  <!-- (a) -->
  <li>もともと存在する要素</li>
  <!-- (b) -->
</ul>
```

```cpp
auto list = webview->page()->mainFrame()->findFirstElement("ul.list");
list.prependInside("<li>" + QTime::currentTime().toString() + "</li>");
list.appendInside("<li>" + QTime::currentTime().toString() + "</li>");
```

ここで注意したいのが, `QWebFrame::findFirstElement()`が返す値はポインタではないということです.  
周りと同じようにアロー演算子(`->`)を使ったりするとビルドできません.

### 取得した要素を削除する

取得した要素を削除するには`QWebElement::removeFromDocument()`を使います.

```cpp
auto item = webview->page()->mainFrame()->findFirstElement("ul.list li");
item.removeFromDocument();
```

### クラスを追加/削除する

要素のクラスを追加するには`QWebElement::addClass()`, 削除するには`QWebElement::removeClass()`を使います. そのままですね.

```cpp
auto list = webview->page()->mainFrame()->findFirstElement("ul.list");
list.addClass("hide");
list.removeClass("hide");
```

## Signal/Slot

QtといったらSignal/Slotでしょう.  
`QWebFrame::addToJavaScriptWindowObject()`の力を借りながら`QWebView`内のHTMLとC++のコードを繋いでみます.

### HTML -> C++

表示しているHTMLから`QObject`を継承した`JsObj`クラスのSlotである`hogeSlot()`を呼び出してみます.  
Sample: [Tosainu / QWebView\_html-to-cpp.pro](https://gist.github.com/Tosainu/24f9fd66dc28c987f836)

```cpp
auto jo = new JsObj();
webview->page()->mainFrame()->addToJavaScriptWindowObject("jsobj", jo);
```

このように記述すると, `jo`が`jsobj`という名前のJavaScript contextとしてページに放り込まれます.  
例えばページ内の`<button>`から`hogeSlot()`を呼び出すには, `onclick=""`にこのように記述してやります.

```html
<button onclick="jsobj.hogeSlot();">Click!</button>
```

上に挙げたサンプルプログラムでは, ページに配置されたClick!ボタンをクリックすると, こんな感じで**QMessageBox::information()**が表示されたと思います.  
![htmlc++](https://lh3.googleusercontent.com/-gE9dr4NqFHA/VLtwvQVOCFI/AAAAAAAAD6c/LjOpaxnFiqg/s800/out.opt.gif)

### C++ -> HTML(JavaScript)

今度はその逆, C++上のSignalが発火したら`QWebView`内のJavaScript関数が実行されるようにしてみます.  
Sample: [Tosainu / QWebView\_cpp-to-html.pro](https://gist.github.com/Tosainu/bd4dfae31c0af3c8a8ef)

同様に`jsobj`を追加したうえで, このような文法でJavaScriptの関数`fugaSlot`をC++上の`hogeSignal`にconnectします.

```javascript
var fugaSlot = function() {
  location.href = 'http://myon.info/';
};

jsobj.hogeSignal.connect(fugaSlot);
```

サンプルプログラムでは, 下部のQPushButtonをクリックすると`hogeSignal`が発火するようにしてありますので, ボタンをクリックすると<http://myon.info/>に飛んだと思います.  
![c++html](https://lh6.googleusercontent.com/-yjxBsii2Yvo/VLtyAQz9A3I/AAAAAAAAD6s/gnZRxYhRad8/s640/out.opt.gif)

### 値の受け渡し

関数が相互に呼び出せるようになったので, 今度は値のやり取りをしてみます.  
Sample: [Tosainu / QWebView\_exchange-value.pro](https://gist.github.com/Tosainu/b6180de2eb852fc7eea8)

![exchangeval](https://lh5.googleusercontent.com/-A2EcEJnZILw/VLtlex-Wi0I/AAAAAAAAD6I/SJWeIlNzDpU/s800/out.opt.gif)

やり取りする相手がJavaScriptですが, なにか特別な書き方が必要というわけではありません.  
サンプルでは文字列の受け渡ししかしていませんが, [The Qt WebKit Bridge | Qt 5.4](http://doc.qt.io/qt-5/qtwebkit-bridge.html)によると以下のような型が扱えると紹介されています. <del>(面倒で全て試せてない)</del>

| 形式 | Qtでの型 |
| ---- | ---------------- |
| 数値 | int, short, float, double等 |
| 文字列 | QString |
| 日付/時刻 | QDate, QTime, QDateTime |
| 正規表現 | QRegExp |
| 配列 | QVariantList, QStringList, QObjectList, QList等 |
| JSON |  QVariantMap等 |
| その他 | QVariant, QObject, QWidget, QImage, QPixmap等 |

またSignal/SlotのOverloadも可能なほか, 以下のように呼び出すSlotを直接指定して呼び出すこともできるようです.  
`QString`を受け取るSlotに数値を渡したところ綺麗に変換(`std::stoi()`みたいな)されたのはおもしろかったです.

```javascript
myQObject['myOverloadedSlot(int)']("10");
myQObject['myOverloadedSlot(QString)'](10);
```

## まとめ

僕と似たような意見を持っている方を見つけたのでリンクを貼っておきます.  
[Why all GUI toolkits suck? - C++ Forum](http://www.cplusplus.com/forum/lounge/140601/)

とりあえず, 当分の間QtってるC++書きたくない.
