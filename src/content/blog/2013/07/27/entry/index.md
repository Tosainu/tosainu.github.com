---
title: "ERROR: Unable to find root device 'xxxxxx'で起動しなくなった時の対処法"
date: 2013-07-27 15:11:24+0900
noindex: true
tags: Arch Linux
---
<p>どうもです。</p>
<p>&nbsp;</p>
<p>水曜日の朝、Chrome v28とかmozcの更新があったので久しぶりにメイン機のArchのソフトウェアアップデートをかけたのですが・・・</p>
<p>&nbsp;</p>
<pre class="prettyprint">
 (*/*) checking for file conflicts
 error: failed to commit transaction (conflicting files)
 filesystem: /bin exists in filesystem
 filesystem: /sbin exists in filesystem
 filesystem: /usr/sbin exists in filesystem
 Errors occurred, no packages were upgraded.
</pre>
<p>&nbsp;</p>
<p>とまぁ、エラーがあって更新失敗したわけです。</p>
<p>&nbsp;</p>
<p>とりあえず対処として、filesystemパッケージ以外を更新した後、Forceオプションを付けて更新させました。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>その結果なのか知りませんが、次にArchを立ち上げると、</p>
<p>&nbsp;</p>
<p><img src="https://lh4.googleusercontent.com/-Ph3Zgf_DUGM/UfNclDsMlsI/AAAAAAAACdw/7gNKmkuq9lk/s640/IMG_0864.JPG" /></p>
<p>&nbsp;</p>
<p><span style="font-size:36px;">起動しねーよ</span></p>
<p>&nbsp;</p>
<p>諦めて再インストールかなぁとも考えましたが、海外のフォーラムにて「おっ！？」という情報があり、それを参考にいろいろ弄ったところ無事復活させることができたので対処法としてメモしようと思います。</p>
<p>&nbsp;</p>
<p><a href="https://bbs.archlinux.org/viewtopic.php?id=142052">[SOLVED] ERROR: Unable to find root device '/dev/sda3' (Page 1) / Kernel & Hardware / Arch Linux Forums</a></p>
<p>&nbsp;</p>
<h3>準備するもの</h3>
<p>Arch Linuxのインストールディスク（chroot使えるLiveCDなら何でもいけるかも）</p>
<p>「何としてでも再インストールは避けたい」と思う気持ち</p>
<p>&nbsp;</p>
<h3>方法</h3>
<p>Arch LinuxのインストールディスクでPCを起動、</p>
<p>もしシステムにudevやmkinitcpioをインストールしていない場合は、ネットワークの設定を済ませておきます。</p>
<p>適当なマウントポイントを作成し、起動しなくなったシステムのパーティションをマウントさせます。</p>
<p>僕の場合、/mntにarchフォルダを作成、/のsda6、/bootのsda5をマウントさせました。</p>
<pre class="prettyprint">
# mkdir /mnt
# mkdir /mnt/arch
# mount /dev/sda6 /mnt/arch
# mount /dev/sda5 /mnt/arch/boot
</pre>
<p>&nbsp;</p>
<p>次に、chrootさせるために必要なproc等をマウント、そしてchrootします。</p>
<pre class="prettyprint">
# cd /mnt/arch
# mount -t proc proc proc/
# mount -t sysfs sys sys/
# mount -o bind /dev dev/
# chroot .
</pre>
<p>&nbsp;</p>
<p>chrootしたら、initramfsをmkinitcpioを使って再生成します。</p>
<pre class="prettyprint">
[chroot] # pacman -Syu udev mkinitcpio
↑mkinitcpio等をインストールしていない場合

[chroot] # mkinitcpio -p linux
</pre>
<p>&nbsp;</p>
<p>chrootから抜けマウントしたドライブをアンマウント、再起動させます。</p>
<pre class="prettyprint">
[chroot] # exit

# cd /
# umount /mnt/arch/proc
# umount /mnt/arch/sys
# umount /mnt/arch/dev
# umount /mnt/arch/boot
# umount /mnt/arch
# reboot
</pre>
<p><span style="font-size:6px;">（アンマウントのコマンド、もう少し楽に出来るけど、そこは突っ込まないでください・・・）</span></p>
<p>&nbsp;</p>
<p>僕の環境ではこの方法で復活できました。</p>
<p>一時は本当にどうなることかと思いましたが、無事復活してよかったです。</p>
