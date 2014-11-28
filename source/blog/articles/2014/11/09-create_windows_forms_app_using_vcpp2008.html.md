---
title: VC++2008でWindows Forms Applicationを作った
date: 2014-11-09 13:45 JST
tags: Programming, C++
---

どーも.

僕の通っている学校では, 幾つかの実験科目があります.  
今年の後学期から僕のクラスで始まった電気/電子工学実験では, 3ジャンル12タイトルの実験を班ごとに週替わりでやっていきます.

先週, 僕の班では**第12章 Visual C++の基礎**という, 嫌な予感しかしないタイトルの実験(というか実習)をやりました.  
今回はその内容と僕なりの補足, 意見を書いていこうと思います.

## -- WARNING -- WARNING -- WARNING --

この記事には**多大のVisual C++成分**が含まれます.  
耐性のない方はブラウザを閉じることをおすすめします.

## 主な演習内容

* 与えられる開発環境は**Visual C++ 2008 Express Edition**
* 演習0: 新規プロジェクトの作成
* 演習1: FormにButtonを配置してMessageBox
* 演習2: TextBoxとComboBoxを用いた簡易電卓の作成
* 演習3: FormにButtonを16個配置して電卓の作成
* 課題: オブジェクト指向プログラムをクラスとカプセル化の単語をふまえて説明せよ
* 実験テキストの参考文献: 3週間完全マスター **Visual C++ 6.0** 等

尚, 以下に掲示するソースコードは出来る限り実験テキストのコードに従ったものです.  
(変数名, アルゴリズム等)

READMORE

## 演習0: 新規プロジェクトの作成

まぁ遅いったらありゃしない.  
VC++2008の初回起動でいろいろ待たされるわ新規プロジェクトの作成には3分近くかかるわで実験開始からｷﾚｿｳでした.

PCのスペックに文句をいうのは趣味ではないので控えますが, いくら何でもこれは......  
VS系ってこんなに起動遅かったっけ.......?

## 演習1: FormにButtonを配置してMessageBox

MessageBoxに表示させる文字列に特別な指定はなかったので, 演習0のストレスから手が滑ってこんなコードを書きました.

