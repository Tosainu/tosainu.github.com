---
title: Sony Tablet Pを弄る
date: 2013-01-27 10:00:17+0900
tags: Android
---
<p>どもーとさいぬです</p>
<p>&nbsp;</p>
<p>数日前、友人からSony Tablet Pを渡されまして、</p>
<p>「このソニタブまだAndroid 3.2.1だからICS化して欲しい。もちろんroot取得もお願い。」とのことでした。</p>
<p>&nbsp;</p>
<p>ソニタブの最新ファームは残念ながらroot取得が不可能（今のところ）となってしまいました。</p>
<p>しかし、xdaを参考に、ツールを使うことでroot取得済みの最新ファームを入れることに成功しました。</p>
<p>作業自体は思ったほど難しくなかったのでメモ程度に残しておこうと思います</p>
<p>というか、xda（←今度説明するかも）の人たちが素晴らしい全自動ツールを作っているので僕は特に何もしていないわけです。
</p>
<p>ってことでツール作成者の方々に感謝しながら作業を進めましょう！</p>
<p>なお、Android SDK、ADBドライバがインストールされていることを前提として話を進めます。</p>
<p>&nbsp;</p>
<h3>用意するもの</h3>
<ul>
<li>Sony Tablet P(デバッグモードを入れておく)</li>
<li>Micro-USB(A-MicroB)ケーブル(充電専用ケーブルは不可)</li>
<li>USBポートを搭載したWindowsパソコン(ツールを弄ればLinuxもいけるはず。未検証)</li>
</ul>
<p>&nbsp;</p>
<h3>必要なツール類</h3>
<p>リンク先の最初の記事の一番下にツールのダウンロードリンクが張ってあります。</p>
<p>最新版をダウンロードしてください。圧縮ファイルの解凍も忘れずに。</p>
<p>また、このようなAndroidのルートキットは一部のウイルス対策ソフトで誤認識する場合があるので、そのようなソフトウェアは一時的に止めておくことをおすすめします。</p>
<p>&nbsp;</p>
<p><a href="http://forum.xda-developers.com/showthread.php?t=2050126">S.onyTablet.S [ALLinONE]</a></p>
<p>Sony Tablet、Xperia Tablet用のルートキット＋α</p>
<p>&nbsp;</p>
<p><a href="http://forum.xda-developers.com/showthread.php?t=2050126">S.onyTablet.S [FLASHER]</a></p>
<p>Sony Tablet、Xperia Tablet用のroot取得済み最新ファーム書き込みツール</p>
<p>&nbsp;</p>
<h3>方法</h3>
<p>1.root権限取得</p>
<p>root取得済みな最新版のファームウェアを書き込んでくれるS.onyTablet.S [FLASHER](以下Flasher)の動作には端末にroot権限が要るそうです。ってことで、まず、S.onyTablet.S [ALLinONE](以下AiO)を使って端末のroot権限を取得します。</p>
<p>&nbsp;</p>
<p>ソニタブをデバッグモードを入れてUSBでパソコンと接続し、AiOを解凍して出てくるS.onyTablet.S.batを実行します</p>
<p><img src="https://lh3.googleusercontent.com/--1i39gQP4Vc/UQaerJ3IJpI/AAAAAAAABDQ/VaoxMKVFkSY/s640/aio1.png" /></p>
<p>1を入力し、Enterで端末のroot化を始めます。途中、yes等の入力が求められます。</p>
<p>&nbsp;</p>
<p>作業が終了すると、端末は再起動します。再起動したら、ドロワーにSuperuserがあることと、adb shellからsuとコマンドを打ち、rootユーザーになれることを確認します。</p>
<p>&nbsp;</p>
<p>さて、ここからはroot取得済みのICSファームを書き込みます。端末はそのままで、AiOのウィンドウは閉じ、今度はFLASHERを解凍して出てくるS.onyTablet.S [FLASHER].batを実行します。</p>
<p><img src="https://lh5.googleusercontent.com/-s4NxyDAQrOI/UQag7GzSCHI/AAAAAAAABDk/b82iXVDGeQI/s640/flasher1.png" /></p>
<p>今回ファームウェアを書き込む端末はソニタブPなので、1bと入力してEnterでファームウェアのダウンロードと書き込みが始まります。</p>
<p>こちらも途中質問に答えます。全部yesで大丈夫でした。</p>
<p>意外と時間がかかりました。また、Androidが起動したままファームウェアの書き込みをするようなので、作業中は何も操作しないほうがいいかと思います。</p>
<p>なにかあったら多分復元は難しいので・・・</p>
<p>&nbsp;</p>
<p>root取得と同様に、作業が終わると勝手に再起動します。</p>
<p>とさいぬの環境ではシャットダウン後の起動に失敗し、黒画面のままになってしまいましたが、バッテリーの入れなおしをして電源を入れると無事起動しました。</p>
<p>adb shellからrootユーザーになれることも確認できました。</p>
<p><span style="font-size:36px;">成功ですイェイ！</span></p>
<p>&nbsp;</p>
<p>お疲れ様でした。作業は終了です。</p>
<p>&nbsp;</p>
<p>ICS化したソニタブの友人の感想ですが、画面のアニメーションやスクロールはなめらかになったが、メモリの消費量は増加したようです。</p>
<p>元々十分なメモリを積んでいるので気になることは無いレベルのものですが、root権限もあることですし、弄ってみるとおもしろいと思います。</p>
<p>&nbsp;</p>
<p>質問等があればコメントやメールフォームからどうぞ。</p>
<p>コメントが増えると更新が増えるかもしれません。（笑）</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>あーなんかソニタブ欲しくなってきた</p>
<p>今19,800までさがってるんだよなぁ・・・</p>
