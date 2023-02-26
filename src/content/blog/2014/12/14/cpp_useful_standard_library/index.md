---
title: 最近見つけたC++の便利な標準ライブラリいろいろ
date: 2014-12-14 19:10:00+0900
tags:
  - C++
---

みょん.

最近流行りの言語とかはあんなことも簡単にできるのか〜とか時々思ってしまうのですが, 実はC++の標準ライブラリにも結構便利な関数やクラスがいっぱい揃っているようです.  
今日は, 僕が最近見つけたC++の標準ライブラリの便利な奴らいろいろを紹介したいと思います.

※ 以下のコードはgcc-4.9.2とclang-3.5.0で動作確認しました. ｳﾞｨｽﾞｱﾙｺﾝﾊﾟｲﾗとかは知りません.

<!--more-->

## [std::stoi()](http://en.cppreference.com/w/cpp/string/basic_string/stol)

名前から察せるように, 文字列を数値に変換できる関数です. `#include <string>`すると使えるようになります.

```cpp
std::string s("10");
int x = std::stoi(s);

std::cout << x << std::endl; // 10
```

しかしこの関数, これだけじゃありません. この関数は以下のように定義されており,

```cpp
int stoi(const std::string& str, std::size_t* pos = 0, int base = 10);
```

このように書くことで, 8進数や16進数の文字列を数値に変換することもできてしまいます!!!

```cpp
std::string oct("17");
int x = std::stoi(oct, nullptr, 8);
std::cout << x << std::endl; // 15

std::string hex("2a");
int y = std::stoi(hex, nullptr, 16);
std::cout << y << std::endl; // 42
```

これに関係する関数に, `long`に変換する`stol()`や`double`に変換する`stod()`などがあるようです.

## [std::isalnum()](http://en.cppreference.com/w/cpp/locale/isalnum)

引数に与えた文字がアルファベットか数字の時に`true`を返してくれる関数です. `cctype`や`locale`に定義されているようですが, `iostream`等をincludeすると一緒に読み込まれたりします.

この関数のおかげで, [某プログラム](https://github.com/Tosainu/twitpp/blob/3b5069e328452917ea0153c9dd12fd86358e462f/util/util.cc#L66-L80)のパーセントエンコーディングする部分が簡単に書けるようになりました.

```cpp
std::string url_encode(const std::string& text) {
  std::ostringstream result;
  result.fill('0');
  result << std::hex << std::uppercase;

  for (auto&& c : text) {
    if (std::isalnum(c) || c == '-' || c == '_' || c == '.' || c == '~') {
      result << c;
    } else {
      // ここのキャストもっと綺麗に書けないかな
      result << '%' << std::setw(2) << static_cast<int>(static_cast<unsigned char>(c));
    }
  }

  return result.str();
}
```

## [std::transform()](http://en.cppreference.com/w/cpp/algorithm/transform)

こんなJavaScriptのコードがある.

```javascript
var myon = [1, 2, 3, 4, 5].map(function(n) {
  return n * n;
});

// myon == [1, 4, 9, 16, 25]
```

こんな感じのことをC++でやりたい.

```cpp
std::array<int, 5> arr = {{1, 2, 3, 4, 5}};
std::array<int, 5> myon;

std::transform(arr.begin(), arr.end(), myon.begin(), [](const int& n) {
  return n * n;
});

// myon == [1, 4, 9, 16, 25]
```

文字列をすべて大文字にしたい.

```cpp
std::string s("kokoro pyonpyon machi?");
// std::toupperを呼び出す
std::transform(s.begin(), s.end(), s.begin(), ::toupper);
std::cout << s << std::endl; // KOKORO PYONPYON MACHI?
```

ウェイ.

`#include <algorithm>`すると使える. なまえがかっこいい(小並感)

## まとめ

便利.  
簡単なアルゴリズムとかを自分で書いたりするのは勉強になるけど, 何らかのソフトウェアとかを書くときはこういった標準の便利機能を積極的に使って行きたい.

C++の標準ライブラリは大量の機能があるっぽいけど, 故に目的の機能を探しづらくてアレ.
