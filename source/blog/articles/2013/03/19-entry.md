---
title: 【自作機1号】GTX 660TiのBIOSを弄る（MaxTDP・FanSpeed・BoostClock・VoltageLimit）
date: 2013-03-19 14:07:32 JST
tags: PC,Maini7-3930k
---
<p>どーもです</p>
<p>&nbsp;</p>
<p>タイトル通りです。</p>
<p>なんか危険なことに手を出してる気がしますが、</p>
<p><span style="font-size:36px;">660TiのBIOS弄りました</span></p>
<p>&nbsp;</p>
<p>でまぁ、何がどうなったかというと、</p>
<ul>
<li>Max FanSpeed：80%→100%</li>
<li>Max Power Limit：125%？→150%</li>
<li>Max BoostClock：1085MHz→1228MHz</li>
<li>Max CoreVoltage：1.1750V→1.212V（GPU-Z読み）</li>
</ul>
<p><a href="https://picasaweb.google.com/lh/photo/bhgpZubXSsDCWO2SmqWs9dMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh3.googleusercontent.com/-qwopLgi5ZXU/UUfkJzKky7I/AAAAAAAABu8/uesBanERH-U/s800/unlock%2521%2521%2521%2521%2521%2521.png" height="485" width="393" /></a></p>
<p>&nbsp;</p>
<p>これで念願のCoreClock約1230MHz達成です。</p>
<p>&nbsp;</p>
<p>一応方法を書いておこうと思いますが、</p>
<p><span style="color:red;">失敗した場合グラボはファンのついた文鎮になるので注意です。</span></p>
<p>また、</p>
<p><span style="color:red;">この方法が使えるのはNvidiaのkeplerアーキテクチャのグラボのみです。</span></p>
<p>&nbsp;</p>
<p>参考にしたサイト</p>
<p><a href="http://www.overclock.net/t/1302409/official-nvidia-gtx-660ti-owners-club/1280#post_19314756">[Official] NVIDIA GTX 660TI Owners club</a></p>
<p>&nbsp;</p>
<h3>用意するもの</h3>
<ul>
<li>弄りたいグラボを載せたWindowsマシン</li>
<li><a href="http://www.techpowerup.com/gpuz/">TechPowerUP GPU-Z</a></li>
<li><a href="http://dl.dropbox.com/u/55743933/kgb_0.6.1.zip">Kepler BIOS Editor</a></li>
<li><a href="http://www.techpowerup.com/downloads/2133/NVFlash_5.118_for_Windows.html">NVFlash For Windows</a></li>
</ul>
<p>&nbsp;</p>
<h3>1.改造前のBIOSを抜き出す</h3>
<p>TechPowerUP GPU-Zを起動します。</p>
<p>画像の<strong><span style="color:red;">□</span></strong>をクリックすると、BIOSが抜き出せます。適当なところに保存してください。</p>
<p><a href="https://picasaweb.google.com/lh/photo/j6IJ2ij0PpW8uwnXlvBNotMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-uiezirPUb0U/UUfx5CFdpYI/AAAAAAAABvM/7eoKfU9IoSw/s800/nyan.png" height="485" width="393" /></a></p>
<p><span style="color:red;">もしものためにBIOSにはバックアップを作っておいてください。</span></p>
<p>&nbsp;</p>
<h3>2.BIOSのファイルを加工する</h3>
<p>Kepler BIOS Editorの圧縮ファイルを展開し、kgb.exeがあるディレクトリに先程抜き出したBIOSファイルをコピーします。</p>
<p>kgb.cfgをメモ帳等で開き、パラメーターを設定します。</p>
<pre class="prettyprint linenums">
# EXPERIMENTAL: This Setting makes the checksum calculate to 
# the same value it originally was by manipulating an unused 
# section of the bois. This may be needed for the new style
# UEFI vbios. Set this to 1 if you want to preserve the orig
# checksum. Set to 0 for the previous behavior of re-calculating
# the checksum. NOTE: if you're not having driver detection 
# problems leave this at 0.
#
Preserve_Original_Checksum = 0


