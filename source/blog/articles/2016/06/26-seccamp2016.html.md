---
title: セキュリティ・キャンプ全国大会2016 に参加します
date: 2016-06-26 01:34 JST
tags:
---

ちゃんとした報告が遅れましたが, 今年のセキュリティキャンプに受講生として参加することになりました.

3年前, Twitterを始めてすぐに知ったセキュキャン. 翌年応募をしようとするも, 課題を全く埋めることができなかったときの悔しさは今も忘れません. 他にも要因はありましたが, こうして痛感した同年代の方々との大きな差を少しでも埋めるべく, 学校で学んでいることと全く違う分野ですがここまで来ることができました.  
セキュキャンはもうダメかなとも思っていたので, とても嬉しいです.

もちろん選考に受かることだけが目的ではないので, 悔いのない最高の夏にできるよう, これからも更に頑張っていきたいと思います.  
よろしくお願いします!!!

READMORE

## 応募用紙

自己紹介的なのを兼ねて応募用紙を公開します.  
本文は一部修正を入れてGistに上げたので, こっちでは各設問の補足や感想を書いていきたいと思います.  
<https://gist.github.com/Tosainu/293f167cde1a67ea7e0c18eed975d11c>

### 共通問題1

制作物を自慢しまくれという問題. 自慢しろということなので良いところだけを書いた.  
正直に言えばtwitppはBoost.Asioをちゃんと扱えていないし, ラジコンもJavaScriptを全く知らない人間が書いたものなのでソースコードは人に見せられるものではないし...

書けそうな制作物を挙げていたら, 2015年は何も外部に公開できるようなことをしていないことに気づいた. 今年はもう少し何か公開できるものの製作にも力を入れたい.

### 共通問題2

印象に残っている技術的な壁を記述する問題. 技術的かは微妙だが, twitppの制作過程に触れながら, 2013年後半からのプログラミング学習について書いた.

本文に書いたように, これが始めて自分の書いたプログラムから投稿したTweetだったと思う.  
たしか当時はまだたくさんバグがあって, 本文にスペース入れると失敗することが多かったことから本文は半角英字で単語区切りが大文字になっている. (すごく懐かしい)
<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">ThisTweetWasPostedFromTosainusProgram.</p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/405343973524250625">November 26, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

### 共通問題3

セキュキャンで興味のある講義とやりたいことを記述する問題. (2)で挙げたように, 僕がセキュキャンを知ったときに一番興味を持ったのが低レイヤートラックの講義なので, キャンプを期に低レイヤーの世界に入門したいですと書いた.

### 選択問題4

**ひと目で尋常でない問題だと見抜いたよ**

解かなきゃいけないという使命感と, 最近書いたC++コードが無いなぁってことで選択.  
問題の趣旨的にはセキュリティやパフォーマンスを意識すべきだよなぁとか, これBEな環境で動かしたらどうなるんだろうとは思っていたけどあまり試せなかったのが反省点.

小文字大文字が混ざっていてもマッチさせるで, **あー, これ[Boost String Algorithms](http://www.boost.org/doc/libs/1_61_0/doc/html/string_algo.html)っぽいなー** と思ってしまったので遠慮なく[`equals()`](http://www.boost.org/doc/libs/1_61_0/doc/html/boost/algorithm/equals.html), [`iequals()`](http://www.boost.org/doc/libs/1_61_0/doc/html/boost/algorithm/iequals.html)を使った.

また, Cond5, Cond6を見て, **あー, なんか\<algorithm\>っぽいなー** と思って調べたら確かにそれっぽいのがあったので早速利用.  
[std::all\_of, std::any\_of, std::none\_of - cppreference.com](http://en.cppreference.com/w/cpp/algorithm/all_any_none_of)

```cpp
// cond. 6: Dataに下記の文字列を厳密に含まない
const static std::string invalid_order_brand[] = {
  "DandySoda",
  "FrozenEvergreen"
};

auto cond6 = std::none_of(
  // invalid_order_brandの全要素に対して
  std::begin(invalid_order_brand), std::end(invalid_order_brand),
  // 次のlambdaを評価
  [&packet](auto& s) {
    // dataからsをfind
    return packet.data.find(s) != std::string::npos;
  }
);  // どれか1つでもtrue(invalid_order_brandの文字列を含んでいた)だったらfalse

// cond. 5:  Dataに下記の文字列を厳密に含む
const static std::string valid_order_brand[] = {
  "BlueMountain",
  "Columbia",
  "OriginalBlend"
};

auto cond5 = std::any_of(
  // valid_order_brandの全要素に対して
  std::begin(valid_order_brand), std::end(valid_order_brand),
  // 次のlambdaを評価
 [&packet](auto& s) {
    // dataからsをfind
   return packet.data.find(s) != std::string::npos;
  }
);  // どれか1つでもtrue(valid_order_brandの文字列を含んでいた)だったらtrue
```

こういう変なカンがついてきたのは成長ってことでいいのだろうか...

あとは, 最近のプログラムならテストコードは必須だよねってことで, [Boost.Test](http://www.boost.org/doc/libs/1_61_0/libs/test/doc/html/index.html)を使ったテストを添付した.  
190行目のテストケース,

```cpp
packet_t p5{{'R', 'H'}, "nise-cocoa-san", "chino-chan", 13, "OriginalBlend"};
BOOST_TEST(!check(p5));
```

**nise-cocoa-san**. 今見るとすごいじわじわくる...

### 選択問題3

PCの電源を入れてから任意のプログラムを実行するまでのストーリーを考える問題. 考えてくださいということなので, 詳しく調べること無く今ある知識だけで書いた.

### 選択問題10

問題文中のプログラムをホストと仮想マシン上で実行したときの結果を考察する問題. インラインアセンブリをしっかり見るのは始めてで, 興味を持ったので選択.

**Virtual PCで動くLinuxディストリ探すのが大変だった**.  
VPC氏, ゲストは32bitしか対応していない上に, Arch Linux含めて最新のLinuxのインストーラはどれもちゃんとBootしてくれない. CentOS7, Ubuntu 12.04/14.04/16.04, Scientific Linux 6.4等も試したけどどれもダメ.  
Ubuntu 10.04あたりがBootしている報告があったが, そういえばUbuntuのLive CDってコンパイラ入ってたっけ...  
いろいろ試した末, 理研のFTPで拾ったKNOPPIX V6.0で検証を行った.  

### 選択問題8

初めに書いておくと, **僕が提出した回答は多分間違っている**.

選択問題10でインラインアセンブリを多少扱えるようになったので, ちょっと頑張ってみた. x86(\_64)のアセンブリは初めてだが, PICとAVRのアセンブリの経験があったので, 同じようにマニュアルを読みながら進めることができた.

後から調べてわかったが, これはReturn-oriented programming **(ROP)**という手法によって書かれたもので, プログラム中の小さなコードの断片に`ret`で飛びまくることで目的の動作をさせる手法だそうだ. これを悪用し, WindowsのDEPなどのセキュリティ機能を回避して不正なプログラムを動かす攻撃を**ROP攻撃**と呼んだりするらしい. 解いている時は読みにくいプログラムだな~程度にしか思っていなかったが, 思った以上に深くてすごく勉強になった.

また, [@ki6o4さんの記事](https://kimiyuki.net/blog/2016/06/16/security-camp-application-form-writeup/)で[qira](http://qira.me/)というツールが紹介されていた. ものすごく便利そう.
