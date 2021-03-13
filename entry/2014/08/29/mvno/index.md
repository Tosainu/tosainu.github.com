---
title: MVNOなSIMを入手した結果Androidアプリを書くことに
date: 2014-08-29 19:46:00+0900
noindex: true
tags: Xperia2011, Xperia arc, Android
---

みょん.

タイトル通り, 今までのWiMAXの代わりとしてBIGLOBEのデータ通信3G/LTESIMを契約しました.  
いろいろ迷いましたが, 数年前のように外出先で数十GBのデータをやり取りする機会も無くなりましたし大丈夫かなと思っています.

手続きをしたのは7月末でしたが, 旅行とお盆休み, そして書類の不備等があって時間がかかりましたが, 何とか夏休み中に届いてよかったなぁって感じです.  
![sim](https://lh4.googleusercontent.com/-cF_mC9cKXnE/VABcwc4KbxI/AAAAAAAADfI/tq__3yiD6dE/s640/IMG_2487.JPG)

<!--more-->

## とりあえず

何気にLTE対応nanoSIMにしました(LTE, nanoSIM共に対応端末持ってないくせに).  
まぁいずれLTE対応端末が欲しいなぁと思っているのでこうしました. ちなみに同社には200yen/monthの3G専用SIM等もあります.

ということで, 別で購入していたSIMアダプタを使いXperiaRayに挿してみたところ問題なく認識しました.  
![simad](https://lh4.googleusercontent.com/-XowjomdU8ds/VABd48NMtYI/AAAAAAAADfU/lHqlmlguDAk/s640/IMG_2489.JPG)  
![rai](https://lh6.googleusercontent.com/-2sff1eGkM2o/VABeHLwtMVI/AAAAAAAADfk/s9p9tCi7ZIc/s640/IMG_2488.JPG)

## でもSoftBank SIMも使えないと困るよね

しかし, 僕は諸事情で別でSoftBankの銀SIMを使っています. 
電話なんて滅多に掛けませんし掛かってきませんが, 無いなら無いで面倒なので仕方がないです.

そういえばタッチパネルが逝ったArcがあったなぁ.... ん???  
**Arcをモバイルルータ化すればよくね???**

ってことで.

<blockquote class="twitter-tweet tw-align-center" data-partner="tweetdeck"><p>タッチパネルが逝って操作できなくなったXperiaArcにデータ通信用SIMを差すじゃろ？ <a href="http://t.co/jKkIvMk3Yr">pic.twitter.com/jKkIvMk3Yr</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/statuses/505217971577307137">August 29, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet tw-align-center" data-partner="tweetdeck"><p>キーボードとマウスで操作して・・・ <a href="http://t.co/SYd46CPaEW">pic.twitter.com/SYd46CPaEW</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/statuses/505218103412670464">August 29, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet tw-align-center" data-partner="tweetdeck"><p>こうじゃ <a href="http://t.co/Vo5gTzf7YP">pic.twitter.com/Vo5gTzf7YP</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/statuses/505218191119773697">August 29, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

こんな感じで問題なくテザリングできました. 便利ですね.  
![tether](https://lh4.googleusercontent.com/-3BIocgWu-n0/VABfWRqCz-I/AAAAAAAADgU/9NElvZgB0BQ/s640/IMG_2506.JPG)

速度を実際に測ったわけではありませんが, 思ったよりは快適な感じです.  
自宅無線LANと大差ないかもしれない(´･\_･`)

ちなみに, ROMはLegacyXperiaのCM10.2を利用しました.  
軽量だということからCM7.2も検討したのですが, Androidが標準で搭載してきたData usageが使いたかったのと, 最近のアプリ対応状況などからこうしました.  
また, バックグラウンドでの通信を最小限にしたいことなどからGoogle Playを始めとするgappsも入れず, ネットワーク関係のプリインを片っ端から無効化してこんな感じにしました.  
![arc](https://lh5.googleusercontent.com/-7aVzSNHWZNk/VABfZwpBL4I/AAAAAAAADgg/5ulz7A4h1Do/s640/IMG_2520.JPG)

## でもでもタッチパネル逝った携帯をどうやって使うのさ?

とはいえキーボードとマウスがないと操作できないルーターは不便すぎますね.  
ってことでXperia2011の物理ボタンを有効活用できる感じのテザリングON/OFFアプリがないかな〜と探したのですがいい感じのものは見当たらず...

仕方がないので**簡単なAndroidアプリ**を書くことにしました.

[Tosainu / ToggleTether — Bitbucket](https://bitbucket.org/Tosainu/toggletether)  
[toggleTether-release.apk](https://bitbucket.org/Tosainu/toggletether/downloads/toggleTether-release.apk)

起動するとWifiテザリングが有効か無効かを確認し, 有効だったら無効に, 無効だったら有効にするだけのアプリです.  
Homeアプリの設定で "メニューボタン長押し" でこれが起動するようにすると幸せになれました.

また, タッチパネルが逝ってるせいで画面ロックも解除できないので横のカメラボタンで解除できるように設定したほか, ホームボタンでData usageが表示されるように設定しました.

## 初Androidアプリでハマったこととか

### IDE使いたくない!

これからガツガツAndroidアプリ書くわけでもないのに, EclipseInstallBattleだとか言われるような(多分)巨大なIDEを入れるのは何ともめんどくさいです. (今の流行はAndroidStudioかな?)

とはいえAndroidアプリ開発に外部のIDEは必須ではなく, コマンドラインから一発でプロジェクトが作成できるようです.

```
$ android create project -n ProjectName \
    -t TargetID \
    -p ./ProjectDirectory \
    -k packageName \
    -a DefaultActivityName
```

TargetIDにはAPI Levelを入れるのかな〜と思ったのですがそうではなく, `$ android list targets`で表示される中から選ぶみたいです.

アプリのビルドには`ant`コマンドを使います. makeみたいな感じですね. Arch Linuxでは`apache-ant`パッケージです.

```
// デバッグ用
$ ant debug

// リリース用
$ ant release
```

### 変数宣言時に必ず初期化しないといけない?

こんな感じのコードを書くと...

```java
import android.widget.Toast;

String s;

s = "みょーん";

Toast.makeText(this, s, Toast.LENGTH_LONG).show();
```

怒られます.

```
-compile:
    [javac] Compiling 1 source file to /hoge/fuga/bin/classes
    [javac] /hoge/fuga/src/info/myon/toggleTether/Main.java:7: error: variable s might not have been initialized
    [javac]     Toast.makeText(this, s, Toast.LENGTH_LONG).show();
    [javac]                          ^
    [javac] 1 error

BUILD FAILED
```

`String s = "みょーん";`みたいに宣言時に初期化しないといけないみたい(たぶん)

### Activity Lifecycle

Activityには幾つかの状態があって, それぞれの状態に合わせて`onCreate(Bundle savedInstanceState)`だとか`onResume()`だとかのメソッドが呼び出されるらしい.

最初, 作成されたテンプレートに合わせて`onCreate()`にいろいろ命令を書いていたのだが, アプリの最初の起動ではうまく動作するものの2回目以降はうまく動作しなかった.

それもそのはず, `onCreate()`は**Activityが開始された時に呼び出される**メソッドである.  
そして, Androidアプリは大抵の場合閉じてもすぐに終了されないので, 2回目以降は`onCreate()`が呼び出されること無く最後に起動した時の状態が復元されてしまう.

ということで, Activityが再開した時にも呼び出される`onResume()`メソッドをオーバーライドしてこのように記述した.

```java
public class Main extends Activity {
  @Override
  public void onResume() {
    // なんか処理

    this.finish();
  }
}
```

### 権限の追加

`AndroidManifest.xml`に,

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
  package="info.myon.toggleTether"
  android:versionCode="1"
  android:versionName="1.0">

  <!-- こんな感じに -->
  <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
  <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" /> 
  <uses-permission android:name="android.permission.WRITE_SETTINGS" />
```

## 参考にしたサイト等

* [Activity | Android Developers](http://developer.android.com/reference/android/app/Activity.html)
* [テザリング - WifiManagerメモ - Qiita](http://qiita.com/ki_siro/items/a45c27ee3cb204487b85)
* [ITメモ: Android テザリング設定アプリを作る](http://yokoitm.blogspot.jp/2013/01/android_30.html)
* [\[Android\]Activityを非表示にする | DevAchieve](http://wada811.blogspot.com/2012/07/androidactivity.html)
* [アクティビティ、アプリの終了方法 - 戌印-INUJIRUSHI- （Androidあれこれ） -](http://inujirushi123.blog.fc2.com/blog-entry-29.html)
* [トースト(Toast)を使用するには - 逆引きAndroid入門](http://www.adakoda.com/android/000086.html)
* [OSX - Eclipseを使わないAndroidアプリ開発 - Qiita](http://qiita.com/haburibe/items/e7280a5dfff1594125a3)
* [Androidアプリの署名をantでやってみる - Labo Memo](http://alice345.hatenablog.com/entry/2013/09/20/142004)

わかりやすい解説をありがとうございました.  
AndroidアプリどころかJavaすら書いたことない僕ですがなんとかなりました.