# Fan settings
# ファン回転数設定（%）
# 上が最少値、下が最大値
Fan_Min = 30
Fan_Max = 100


# Board power settings
# Board power最大設定（%）
Max_Power_Target = 150


# Max Boost Frequency. Uncomment this if you want to change the
# maximum frequency your card will boost to.
# BoostClockの最大値設定（MHz）
Max_Boost_Freq = 1228 ←必ず#を外す（そうしないと、僕の環境では1298MHzが設定されました）


# WARNNING:
# The following are valid voltages. I suggest you 
# use these values rather than coming up with your 
# own. 1212500 is the max and it is normally hard limited. 
# If you go over the max and your board is hard limited
# you may actually get a much lower voltage than you
# expect.
# 電圧設定
# 希望の値の行の#を外す
Voltage = 1187500（1.1875V）
</pre>
<p>&nbsp;</p>
<p>コマンドプロンプトを開き、</p>
<p>cd kgb.exeがあるディレクトリのフルパス</p>
<p>kgb.exeがあるところがCドライブ以外の時（下の例はDドライブの時）はさらに、</p>
<p>D:</p>
<p>と打ちます。そうしたら、</p>
<p>kgb.exe BIOSのファイル名 unlock</p>
<p>と打つと、先程同じディレクトリにコピーしたBIOSが、値の書き換えられたものに上書きされます。</p>
<p>&nbsp;</p>
<h3>BIOSをグラボに書き込む</h3>
<p>NVFlashの圧縮ファイルを展開し、nvflash.exeがあるディレクトリに先程加工したBIOSをコピーします。</p>
<p>コマンドプロンプトを開き、</p>
<p>cd nvflash.exeがあるディレクトリのフルパス</p>
<p>nvflash.exeがあるところがCドライブ以外の時（下の例はDドライブの時）はさらに、</p>
<p>D:</p>
<p>と打ちます。そうしたら、</p>
<p>nvflash.exe --protectoff</p>
<p>nvflash.exe BIOSのファイル名</p>
<p>と打ち、しばらく放置するとBIOS書き換えが完了します。</p>
<p><span style="color:red;">書き込みの間に電源を落としたり、コマンドプロンプトを閉じるときっと死にます。</span></p>
<p>&nbsp;</p>
<p>PCを再起動します。</p>
<p>起動に成功したら、今回のBIOS書き換えは成功です。</p>
<p>FurMark等でエグい負荷をかけ、落ちないようなら大丈夫でしょう。</p>
<p>&nbsp;</p>
<p>BIOSの書き換えは気分的にもDOS上でやりたかったのですが、</p>
<p>面倒くさくてやる気が出なかったのでWindowsからやりました。</p>
<p>日本の自作erの中ではDOSからやるのが一般的なように感じます。</p>
<p>&nbsp;</p>
<p>さて、気が向いたらまた4700MHzまでCPUをオーバークロックしてFFベンチでもまわしましょうか。</p>
<p>ではでは〜</p>
<p>&nbsp;</p>
<p><span style="color:red;"><span style="font-size:24px;">追記（2013/3/19 (Tue) 18:6:29）</span></span></p>
<p><a href="https://picasaweb.google.com/lh/photo/U0KzXHR71oe5dZqdg-efBdMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh6.googleusercontent.com/-brgEI09a-2k/UUgqSnVbYLI/AAAAAAAABvc/i7C0MPBD5TE/s400/10096.png" height="225" width="400" /></a></p>
<p><span style="font-size:24px;">10096キタ———（゜∀゜）———— ！！</span></p>
<p>前回の4700MHZの時の設定から、さらにベースクロックを102MHzにして達成です。</p>
<p>この様子だと電圧盛らずに100MHzx48いけるかな？</p>
<p>&nbsp;</p>
<p>グラボですが、僕の環境では一度落ちました。</p>
<p>AfterBurnerでPowerLimitを上げることで回避できましたが。</p>
<p>&nbsp;</p>
<p>最終的に、ASUS GTX 660 Ti DirectCU II TOPと同じ、BoostClock1137MHzにしたBIOSを焼きました。</p>
<p>&nbsp;</p>