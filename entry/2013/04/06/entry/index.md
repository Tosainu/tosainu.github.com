---
title: 'Pacmanのエラー「package-query: requires pacman<4.1」の対処方法'
date: 2013-04-06 10:25:55+0900
tags: Arch Linux
---
<p>本日２回目の記事ですが、今日Pacmanでパッケージをインストールしようとすると、</p>
<pre class="prettyprint linenums">
:: The following packages should be upgraded first :
    pacman
:: Do you want to cancel the current operation
:: and upgrade these packages now? [Y/n] 
</pre>
<p>と、出たんですね。</p>
<p>まぁ、要は「Pacmanのアップデートがあるけど、先に更新する？」みたいな質問です。</p>
<p>&nbsp;</p>
<p>これでyと入力してPacmanを更新しようとすると、</p>
<pre class="prettyprint linenums">
error: failed to prepare transaction (could not satisfy dependencies)
:: package-query: requires pacman<4.1
</pre>
<p>うー・・・なんか面倒なことになってるぞ・・・</p>
<p>&nbsp;</p>
<p>ggったら外国のフォーラムで対処方法が載っていたので紹介。</p>
<p>（2chのArch版では誰も解決できてないみたいですね。英語読め英語を！）</p>
<p>&nbsp;</p>
<p><a href="https://bbs.archlinux.org/viewtopic.php?pid=1254838">[SOLVED] Upgrading to Pacman 4.1 - various issues (Page 2) / Pacman & Package Upgrade Issues / Arch Linux Forums</a></p>
<p>&nbsp;</p>
<p>まず、一旦package-queryとyaourtをアンインストール</p>
<pre class="prettyprint linenums">
# pacman -R package-query yaourt
</pre>
<p>そうしたらパッケージのアップデートをかけると、同じようにpacmanの更新通知がくるのでyを入力してEnter。</p>
<pre class="prettyprint linenums">
# pacman -Syu
:: Synchronizing package databases...
 core is up to date
 extra is up to date
 community is up to date
 multilib is up to date
:: The following packages should be upgraded first :
    pacman
:: Do you want to cancel the current operation
:: and upgrade these packages now? [Y/n] y

resolving dependencies...
looking for inter-conflicts...

Targets (1): pacman-4.1.0-2

Total Download Size:    0.58 MiB
Total Installed Size:   4.24 MiB
Net Upgrade Size:       0.70 MiB

Proceed with installation? [Y/n] y
:: Retrieving packages from core...
 pacman-4.1.0-2-x86_64    598.0 KiB   472K/s 00:01 [######################] 100%
(1/1) checking package integrity                   [######################] 100%
(1/1) loading package files                        [######################] 100%
(1/1) checking for file conflicts                  [######################] 100%
(1/1) checking available disk space                [######################] 100%
(1/1) upgrading pacman                             [######################] 100%
warning: /etc/pacman.conf installed as /etc/pacman.conf.pacnew
</pre>
<p>新しいpacman.confができているので、それに置き換える。</p>
<pre class="prettyprint linenums">
# mv /etc/pacman.conf.pacnew /etc/pacman.conf
</pre>
<p>新しいpacman.confでアップデートが通るか確認する。</p>
<pre class="prettyprint linenums">
# pacman -Syu
</pre>
<p>必要に応じてyaourtとpackage-queryを再びインストールする。</p>
<p>&nbsp;</p>
<p>Happy Day!!</p>
<p>&nbsp;</p>
<p>はい、Linuxでわからないときは<span style="color:red;">2chではなく海外フォーラムやWikiを必ず確認</span>しましょう。</p>
<p>Linuxの世界（というかPC関係すべて）での常識です。</p>
