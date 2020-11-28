---
title: すごいH本を読み始めた
date: 2015-03-30 00:24:00+0900
tags: Haskell
---

ヾ(❀╹◡╹)ﾉﾞ

数日前から**すごいH本**こと[**すごいHaskellたのしく学ぼう!**](http://www.amazon.co.jp/%E3%81%99%E3%81%94%E3%81%84Haskell%E3%81%9F%E3%81%AE%E3%81%97%E3%81%8F%E5%AD%A6%E3%81%BC%E3%81%86-Miran-Lipova%C4%8Da/dp/4274068854/)を読み始めました.  
以前から読んでみたいなと思っており, 学校図書館にお願いしてみたところ入れてもらえました. ありがたい.

<blockquote class="twitter-tweet tw-align-center" lang="en"><p>学校図書館の新刊情報です <a href="http://t.co/sYBUo1aBkq">pic.twitter.com/sYBUo1aBkq</a></p>&mdash; とさいぬ (@myon\_\_\_) <a href="https://twitter.com/myon___/status/532708548568834049">November 13, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

以来3ヶ月以上この本を借りていた[^1]のですが, 学校の勉強が忙しかったり, 複数のプログラミング言語に手を出すのはアレだよなぁと思いながら結局1ページも読んでいませんでした.  
しかし, 春休み後半に入り, [こういう問題のうまい解決案](http://isocpp.org/wiki/faq/templates#templates-defn-vs-decl)の模索に嫌気が[^2]差して\_(:3 」∠)\_していたため, 気分転換にと読み始めました.

[^1]: 延滞ではなく延長です
[^2]: 半月くらいundefined reference to ~ とかmultiple definition of ~ といったLinker errorばかりに遭遇していたもんで..... 原因は単純なんだけどなぁ

<!--more-->

## "すごいHaskell楽しく学ぼう!" の感想

現時点でまだ5章までしか読めていないのですが, それでもこの本は**とてもわかりやすく**, 何より**楽しい**と断言できます.

というのも, 僕がHaskellに手を出すのはこれが初めてではなく, 2013年秋のプログラミング言語の選択に迷っていた時期から何度かHaskell本を読んでは諦めていました.  
例えばその時読んだ本の一つである[Real World Haskell―実戦で学ぶ関数型言語プログラミング](http://www.oreilly.co.jp/books/9784873114231/)は "3章-型を定義し、関数を単純化する" あたり(だったと思う)からの急なレベルの上昇に挫折, [Software Design 2010年6月号](http://gihyo.jp/magazine/SD/archive/2010/201006)の関数型言語特集はHaskellに対する興味を高めることができたものの, 言語の入門としては情報不足でした.

それに対しこの本は, イントロダクションの**GHCi[^3]の使い方**に始まり, 1章の**関数の定義, リスト, タプル**, 2章の**型**, 3章の**リスト/タプルのパターンマッチ**や**ガード式等**, 4章の**再帰関数**, そして5章の**高階関数**といったように, **Haskellにとっての基本的なこと**から(訳者序文の言葉で)**ファンシーなイラストと共に軽妙な語り口で**解説しており, **非常にわかりやすく**, 何より**読んでいて楽しい**のです.

[^3]: Haskellのインタプリタ

本当に今まで読んだHaskell本とは全く違いました. 今は図書館で借りていますが, いずれは**My H本**を入手せねばなと思っています.

## "Haskell" に対しての感想

いやぁ, **Haskell強い!** 想像を超える強さがこの言語にはありました.  
いわゆる**一目惚れ**ってやつです. 元々C++を勉強していたことをふまえると浮気みたいな感じですが...

とりあえず, **この数日で勉強した中から**強いなと思ったものをいくつか挙げてみます.

### 文法的な面

とてもシンプルで, 普段書いているC++と比べると**打ちやすい**言語だと思います.  
例えば, 数値を1つ受け取ってその2倍を返す関数`twice`をC++14で書くとこんな感じになりますが,

```cpp
template <typename T>
constexpr auto twice(T x) {
  return x * 2;
}
```

Haskellではこう

```haskell
twice :: (Num a) => a -> a
twice x = x * 2
```

また, **カリー化**の考え方を使えば

```haskell
twice :: (Num a) => a -> a
twice = (*2)
```

みたいに書けるらしいです.

あのラムダ式も...

```cpp
[](auto x, auto y) {
  return x + y;
}
```

```haskell
\x y -> x + y
```

めっちょシンプル.

単に打ち込む文字数が少ないだけでなく, `()`や`{}`といった一般的なキーボードで**Shift + □**のようにしないと打ち込めない文字列が少なくて済むのも気に入りました.

### リスト

リストは同じ型の要素を複数格納するデータ構造, 普段使っている言葉だと配列みたいなものでしょうか.  
文法としてはこんな感じ.

```haskell
[1, 2, 3, 4, 5, 6, 7, 8, 9]

["foo", "bar", "baz", "qux"]
```

本当にすごいのはここからで, 例えば列挙できる要素の組み合わせでリストを作る**レンジ**

```haskell
[1..5] -- => [1,2,3,4,5]

[1,3..19] -- => [1,3,5,7,9,11,13,15,17,19]

['A'..'Z'] -- => "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
```

Haskellの**遅延評価**を活かした**無限リスト**

```haskell
-- take は先頭からn個分の要素のリストを返す関数

take 3 [1..] -- => [1,2,3]
```

ある集合から別の集合を作る**リスト内包表記**

```haskell
take 10 [x * 2| x <- [1..]] -- => [2,4,6,8,10,12,14,16,18,20]

take 10 [x | x <- [1..], x `mod` 3 == 0] -- => [3,6,9,12,15,18,21,24,27,30]
```

とにかく強い.

### ガード

3の倍数が渡されたら`Fizz`, 5の倍数が渡されたら`Buzz`, 3と5の公倍数が渡されたら`FizzBuzz`を返す, いわゆるFizzBuzzっぽいことをする関数を, C++でもおなじみな`if`を使って書いてみる.

```haskell
fizz x = if x `mod` 15 == 0
           then "FizzBuzz"
           else
             if x `mod` 3 == 0
               then "Fizz"
               else
                 if x `mod` 5 == 0
                   then "Buzz"
                   else show (x)
```

うーん...

でもこれを, **ガード**を使って書きなおしてみる.

```haskell
fizz x
  | x `mod` 15  == 0  = "FizzBuzz"
  | x `mod`  3  == 0  = "Fizz"
  | x `mod`  5  == 0  = "Buzz"
  | otherwise         = show (x)
```

めっちょCool.

## ∩(＞◡＜\*)∩

まだすごいところはいっぱいあるけど, 今回はこの辺で.  
ではではー.