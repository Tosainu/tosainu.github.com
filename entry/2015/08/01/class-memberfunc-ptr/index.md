---
title: クラスメンバへのポインタ
date: 2015-08-01 21:04:00+0900
tags: C++
---

某所で書いているプログラムで, `std::thread()` にクラスのメンバ関数を渡したいなーってことがあった.  
[std::thread::thread - cppreference.com](http://en.cppreference.com/w/cpp/thread/thread/thread)にもそれっぽい記述がないのでググっていると, どうやらこんな感じにするらしい.

[c++ - Start thread with member function - Stack Overflow](http://stackoverflow.com/questions/10673585/start-thread-with-member-function)

```cpp
#include <iostream>
#include <memory>
#include <thread>

class nyan {
  std::unique_ptr<std::thread> th_;

public:
  void run() {
    th_ = std::make_unique<std::thread>(&nyan::worker, this);
  }

  ~nyan() {
    th_->join();
  }

private:
  void worker() {
    std::cout << "Nyan!!" << std::endl;
  }
};

auto main() -> int {
  nyan n;
  n.run();
}
```

この`&nyan::worker`みたいな記述がサッパリわからなかったので, C++のクラスのメンバ関数のポインタを調べたときのメモ.

READMORE

## 関数ポインタ

そもそもC/C++の関数ポインタについてあまり詳しくなかったので復習してみる.

[C++ポケットリファレンス](http://www.amazon.co.jp/dp/4774157155)の36ページによると,  

```
戻り値の型 (*ポインタ変数名)(仮引数リスト);
```

のように書くらしい.

```cpp
#include <iostream>

template <typename T>
T twice(const T n) {
  return n * 2;
}

auto main() -> int {
  int    (*ti)(int)    = twice<int>;
  double (*td)(double) = twice<double>;

  std::cout ti(12);  << std::endl; // => 24
  std::cout td(3.5); << std::endl; // => 7
}
```

## メンバへのポインタ

じゃあ本題のメンバへのポインタはどう書くかというと, 同ページによれば

```
// メンバ変数
型 クラス名::*ポインタ変数名;

// メンバ関数
戻り値の型 (クラス名::*ポインタ変数名)(仮引数リスト);
```

のように書き, こんな感じに使うらしい.

```cpp
#include <iostream>

struct foo {
  int val_;

  int twice(int n) {
    return n * 2;
  }
};

auto main() -> int {
  int foo::*v = &foo::val_;
  int (foo::*t)(int) = &foo::twice;

  {
    foo f;
    f.*v = (f.*t)(12);

    std::cout << f.*v << std::endl; // 24
  }

  {
    auto f = new foo;
    f->*v = (f->*t)(12);

    std::cout << f->*v << std::endl; // 24

    delete f;
  }
}
```

( ˘⊖˘)ん???

## おわり

最初に書いた`std::thread()`の例みたいに, クラスのメンバを外で使いたい場合は**メンバを指すポインタ**と**オブジェクト**を渡せば良いわけですね.

```cpp
#include <iostream>

struct foo {
  void nyan(const char* str) {
    std::cout << str << std::endl;
  }
};

template <class Func, class Instance, class... Args>
void hoge(Func&& f, Instance&& i, Args&&... args) {
  // (2) 外からmain()のf.nyan()が呼び出せる
  (i->*f)(std::forward<Args>(args)...);
}

auto main() -> int {
  foo f;

  // (1) foo::nyan()へのポインタとオブジェクトを渡してやれば
  hoge(&foo::nyan, &f, "にゃーん");
}
```

うーん, クラスがどういうものかっていうのがよくわかる書き方ではあるなぁと思うけど, かなり特殊だしすぐ忘れそう.....
