---
title: 関数の戻り値が最も小さくなる配列の要素は何番目か
date: 2015-06-13 02:26:00+0900
tags: C++
---

関数`foo()`と何らかの値の入った配列`nyan`があって,

```cpp
double foo(double arg) {
  return std::acos(arg);
}

double nyan[] = {.0, -.1, .3, -.5, .7};
```

`foo(nyan[n])`が最小になるn取得するって感じのコードを某所で見つけた.  
こんな感じ.

```cpp
int result;
double prev = INFINITY;

for (int i = 0; i < 5; i++) {
  if (foo(nyan[i]) < prev) {
    prev = foo(nyan[i]);
    result = i;
  }
}

std::cout << result << std::endl; // = 4
```

別に問題ないんだけれども, とにかくCoolじゃなくて個人的にもにょる...

ってことでこんな感じなのを思いついた. もっとよさ気な書き方があったら教えてくださいー.  
動作確認は`clang++ -Wall -Wextra -std=c++14 prog.cc`でしました.

<!--more-->

## [std::min\_element](http://en.cppreference.com/w/cpp/algorithm/min_element)

これくらい標準ライブラリの何かでパパッとやって終わりそうだなとと思って[\<algorithm\>ヘッダで定義されてる関数一覧](http://en.cppreference.com/w/cpp/header/algorithm)を眺めていたら, 面白そうなのを見つけた.

> #### std::min\_element

> ```cpp
> template< class ForwardIt, class Compare >
> ForwardIt min_element( ForwardIt first, ForwardIt last, Compare comp );
> ```

> ##### Parameters

> **first, last**  -  forward iterators defining the range to examine  
> **cmp**  -  comparison function object (i.e. an object that satisfies the requirements of Compare) which returns true if a is less than b. 

これを使ってみることにした.

```cpp
const auto result_itr = std::min_element(std::cbegin(nyan), std::cend(nyan),
  [](const auto& a, const auto& b) {
    return foo(a) < foo(b);
  });
int result = result_itr - std::cbegin(nyan);

std::cout << result << std::endl;
```

`const`とか`cbegin()`, `cend()`を使わなければもう少し短くなるけれど, 気分的に.

<del>正直Coolになったかは微妙なんだけど</del>, `std::min_element`に関しては複雑な比較もできそうで面白いなと思った.

## 番外編

minがあれば当然maxもある.  
[std::minmax_element - cppreference.com](http://en.cppreference.com/w/cpp/algorithm/minmax_element)

そして, 同じく3番目の引数に関数オブジェクトを渡して動作をカスタムできる.

あれ...? もしかして......

```cpp
#include <algorithm>
#include <array>
#include <iostream>

auto main() -> int {
  std::array<int, 5> a{{2, 6, 1, 9, 4}};

  auto min = std::min_element(a.cbegin(), a.cend(), [](const auto& a, const auto& b) {
    return a > b;
  });

  auto max = std::max_element(a.cbegin(), a.cend(), [](const auto& a, const auto& b) {
    return a > b;
  });

  std::cout << "std::min_element() : " << *min << std::endl;
  std::cout << "std::max_element() : " << *max << std::endl;
}
```

[実行結果](http://melpon.org/wandbox/permlink/0K7o7M5a1C9nS6Wr)

逆転できちゃったよ()
