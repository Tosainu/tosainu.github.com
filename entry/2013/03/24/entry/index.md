---
title: Arch Linuxをインストールし、デスクトップ環境Cinnamonを動かすまでのメモ
date: 2013-03-24 17:31:09+0900
noindex: true
tags: Arch Linux
---
<p><span class="fontsize6">もっと真面目に記事を新しく書きました。こちらの記事もどうぞ↓</span></p>
<p><span class="fontsize6"><a href="http://tosainu.wktk.so/view/325">【Arch Linux】Arch Linuxインストールめも (2013完全版？？？)</a></span></p>
<p>&nbsp;</p>
<p>どーもとさいぬです。</p>
<p>&nbsp;</p>
<p>メイン機、サブ機共に<a href="https://www.archlinux.org/">Arch Linux</a>をインストールして、<a href="http://cinnamon.linuxmint.com/">Cinnamon</a>を動かすことに成功したのでメモ。</p>
<p>Archたんマジ天使</p>
<p>&nbsp;</p>
<p>注：初めてLinuxを使う方にはおすすめできないディストリで、かつ若干手抜きの記事のため、</p>
<p>参考にする場合は公式Wiki等も読まれることをおすすめします。</p>
<p>&nbsp;</p>
<h3>とりあえずインストール</h3>
<p>今回はインストールにarchlinux-2013.03.01-dual.isoを使い、x86_64を選択。</p>
<p><a href="https://wiki.archlinux.org/index.php/Installation_Guide">Installation Guide - ArchWiki</a>や</p>
<p><a href="http://extrea.hatenablog.com/entry/2013/02/15/123721">Arch Linuxインストールメモ （archlinux-2013.02.01） - 海馬のかわり</a></p>
<p>を参考にインストール。</p>
<p>海馬のかわりの記事の"rc.local"は今回はやらなかった。</p>
<p>もともと入っているnanoやviはちょっとクセがあるので、arch-chrootしてすぐ</p>
<pre class="prettyprint linenums">
# pacman -Sy vim
</pre>
<p>で使い慣れたエディタを入れておくのがオヌヌメ。</p>
<p>&nbsp;</p>
<h3>Xorgのインストール</h3>
<p>Nvidia系のドライバやユーティリティが32bitライブラリを要求してくるので、multilibを有効にする。</p>
<pre class="prettyprint linenums">
# vim /etc/pacman.conf
</pre>
<p>のようにして/etc/pacman.confを開き、</p>
<p>最後の方にある</p>
<pre class="prettyprint linenums">
[multilib]
SigLevel = PackageRequired
Include = /etc/pacman.d/mirrorlist
</pre>
<p>の部分をコメントアウトする。</p>
<p>&nbsp;</p>
<p>Xorgをインストールする。</p>
<p>パッケージを絞りたいところだが、面倒だったので、</p>
<pre class="prettyprint linenums">
# pacman -Sy xorg
</pre>
<p>とやった。</p>
<p>しかし、AMD系やNvidia系の公式ドライバを入れる場合、↑の方法でやろうとするとパッケージの依存関係等で後処理が大変なので、</p>
<pre class="prettyprint linenums">
# pacman -Sy xorg-server xorg-utils xorg-server-utils
</pre>
<p>みたいな感じに絞り、その後</p>
<pre class="prettyprint linenums">
# pacman -S nvidia nvidia-utils
</pre>
<p>のようにドライバをインストールした。</p>
<p>&nbsp;</p>
<h3>gnome、cinnamon、gdmのインストール</h3>
<p>ログインマネージャとウィンドウマネージャをインストールする。</p>
<pre class="prettyprint linenums">
# pacman -Sy gnome cinnamon gdm
</pre>
<p>gnome入れるのは、ログイン画面がキレイになるからってだけの理由です。</p>
<pre class="prettyprint linenums">
# systemctl enable gdm.service
</pre>
<p>とやってgdmのサービスを有効にしたら再起動。</p>
<p>次からはguiのログイン画面が表示されるはずです。</p>
<p>&nbsp;</p>
<h3>guiが動いてからやること</h3>
<p>1.ネットワーク接続にNetworkManagerを使うようにする。</p>
<pre class="prettyprint linenums">
# pacman -S networkmanager　network-manager-applet
</pre>
<p>とやってインストールしたら、インストール段階で有効にしたネットワーク接続のサービスを無効にし、</p>
<pre class="prettyprint linenums">
# systemctl stop dhcpcd@enp2s0
# systemctl disable dhcpcd@enp2s0
</pre>
<p>↑は例</p>
<p>NetworkManagerを有効にする</p>
<pre class="prettyprint linenums">
# systemctl enable NetworkManager
</pre>
<p>ここで再起動したほうが気持ちがいい。</p>
<p>次起動するときにはネットワーク接続の設定がguiでできるようになる。</p>
<p>デバイスが認識できていれば、無線LANも簡単に使えるかも。</p>
<p>&nbsp;</p>
<p>2.gnomeのコントロールパネルを入れる</p>
<p>cinnamonのコントロールパネルにはキーマップの設定がなく、勝手に英語配列と認識されてしまうため、gnomeのコントロールパネルを入れる。</p>
<pre class="prettyprint linenums">
# pacman -S gnome-control-center
</pre>
<p>こうすると、アプリケーションのメニューに同じアイコンで同じ名前のコントロールパネルが現れるようになってしまうので気になる。</p>
<p>早く対処してもらいたいものだ。</p>
<p>&nbsp;</p>
<p>あとは作業用のユーザーを作成し、必要なソフトウェアを追加していくだけです。</p>
<p>ねっ、簡単でしょ♪</p>
<p>google-chromeやoracle-jdk、androidSDK（PATH設定も）等はyaourtで入れることができます。</p>
<p>&nbsp;</p>
<p>かなり適当な解説になってしまいましたが、わからないことなどあったらコメントやメールしてくれたら相談にのります。</p>
<p>いつかはもっと詳しく書いたり、ゆっくりによる解説動画をうｐしたりしたいですが・・・</p>
<p>&nbsp;</p>
<p>ではでは〜</p>
