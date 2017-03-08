---
title: GentooInstallBattle!をした
date: 2013-10-03 23:01:05 JST
tags: Linux
---
<p>どーもども</p>
<p>&nbsp;</p>
<p>2013/10/1(Tue)のこと、なんかTwitterでやたら<a href="https://twitter.com/search?q=%23gentooinstallbattle">#gentooinstallbattle</a>タグが飛んでいたんですよね。</p>
<p>何があったのかはよくわかってませんが、『俺も参加しなければいけないっ！！！』という衝動に駆られたのでGentooをインストールしました。</p>
<p>&nbsp;</p>
<p>Gentooのインストールは昨年何度か試しましたが、カーネルのブートには成功するもののXの起動がうまく行かず放置、</p>
<p>目玉機能の一つでもあるUSEフラグを「気持ち悪い」と言い出してしまう始末・・・</p>
<p>&nbsp;</p>
<p>ですが今回、うまく行ったのでメモも兼ねて記事にすることにしました。</p>
<p><img src="https://lh6.googleusercontent.com/-nyejBa3nS9Y/Uk1pp6WhacI/AAAAAAAACos/3-FyYZ-0wHQ/s640/Screenshot%2520from%25202013-10-02%252009%253A34%253A11.png" /></p>
<p>&nbsp;</p>
<p>それではとさいぬのくだらないtweetとスクショと共にお楽しみくださいw</p>
<p>また、この記事では「gentooのインストール方法」にはあまり触れませんのでご了承ください。</p>
READMORE
<p>&nbsp;</p>
<p>&nbsp;</p>
<h2>#gentooinstallbattle目標</h2>
<p>勝手にこう解釈しました。</p>
<ul>
<li>Gentooを起動させる（当たり前w）</li>
<li>何らかのデスクトップシステムのインストール</li>
<li>mikutterをインストールしTwitterにつぶやく</li>
</ul>
<p>&nbsp;</p>
<h2>インストールする環境</h2>
<p>ちょうど予備のHDDがすべて使用中だったため、Virtualboxで作成した仮想マシンにインストールしました。</p>
<p>ホストはメイン機、OSはArch Linuxです。</p>
<p>設定はこんなかんじです。</p>
<p><img src="https://lh5.googleusercontent.com/-S-cwaB4FDwE/Uk1qMQ1y-PI/AAAAAAAACo0/zWfaPBf6pSE/s640/Screenshot%2520from%25202013-10-01%252022%253A27%253A43.png" /></p>
<p>&nbsp;</p>
<h2>GentooInstallBattle!</h2>
<p>22:34頃、インストール開始</p>
<blockquote class="twitter-tweet tw-align-center"><p><a href="https://twitter.com/search?q=%23gentooinstallbattle&amp;src=hash">#gentooinstallbattle</a>&#10;はじめ！ <a href="http://t.co/4OdVvFGbhc">pic.twitter.com/4OdVvFGbhc</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385035086569029632">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>&nbsp;</p>
<p>23:08頃、新しい環境にchrootする。</p>
<blockquote class="twitter-tweet tw-align-center"><p><a href="https://twitter.com/search?q=%23gentooinstallbattle&amp;src=hash">#gentooinstallbattle</a>&#10;chrootしますた <a href="http://t.co/5BchY3sxnz">pic.twitter.com/5BchY3sxnz</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385043507343142914">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>&nbsp;</p>
<p>make.confはこんな感じ。前回試したときはgccのバージョンが古くCFLAGSが細かく設定できませんでしたが、今回デフォルトで入っていたgccは4.6.3だったのでavx命令にも対応させました。</p>
<p>USEフラグはこの時点では結構テキトウです。</p>
<pre class="prettyprint linenums">
USE="gtk gnome -qt4 -kde dvd alsa cdr"
CHOST="x86_64-pc-linux-gnu"
CFLAGS="-march=corei7-avx -02 -pipe"
CXXFLAGS="${CFLAGS}"
MAKEOPTS="-j8"
</pre>
<p>&nbsp;</p>
<p>23:23頃、chroot早々vimをemerge。</p>
<blockquote class="twitter-tweet tw-align-center"><p>vimいれてしまった <a href="http://t.co/LwRiX8Rebx">pic.twitter.com/LwRiX8Rebx</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385047236255563777">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>だってnanoたん使いにくいんだもん・・・</p>
<p>&nbsp;</p>
<p>23:34、カーネルのmake。</p>
<blockquote class="twitter-tweet tw-align-center"><p>カーネルのmake <a href="http://t.co/dOy9jkWyee">pic.twitter.com/dOy9jkWyee</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385050188714229760">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>今や数分で終わっちゃいますね。糞ーテックで3時間かけてカーネルビルドしたのが懐かしいです。<span class="fontsize1">（そしてできたものは動かないというねwww）</span></p>
<p>&nbsp;</p>
<p>カーネルやブートローダのインストールも完了！</p>
<p>しかし再起動かけるとKernel Panic・・・</p>
<blockquote class="twitter-tweet tw-align-center"><p>(´・ω・｀) <a href="http://t.co/BwjCCp7m6H">pic.twitter.com/BwjCCp7m6H</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385055988589412352">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>これはgrub.confの記述ミスによるものでした。</p>
<p>多少修正して無事起動。</p>
<blockquote class="twitter-tweet tw-align-center"><p>キターーーッ&#10;すっごい単純なことで解決 <a href="http://t.co/3lOT8T6OeC">pic.twitter.com/3lOT8T6OeC</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385056652627431425">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>&nbsp;</p>
<p>さて長い道のりはここから。</p>
<blockquote class="twitter-tweet tw-align-center"><p>実に暇である <a href="http://t.co/lQvJCnLwk9">pic.twitter.com/lQvJCnLwk9</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385064292518621184">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>USEフラグのチューニングでビルド時間は変わってくるんでしょうけどね・・・</p>
<p>&nbsp;</p>
<p>Gentooのsl。踏切付きの長い長い列車でしたw</p>
<blockquote class="twitter-tweet tw-align-center"><p>gentooのSL長すぎwwwww&#10;踏切ついてるしwwwwww <a href="http://t.co/kYxN2wn9n7">pic.twitter.com/kYxN2wn9n7</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385081144045084672">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>&nbsp;</p>
<p>10/2 1:53頃、emerge結果をTwitterにつぶやく#GenTwooの動作に成功。</p>
<blockquote class="twitter-tweet tw-align-center"><p>Failed to emerge 26 packages: <a href="http://t.co/hPEp1CoRVD">http://t.co/hPEp1CoRVD</a> <a href="https://twitter.com/search?q=%23GenTwoo&amp;src=hash">#GenTwoo</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385085125811122176">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>Failedとなってる件に関しては後述。</p>
<p>&nbsp;</p>
<p>1:58頃、gnome(-lite)のemerge開始。</p>
<blockquote class="twitter-tweet tw-align-center"><p>gnomeのemerge開始&#10;1/148</p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385086369921372160">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>今思えばもっと軽い（ビルド時間の短い）WMにすべきだったなと。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><span class="fontsize6">3:00頃、寝落ちる</span></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>起きる。</p>
<blockquote class="twitter-tweet tw-align-center"><p>おはようー</p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385157507821236224">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>&nbsp;</p>
<p>gnomeのビルドは無事終了。gnomeの起動に成功する。</p>
<blockquote class="twitter-tweet tw-align-center"><p>イエイ！ <a href="http://t.co/ARZ3vaCOei">pic.twitter.com/ARZ3vaCOei</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385189907452280832">October 1, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>&nbsp;</p>
<p>9:35、mikutterからつぶやくことに成功。</p>
<blockquote class="twitter-tweet tw-align-center"><p>tesuto</p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385200960189919232">October 2, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet tw-align-center"><p><a href="https://twitter.com/search?q=%23gentooinstallbattle&amp;src=hash">#gentooinstallbattle</a>&#10;mikutter on gentoo! <a href="http://t.co/5v4r8wN5Ny">pic.twitter.com/5v4r8wN5Ny</a></p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385201283080007681">October 2, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>&nbsp;</p>
<p>またその25分後、mozcのemergeと設定が終了し、日本語入力に成功。</p>
<blockquote class="twitter-tweet tw-align-center"><p>てすてす</p>&mdash; とさいぬΣ(ﾟ∀ﾟﾉ)ﾉ (@tosainu_maple) <a href="https://twitter.com/tosainu_maple/statuses/385208131506020352">October 2, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<p>&nbsp;</p>
<p><span class="fontsize7">Mission complete！</span></p>
<p>&nbsp;</p>
<h2>今後の課題</h2>
<h3>USEフラグ等のチューニング</h3>
<p>emergeに--autounmask-writeオプションを付けることで、USEフラグ等にあまり気にせず作業することが出来ました。</p>
<p>例えばrubyをインストールするとき、初期状態ではエラーが出てうまく行かないはずですが、</p>
<pre class="prettyprint linenums">
# emerge --autounmask-write "=dev-lang/ruby-2.0.0_p247-r1"
# dispatch-conf
// すべてuを選択
# emerge -av "=dev-lang/ruby-2.0.0_p247-r1"
</pre>
<p>でインストールできちゃいます。</p>
<p>&nbsp;</p>
<p>先程も軽く書きましたが、USEフラグのチューニングをすればemergeされるパッケージが絞ることもできるようです。</p>
<p>多少チューニングを加えられたらなぁと思っています。</p>
<p>&nbsp;</p>
<h3>#GenTwooがすべてFailedになる</h3>
<p>DASHBOARDを真っ紅に染め、さらに未だランキングに居座ってるアカウントはこちらになりますw</p>
<p><img src="https://lh6.googleusercontent.com/-ExYmSaLO1E4/Uk12h3yRK8I/AAAAAAAACpM/VX2Cx-kxcqI/s640/Screenshot%2520from%25202013-10-03%252022%253A50%253A28.png" /></p>
<p><img src="https://lh3.googleusercontent.com/-Ix4Qi0bcjPU/Uk12hkqruoI/AAAAAAAACpI/wRgqoGIWnh0/s800/Screenshot%2520from%25202013-10-03%252022%253A50%253A34.png" height="383" width="218" /></p>
<p>原因は未だ把握できておりません</p>
<p>誰か情報おねがいします・・・</p>
<p>&nbsp;</p>
<p>ではまたいつか、ではでは〜</p>
