---
title: 圧電ブザーで『U.N.オーエンは彼女なのか？』のようなものを演奏してみた
date: 2013-08-05 00:30:25 JST
tags: Raspberry Pi
---
<div class="video"><iframe width="312" height="176" src="http://ext.nicovideo.jp/thumb/sm21513905" scrolling="no" style="border:solid 1px #CCC;" frameborder="0"><a href="http://www.nicovideo.jp/watch/sm21513905">【ニコニコ動画】RaspberryPiで『U.N.オーエンは彼女なのか？』を演奏してみた</a></iframe></div>
<p>&nbsp;</p>
<div class="video"><script type="text/javascript" src="http://ext.nicovideo.jp/thumb_watch/sm21513905?w=490&h=307"></script><noscript><a href="http://www.nicovideo.jp/watch/sm21513905">【ニコニコ動画】RaspberryPiで『U.N.オーエンは彼女なのか？』を演奏してみた</a></noscript></div>
<p>&nbsp;</p>
<p>どーもです。</p>
<p>&nbsp;</p>
<p>RaspberryPiのIOピン制御に<a href="http://wiringpi.com/">Wiring Pi</a>というライブラリを利用したら、物凄く簡単に制御することができるようになりました。</p>
<p>ライブラリに頼ってばかりではいけないのはわかっていますが・・・</p>
<p>&nbsp;</p>
<p>さて、ソースコードはこんな感じです。</p>
<p>予め配列intervalに使う音程の周波数を入れておき、関数noteを使ってnote(音程番号, ○分音符);という感じでmain関数に楽譜を手打ちしていきます。</p>
<p>とりあえず動作させることを優先したため、「え゛っ！？」と思うような部分もあると思いますが、そのへんは無視してくださいw</p>
<p>&nbsp;</p>
<p>ちなみに、RaspberryPiにはもちろんArch Linuxを入れてあります。</p>
<pre class="prettyprint linenums">
<code>#include &lt;stdio.h&gt;
#include &lt;string.h&gt;
#include &lt;wiringPi.h&gt;
#include &lt;softTone.h&gt;

#define PIN 0
#define TEMPO 1500

int interval[19] = {523, 587, 659, 698, 739, 830, 932, 1046, 1109, 1244, 1397, 1567, 1760, 1975, 2093, 0, 622, 784, 1318};

void note(int scale, int time)
{
  softToneWrite(PIN, interval[scale]);

  delay((TEMPO/time)-20);
  softToneWrite(PIN, 0);
  delay(20);
}

int main()
{
  wiringPiSetup();
  softToneCreate(PIN) ;

  printf("***** U.N. Owen Was Her? *****\n");
  printf("             ZUN              \n");

  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(7,8);
  note(15,16);
  note(7,16);
  note(15,8);
  note(7,8);

  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(9,8);
  note(15,16);
  note(9,16);
  note(15,8);
  note(9,8);

  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(7,8);
  note(15,16);
  note(7,16);
  note(15,8);
  note(7,8);

  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(9,8);
  note(15,16);
  note(9,16);
  note(15,8);
  note(9,8);

  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(7,8);
  note(15,16);
  note(7,16);
  note(15,8);
  note(7,8);

  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(9,8);
  note(15,16);
  note(9,16);
  note(15,8);
  note(9,8);

  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(7,8);
  note(15,16);
  note(7,16);
  note(15,8);
  note(7,8);

  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(8,16);
  note(6,16);
  note(3,16);
  note(9,8);
  note(15,16);
  note(9,16);
  note(15,8);
  note(9,8);

  note(3,8);
  note(15,8);
  note(1,8);
  note(15,8);
  note(2,8);
  note(15,8);
  note(0,8);
  note(15,8);

  note(17,8);
  note(15,8);
  note(2,8);
  note(15,8);
  note(16,8);
  note(15,8);
  note(4,8);
  note(15,8);

  note(3,8);
  note(15,8);
  note(1,8);
  note(15,8);
  note(2,8);
  note(15,8);
  note(0,8);
  note(15,8);

  note(17,8);
  note(15,8);
  note(2,8);
  note(15,8);
  note(16,4);

  note(15,4);

  note(3,8);
  note(15,8);
  note(1,8);
  note(15,8);
  note(2,8);
  note(15,8);
  note(0,8);
  note(15,8);

  note(17,8);
  note(15,8);
  note(2,8);
  note(15,8);
  note(16,8);
  note(15,8);
  note(4,8);
  note(15,8);

  note(3,8);
  note(15,8);
  note(1,8);
  note(15,8);
  note(2,8);
  note(15,8);
  note(0,8);
  note(15,8);

  note(17,8);
  note(15,8);
  note(2,8);
  note(15,8);
  note(16,4);

  note(15,4);



  note(3,8);
  note(15,8);
  note(8,8);
  note(15,8);
  note(5,8);
  note(15,8);
  note(8,8);
  note(15,8);

  note(6,8);
  note(15,8);
  note(7,8);
  note(8,8);
  note(7,8);
  note(15,8);
  note(9,8);
  note(15,8);

  note(10,8);
  note(8,8);
  note(12,8);
  note(13,8);
  note(12,8);
  note(13,16);
  note(12,16);
  note(8,8);
  note(8,8);

  note(8,8);
  note(10,8);
  note(7,8);
  note(8,8);
  note(6,4);

  note(15,4);

  note(3,8);
  note(15,8);
  note(8,8);
  note(15,8);
  note(5,8);
  note(15,8);
  note(8,8);
  note(15,8);

  note(6,8);
  note(15,8);
  note(7,8);
  note(8,8);
  note(7,8);
  note(15,8);
  note(9,8);
  note(15,8);

  note(10,8);
  note(8,8);
  note(12,8);
  note(13,8);
  note(12,8);
  note(13,16);
  note(12,16);
  note(8,8);
  note(8,8);

  note(10,2);

  return 0;
}
</code></pre>
