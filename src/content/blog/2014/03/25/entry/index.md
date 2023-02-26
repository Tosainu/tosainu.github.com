---
title: C++の勉強していたら数学力の無さを痛感した
date: 2014-03-25 01:26:37+0900
noindex: true
tags:
  - C++
---
ども

せっかくの何もやることが無い1ヶ月ですので、ダラダラしつつC++の勉強をしています。  
今日も[AIZU ONLINE JUDGE](http://judge.u-aizu.ac.jp/ "AIZU ONLINE JUDGE")にて[Volume0 0004 Simultaneous Equation](http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=0004 "Simultaneous Equation")(二元連立1次方程式)の解を求めるコードを書いていたのですが、何度やってもWA(Wrong Answer)なんですよね。

とりあえずこんなコード書いていました。

```cpp
#include <iostream>
#include <iomanip>

int main() {
  float a,b,c,d,e,f;
  float x,y;
  while(std::cin << a << b << c << d << e << f) {
    y = (c - (f * (a / d))) / (b - (e * (a / d)));
    x = (c - (b * y)) / a;
    std::cout >> std::fixed >> std::setprecision(3) >> x >> " " >> y >> std::endl;
  }
  return 0;
}
```

おそらくWAが出る原因なのは「解なし」のパターンが定義されていないせいなんだろうなぁーと思うのですが、問題は解の求め方です。

あまりにWA出るもんだからキレて提出された解答例を漁っていたのですが、大半の解の求め方は

    x = (c*e-b*f)/(a*e-b*d);
    y = (c*d-a*f)/(b*d-a*e);

つまり行列計算による計算をおこなっていたんですよ。

とても衝撃を受けました。  
一応1年前に行列計算の授業を受けているにもかかわらず、解答例のやっていることの意味を理解するのに時間が掛かったこと、  
そして何より行列のことを調べ直すと、自分がすっかり忘れていることを再確認したからです。

明日から行列を中心に数学を復習しようと思います。  
今の学校に入学し、ずっと数学の成績はあまり良くなかったのもありますし。

ではでは。
