---
title: makepkg.confを弄る
date: 2013-04-27 12:13:41+0900
noindex: true
tags: Arch Linux
---
<p>どもども</p>
<p>&nbsp;</p>
<p>Arch LinuxにはAURというものがありまして、</p>
<p>pacmanから手に入れられないようなパッケージを簡単にビルド&インストールできるものです。（雑な説明で申し訳ない）</p>
<p>ChromeやOracleJDK、AndroidSDKなんかも手に入ったりします。</p>
<p>&nbsp;</p>
<p>ですが、</p>
<p>&nbsp;</p>
<p><span style="font-size:36px;">ビルドが遅い</span></p>
<p>巨大なパッケージのビルドに時間は掛かるのはわかっています。</p>
<p>でも、マシンの性能の割にはあまりにも遅くないかと。</p>
<p>&nbsp;</p>
<p>関係ありそうなことを検索していると、</p>
<p>&nbsp;</p>
<p><a href="https://wiki.archlinux.org/index.php/Makepkg.conf">makepkg - ArchWiki</a></p>
<p>&nbsp;</p>
<p>ありましたありました。</p>
<p>ビルドオプションはmakepkg.confを弄ればいいみたいです。</p>
<p>&nbsp;</p>
<p>さて、デフォルトの設定は・・・</p>
<pre class="prettyprint linenums">
・・・
#########################################################################
# ARCHITECTURE, COMPILE FLAGS
#########################################################################
#
CARCH="x86_64"
CHOST="x86_64-unknown-linux-gnu"

#-- Compiler and Linker Flags
# -march (or -mcpu) builds exclusively for an architecture
# -mtune optimizes for an architecture, but builds for whole processor family
CPPFLAGS="-D_FORTIFY_SOURCE=2"
CFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector --param=ssp-buffer-size=4"
CXXFLAGS="-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector --param=ssp-buffer-size=4"
LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro"
#-- Make Flags: change this for DistCC/SMP systems
#MAKEFLAGS="-j2"
#-- Debugging flags
DEBUG_CFLAGS="-g -fvar-tracking-assignments"
DEBUG_CXXFLAGS="-g -fvar-tracking-assignments"
・・・
</pre>
<p><span style="font-size:36px;">け し か ら ん</span></p>
<p>&nbsp;</p>
<p>Gentooのインストールとかを経験している人なら「ピンッ」ってきそうな項目ですね。</p>
<p>要は、</p>
<p>「<span style="color:red;">一般的なx86_64のプロセッサ</span>向け（-march=x86-64 -mtune=generic -O2 -pipe）に<span style="color:red;">1スレッド</span>だけ（#MAKEFLAGS="-j2" マルチスレッドでのビルド無効）でビルドする。」</p>
<p>という設定になっています。</p>
<p>&nbsp;</p>
<p>ウチのメイン機は12スレッド。また、Corei7に最適化されるように、CFLAGS、CXXFLAGS、MAKEFLAGSを編集します。</p>
<pre class="prettyprint linenums">
・・・
#########################################################################
# ARCHITECTURE, COMPILE FLAGS
#########################################################################
#
CARCH="x86_64"
CHOST="x86_64-unknown-linux-gnu"

#-- Compiler and Linker Flags
# -march (or -mcpu) builds exclusively for an architecture
# -mtune optimizes for an architecture, but builds for whole processor family
CPPFLAGS="-D_FORTIFY_SOURCE=2"
CFLAGS="-march=corei7 -O2 -pipe"
CXXFLAGS="${CFLAGS}"
LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro"
#-- Make Flags: change this for DistCC/SMP systems
MAKEFLAGS="-j12"
#-- Debugging flags
DEBUG_CFLAGS="-g -fvar-tracking-assignments"
DEBUG_CXXFLAGS="-g -fvar-tracking-assignments"
・・・
</pre>
<p>これで、</p>
<p>「<span style="color:red;">Corei7</span>（i3とかi5、Xeonとかも）に最適化されたアプリケーションを<span style="color:red;">12スレッド</span>でビルドする」</p>
<p>という設定になった（はず）です。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>では効果の確認といきますか！</p>
<p>&nbsp;</p>
<h3>方法</h3>
<p>ホームフォルダに作成されたmakepkgフォルダ内に、IMEである<a href="https://aur.archlinux.org/packages/mozc/">Mozc</a>のtarballをDL&展開。
<p>一旦makepkgコマンドを実行し、ソースコードのダウンロードが完了したところでCtrl+Cで中断。</p></p>
<p>&nbsp;</p>
<p>makepkg.confの編集前と編集後で、makepkgコマンドの実行に掛かる時間を計測する。</p>
<p>時間は</p>
<p>==> Making package:・・・</p>
<p>から</p>
<p>==> Finished making:・・・</p>
<p>までの間とし、その時に表示される開始時刻と終了時刻の差をパッケージ生成に掛かった時間とする。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<h3>そろそろ見飽きてきたメイン機のスペック（関係ありそうなところだけでいいよねもう）</h3>
<p>CPU：i7-3930k@4500MHz</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<h3>編集前</h3>
<p>==> Making package: mozc 1.10.1390.102-2 (Sat Apr 27 11:09:05+0900 2013)</p>
<p>==> Finished making: mozc 1.10.1390.102-2 (Sat Apr 27 11:14:05+0900 2013)</p>
<p>掛かった時間：<span style="font-size:24px;">5分</span></p>
<p>&nbsp;</p>
<h3>編集後</h3>
<p>==> Making package: mozc 1.10.1390.102-2 (Sat Apr 27 11:22:47+0900 2013)</p>
<p>==> Finished making: mozc 1.10.1390.102-2 (Sat Apr 27 11:24:06+0900 2013)</p>
<p>掛かった時間：<span style="font-size:24px;">1分19秒</span></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><span style="font-size:24px;">キタ———（゜∀゜）———— ！！</span></p>
<p>メチャクチャ早くなりました。</p>
<p>&nbsp;</p>
<p>今回は12スレッドという設定にしましたが、HTは信用できないので、</p>
<p>6スレッドにしたらもしかしたらもっと早くなるかもしれません。</p>
<p>&nbsp;</p>
<p>また、ビルド時間には関係ありませんが、3930kはAVX命令にも対応しているので、</p>
<p>CFLAGS="-march=corei7-avx -O2 -pipe"</p>
<p>としたら、もっと最適化されたものができるかもしれません。</p>