![1](https://lh5.googleusercontent.com/-ADEup-Yj46E/VF7dHdRZyQI/AAAAAAAADoA/kDf085_PHhs/s800/1.png)

```cpp
private: System::Void button1_Click(System::Object^  sender, System::EventArgs^  e) {
       MessageBox::Show("F*ck! Visual C++.");
     }
private: System::Void button2_Click(System::Object^  sender, System::EventArgs^  e) {
       MessageBox::Show("Bye");
       Close();
     }
private: System::Void button3_Click(System::Object^  sender, System::EventArgs^  e) {
       MessageBox::Show("Hello");
     }
```

気になったのですが, VC++って何かしらのイベントハンドラが作成されるごとに関数名の最初に`private:`がつくんですね.  
おそらくこんな感じに書けると思うのですが.....

```cpp
class myon {
public:
  myon();
  ~myon();

  void foo();

private:
  int bar;
  double hoge;
};
```

しかもこれ, 記述しているのがヘッダファイルなんですよね. 僕的にはヘッダファイルとソースファイルに分けたいところです.

それと, `System::Object^`の`^`って何でしょうか.....初めて見ました.

##  演習2: TextBoxとComboBoxを用いた簡易電卓の作成

2つのTextBoxに値を入力し, 中央のComboBoxで演算方法(+-\*/)を選択して結果をLabelに表示するプログラムです.  
また, 追加課題として三角形の面積とべき乗計算もできるようにもします.

![2](https://lh6.googleusercontent.com/-bEatjyNh-RM/VF7dHch-fJI/AAAAAAAADn8/Y2WsJqiiE3s/s800/2-2.png)

```cpp
// ソースの一番上
#include <cmath>

private: System::Void button1_Click(System::Object^  sender, System::EventArgs^  e) {
       int index = comboBox1->SelectedIndex;
       double a = double::Parse(textBox1->Text);
       double b = double::Parse(textBox2->Text);
       double c;

       switch (index) {
         case 0:
           c = a + b;
           break;
         case 1:
           c = a - b;
           break;
         case 2:
           c = a * b;
           break;
         case 3:
           c = a / b;
           break;
         case 4:
           MessageBox::Show("The area of a triangle");
           c = a * b / 2;
           break;
         case 5:
           c = std::pow(a, b);
           break;
       }

       label2->Text = c.ToString();
     }
```

今までの実験の話を聞いたところによると, `pow()`のために`math.h`をIncludeする的な風潮があったのですが, [C++でCのヘッダファイルを呼び出すのは**Deprecated**](http://en.cppreference.com/w/cpp/header#Deprecated_headers)ですので`cmath`を使いました.  
これらで読み込んだ関数等は`std名前空間`で宣言されているので, `std::pow()`のように使います.

気になったのですが, `double`型の変数に対して`double::Parse`とか`.ToString()`とか.... なんだこれ....

## 演習3: FormにButtonを16個配置して電卓の作成

Form作るのがクッソめんどかった.

![3](https://lh3.googleusercontent.com/-TKexZYpIagY/VF7dIPAwkRI/AAAAAAAADoE/a4SQYT4uHW8/s800/3.png)

たぶん, Button1個設置したらそれをコピーして\<C-v\>連打が楽だと思う.

```cpp
// グローバル変数
int yy, w, z = 0;

private: System::Void button1_Click(System::Object^  sender, System::EventArgs^  e) {
       z *= 10;
       z += 1;
       textBox1->Text = z.ToString();
     }
private: System::Void button2_Click(System::Object^  sender, System::EventArgs^  e) {
       z *= 10;
       z += 2;
       textBox1->Text = z.ToString();
     }
private: System::Void button3_Click(System::Object^  sender, System::EventArgs^  e) {
       z *= 10;
       z += 3;
       textBox1->Text = z.ToString();
     }
private: System::Void button4_Click(System::Object^  sender, System::EventArgs^  e) {
       z *= 10;
       z += 4;
       textBox1->Text = z.ToString();
     }
private: System::Void button5_Click(System::Object^  sender, System::EventArgs^  e) {
       z *= 10;
       z += 5;
       textBox1->Text = z.ToString();
     }
private: System::Void button6_Click(System::Object^  sender, System::EventArgs^  e) {
       z *= 10;
       z += 6;
       textBox1->Text = z.ToString();
     }
private: System::Void button7_Click(System::Object^  sender, System::EventArgs^  e) {
       z *= 10;
       z += 7;
       textBox1->Text = z.ToString();
     }
private: System::Void button8_Click(System::Object^  sender, System::EventArgs^  e) {
       z *= 10;
       z += 8;
       textBox1->Text = z.ToString();
     }
private: System::Void button9_Click(System::Object^  sender, System::EventArgs^  e) {
       z *= 10;
       z += 9;
       textBox1->Text = z.ToString();
     }
private: System::Void button10_Click(System::Object^  sender, System::EventArgs^  e) {
       z *= 10;
       textBox1->Text = z.ToString();
     }
private: System::Void button11_Click(System::Object^  sender, System::EventArgs^  e) {
       yy = 1;
       w = z;
       z = 0;
     }
private: System::Void button12_Click(System::Object^  sender, System::EventArgs^  e) {
       yy = 2;
       w = z;
       z = 0;
     }
private: System::Void button13_Click(System::Object^  sender, System::EventArgs^  e) {
       yy = 3;
       w = z;
       z = 0;
     }
private: System::Void button14_Click(System::Object^  sender, System::EventArgs^  e) {
       yy = 4;
       w = z;
       z = 0;
     }
private: System::Void button15_Click(System::Object^  sender, System::EventArgs^  e) {
       if (yy == 1) textBox1->Text = (w + z).ToString();
       else if (yy == 2) textBox1->Text = (w - z).ToString();
       else if (yy == 3) textBox1->Text = (w * z).ToString();
       else if (yy == 4) textBox1->Text = (static_cast<double>(w) / z).ToString();

       w = 0;
       z = 0;
       yy = 0;
     }
private: System::Void button16_Click(System::Object^  sender, System::EventArgs^  e) {
       z = 0;
       textBox1->Text = L"";
     }
```

（　゜Д゜）

ちなみに, テキストでは`z = 10 * z`といったコードが書いてあったため個人的な気分の問題で`z *= 10`などに書き換えています.  
また, 変数`yy`の値が3の時足し算, 1の時かけ算....といったよくわからないコードだったためある程度変更したり, Cのキャストの部分を`static_cast<>()`にしました.

それにしても, **オブジェクト指向**が云々っていってる授業なんだし, `yy``w``z`をグローバル変数で宣言したのはちょっとなーって感じです. クラスのメンバ変数にしたい.  
それと, 面倒だったし一応プログラミングの授業ではまだ扱っていなかったのもあったのでのでやっていないけど, `yy`に値で状態を表すのは非常にわかりにくいので, `enum`とか使ったらいい気がした.

```cpp
// C++11からのscoped enumeration
enum class math_operator {
  add,
  sub,
  mul,
  div,
};

// かけ算を設定
math_operator op = math_operator::mul;

switch (op) {
  case math_operator::add:
    // 足し算
    break;
  case math_operator::sub:
    // 引き算
    break;
  case math_operator::mul:
    // かけ算
    break;
  case math_operator::div:
    // 割り算
    break;
}
```

## おわり

いろんな意味でVC++使ってWindowsアプリケーション作ってる開発者さんはすごいなーって思いました.
