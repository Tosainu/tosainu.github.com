---
title: C++でパーセントエンコーディング
date: 2013-11-23 23:11:46 JST
tags: Programming,C++
---
どもどもー

&nbsp;

現在作ってるプログラムで、どうしても文字列のパーセントエンコーディングが必要なんですよね。

たくさんサンプルは公開されてますが、納得いく挙動のものが無かったので自分で書きました。

というか、そんなに難しくなかった。

&nbsp;

僕が欲しいパーセントエンコーディングの関数は、phpのrawurlencode関数と同じ動作をするものです。

* 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-\_.~は変換しない
* 変換した文字は16進数（アルファベットは大文字）に
* string型で突っ込んでstring型で返す

こんな感じに書きました。

&nbsp;

```cpp
#include <string>
#include <sstream>

std::string rawurlencode(const std::string&amp; text) {
  const std::string charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_.~";
  std::ostringstream result;

  for(int i = 0; i < (int)text.size(); i++) {
    if((charset.find(text[i])) == std::string::npos) {
      result.setf(std::ios::hex, std::ios::basefield);
      result.setf(std::ios::uppercase);
      result << '%' << ((int)text[i]);
    }
    else {
      result << text[i];
    }
  }
  return result.str();
}
```

&nbsp;

もっと簡単に書けそうですし、なんかおかしいい気もしますが、まぁいいでしょう。

ではでは〜
