---
title: AtCoder Beginner Contest 011に挑戦してた
date: 2014-06-22 02:25:00+0900
noindex: true
tags: C++
---
どーも

暇ってわけではなかったんですが, 昼間segmentation faultばっかり見てて辛かったので, 気分転換も兼ねてAtCoder Beginner Contestに初めて挑戦してみました.

[Welcome to AtCoder Beginner Contest #011 - AtCoder Beginner Contest #011 | AtCoder](http://abc011.contest.atcoder.jp/tasks/abc011_1 "abc011")

## [A - 来月は何月？](http://abc011.contest.atcoder.jp/tasks/abc011_1 "A")

今月の月を表すN (1 <= N <= 12)が標準入力から与えられるので, 来月が何月かを出力する問題.

結果: *AC* <http://abc011.contest.atcoder.jp/submissions/187088>

```cpp
#include <iostream>

int main() {
  int month;
  std::cin >> month;

  if (month < 12) {
    std::cout << month + 1 << std::endl;
  } else {
    std::cout << "1" << std::endl;
  }
}
```

入力された値が12より小さければ+1した値を表示, それ以外の時は1を出力しています.  
予め入力される値の範囲はわかっているので細かい値のチェックは省いています.

## [B - 名前の確認](http://abc011.contest.atcoder.jp/tasks/abc011_2 "B")

小文字と大文字が混ざった名前が入力されるので, 1文字目を大文字, それ以外を小文字に直して出力する問題.

結果: *AC* <http://abc011.contest.atcoder.jp/submissions/187497>

```cpp
#include <iostream>

int main() {
  std::string name;
  std::cin >> name;

  std::string::iterator it = name.begin();

  if (*it >= 'a' && *it <= 'z') {
    *it -= 32;
  }

  ++it;

  for (; it != name.end(); ++it) {
    if (*it >= 'A' && *it <= 'Z') {
      *it += 32;
    }
  }

  std::cout << name << std::endl;
}
```

入力された名前をnameを代入し, そのイテレータitを作成.  
10行目で1文字目が小文字だった場合は大文字に変換, 14行目でイテレータをひとつ進めた後, 残りの文字が大文字だったら小文字に変換して出力しています.

大文字小文字の変換はアスキーコードが云々を利用して+/-32していますが, 解説にもあるように`'a' - 'A'`のようにも書けますね......

## [C - 123引き算](http://abc011.contest.atcoder.jp/tasks/abc011_3 "C")

ルールが少々複雑なのでリンク先参照.

結果: *WA x 3*

* <http://abc011.contest.atcoder.jp/submissions/188033>
* <http://abc011.contest.atcoder.jp/submissions/188142>
* <http://abc011.contest.atcoder.jp/submissions/188189>

```cpp
#include <iostream>

int main() {
  int num;
  int ng1, ng2, ng3;

  std::cin >> num;
  std::cin >> ng1;
  std::cin >> ng2;
  std::cin >> ng3;

  if (num == ng1 || num == ng2 || num == ng3) {
    std::cout << "NO" << std::endl;
    return 0;
  }

  for (int cnt = 100; cnt != 0; --cnt) {
    if (num == 0) {
      break;
    }

    if (((num - 3) != ng1 || (num - 3) != ng2 || (num - 3) != ng3) && ((num - 3) >= 0)) {
      num -= 3;
    } else if (((num - 2) != ng1 || (num - 2) != ng2 || (num - 2) != ng3) && ((num - 2) >= 0)) {
      num -= 2;
    } else if (((num - 1) != ng1 || (num - 1) != ng2 || (num - 1) != ng3) && ((num - 1) >= 0)) {
      num -= 1;
    } else {
      break;
    }
  }

  if (num != 0) {
    std::cout << "NO" << std::endl;
  } else {
    std::cout << "YES" << std::endl;
  }
}
```

うん, 焦りすぎた.  
値や演算子間違えたまま提出しちゃったり, `return 1;`なんて書いちゃったからRuntime Error出てたりするし, そもそも条件式がアレすぎて機能してない部分もあるし.

一旦諦めD問題を考えていたりしたので結局AC取れませんでした.

## [D - 大ジャンプ](http://abc011.contest.atcoder.jp/tasks/abc011_4 "D")

これもルールが少々複雑なのでリンク先参照.

結果: *未提出*

```cpp
#include <iostream>
#include <cmath>

int main() {
  int n;
  int d;
  int x, y;

  std::cin >> n >> d;
  std::cin >> x >> y;

  double myon = std::pow(4, n);

  for (int cnt = n; n > 0; --n) {
}
```

指定されただけの深度を探索する方法が書けなかった. うん, 何となくはわかるんだけどコードが思い浮かばず完全に手が止まってた.  
関数の再帰なりでイケるんだろうけど....？ うーん.  
そういえばこんな感じに探索するプログラムは1度も書いた覚えがないなぁ..........

## まとめ

あるごりずむ力なさすぎる(｡＞﹏＜)

ABCは結構頻繁に行われているようなので次回も挑戦したい.
