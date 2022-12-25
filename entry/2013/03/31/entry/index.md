---
title: 異なるアーキテクチャ間のCPU性能比較って・・・
date: 2013-03-31 21:03:48+0900
noindex: true
---
<p>どーも</p>
<p>ちょっと気になる記事があったので紹介してみる</p>
<p>&nbsp;</p>
<p><a href="http://www.4gamer.net/games/198/G019883/20130329097/">4Gamer.net ― ［GDC 2013］タッチパネルは対応しなくていい？ Androidの掟破りが連発された「Project SHIELD」向けゲーム開発指南</a></p>
<p>以下引用</p>
<p>----------------------------------------------</p>
<p><u>「Tegra 4の性能はIvy Bridge世代のCore i5に匹敵」</u></p>
<p>&nbsp;</p>
<p>・・・</p>
<p>&nbsp;</p>
<p>　Tegra 4やSHIELDの概要は2013 International CESにおけるNVIDIA主催カンファレンスのレポート記事を参照してもらうとして，ここではEdelsen氏が示した，Tegra 4や，ARMアーキテクチャを採用する他社製SoC（System-on-a-Chip）と，IntelのUltrabook向けCoreプロセッサの性能とを，クロスプラットフォーム対応のベンチマークソフト「Geekbench 2」を用いて比較したというグラフを取り上げよう。</p>
<p>Edelsen氏はこのグラフを示して，1.9GHzで動作するTegra 4の性能が，Ivy Bridgeベースの2コア4スレッドモデル「Core i5-3317U/1.7GHz」に匹敵すると熱弁した。もちろん，プロセッサとメモリを性能を計測するベンチマーク一発ですべてを語るわけにはいかないのだが，基本性能にかなりの自信を持っていると見ることはできそうである。</p>
<p>----------------------------------------------</p>
<p>&nbsp;</p>
<p>このような性能比較はよく「この2つのスマートフォンを比較した時、こっちのCPUのほうが性能いいから・・・」とか「このCPUってショボっ！やっぱりi7だな！」とかいう人がやってる気がするのですが、</p>
<p>このような比較には僕は納得できない、というか必要ないと思います。</p>
<p>&nbsp;</p>
<p>まず、今回の例のようなTegra4とIvyBridge Corei5の比較。</p>
<p>この2つのプロセッサの決定的な違いはアーキテクチャでしょう。</p>
<p>簡単に言えば、プログラムの実行の方法が違う、もっと言えば、そもそもプロセッサの構造が違うということでしょうか。</p>
<p>いくら今回の比較がクロスプラットフォームのベンチマークソフト（異なるアーキテクチャ、プラットフォーム間でも実行・比較できる）であったとしても、</p>
<p>完璧な比較はできないと思います。</p>
<p>いくらTegra4がi5相当の性能を持っていたところで、Tegra4でWindows等のOSは動きませんし、</p>
<p>同様にTegra4のためにビルドされたAndroid等のOSはi5環境でも動かすことはできません。</p>
<p>（エミュレータや、環境に合わせて作りなおされた場合を除く）</p>
<p>結局、性能がどうこう言ったところで、それがどう生かされるかはソフトウェアの最適化次第なのです。</p>
<p>&nbsp;</p>
<p>また、比較したところで何のためになるのでしょうか？</p>
<p>まず、今回の比較に出てきたi5は、主にパソコンに載まれるプロセッサであり、「Intel Corei5プロセッサ搭載スマートフォン」なんてのは無いはずです。</p>
<p>同様に、その逆もそうでしょう。</p>
<p>i5などのプロセッサは主にPC等向きなのに対し、Tegra4などのARM系プロセッサは主に省電力が要求される組み込み向けです。</p>
<p>そのような「プロセッサの使用目的」というものが違う以上、比較したところで何か得があるのでしょうか。</p>
<p>「i5のほうが性能がいいなら、どんな端末にもi5載せればいいじゃない」</p>
<p>誰もそんなことはしないでしょう。（ベンチ厨を除く）</p>
<p>&nbsp;</p>
<p>プロセッサの性能比較では、「どれが最強か？」等の比較は同じアーキテクチャの中で行うべきです。</p>
<p>異なるアーキテクチャ間では、「このプロセッサは浮動小数点数の演算が高速である」程度のものまでにすべきで、ランクを付けるようなことは必要ないと僕は思います。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>とはいえ、完璧な比較ではないものの、ARM系のプロセッサがどんどん性能を上げているのは確かです。</p>
<p>この先プロセッサ業界がどう進んでいくか、とても気になります。</p>
<p>PCのプロセッサが作られなくなるなんてことが起きないことを願うばかりです。PCの需要はあるのだから。</p>
<p>Haswel、またその先はどうなってしまうのか？他のプロセッサメーカーはどう進んでいくのか？</p>
<p>心配で仕方がないです・・・</p>
<p>&nbsp;</p>
<p>「スマホで事足りるからPCなんてイラネ」なんて言ったら僕は怒りますよ〜</p>