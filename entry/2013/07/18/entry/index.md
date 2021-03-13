---
title: Steam版GTAIV 日本語化・asiModとかの備忘録
date: 2013-07-18 23:17:22+0900
noindex: true
tags: Game
---
<p>どーもです。</p>
<p>&nbsp;</p>
<p>GTASAに続き、GTAIVをちまちまプレイ中です。</p>
<p><img src="https://lh3.googleusercontent.com/-p-NeWyacZGw/Uefj9bbK2gI/AAAAAAAACbw/c6t8clUg_Gs/s640/GTAIV%25202013-07-14%252014-45-16-29.png" /></p>
<p><img src="https://lh4.googleusercontent.com/-3GD_PD_i1NI/UefkHGcEeYI/AAAAAAAACb4/2tA-zLF9crs/s640/GTAIV%25202013-07-18%252021-17-04-89.png" /></p>
<p>さっき銀行強盗ミッションをやっとクリアしたところです。</p>
<p>いやぁ、大変だった。</p>
<p>&nbsp;</p>
<p>さて、僕は安さにつられてGTAIVをSteamで買いました。</p>
<p><img src="https://lh6.googleusercontent.com/-GUBoxVbBFWM/UefmqA7CXtI/AAAAAAAACcI/bqNDnL6Ao1U/s640/%25E5%2590%258D%25E7%25A7%25B0%25E6%259C%25AA%25E8%25A8%25AD%25E5%25AE%259A%25201.png" /></p>
<p>ですが、Mod追加等でちょっと戸惑ったので、メモしておきます。</p>
<p>&nbsp;</p>
<h3>まず・・・</h3>
<p>SteamからGTAIVをインストールしたら、まず何もいじらずGTAIVを起動します。</p>
<p>初期設定とかでいろいろ起動に時間がかかります。</p>
<p>&nbsp;</p>
<p>タイトルが表示されたら「QUIT」を選んでゲームを終了します。</p>
<p>&nbsp;</p>
<h3>xlivelessの導入</h3>
<p>いずれMod入れて遊ぶ予定だし、マイ糞ソフトのアカなん使いたくない。さらに、プレイ中Liveがどーのこーの鬱陶しいし、セーブデータが面倒な場所に保存されてしまいますので、Liveを無効化するMod「xliveless」を導入します。</p>
<p>&nbsp;</p>
<p>まず、↓からxliveless-0.999b7.rarをダウンロード、解凍します。</p>
<p><a href="http://www.gtaforums.com/?showtopic=388658">GTAForums.com -> [REL|GTAIV] XLiveLess</a></p>
<p><a href="https://dl.dropboxusercontent.com/u/55743933/xliveless-0.999b7.rar">勝手にミラー</a></p>
<p>&nbsp;</p>
<p>解凍した中にある<span style="color:red;">xlive.dll</span>をGTAIVのインストールフォルダに突っ込みます。</p>
<p>ほかのファイルは入れてはいけません。</p>
<p><img src="https://lh5.googleusercontent.com/-buqZd-meCZo/Uefr8Ww8lrI/AAAAAAAACcc/sdovdQIRa5s/s640/%25E5%2590%258D%25E7%25A7%25B0%25E6%259C%25AA%25E8%25A8%25AD%25E5%25AE%259A%25202.png" /></p>
<p>GTAIVのインストール先ですが、Steamをインストールしたフォルダの中にあります。</p>
<p>インストール先を自分で変えていなければここ↓にあるはずです。</p>
<p>C:\Program Files (x86)\Steam\SteamApps\common\Grand Theft Auto IV\GTAIV</p>
<p>&nbsp;</p>
<p>これでLiveは無効化されました。</p>
<p>そして、セーブデータは</p>
<p>Documents\Rockstar Games\GTA IV\savegames</p>
<p>に保存されるようになります。</p>
<p>&nbsp;</p>
<h3>日本語字幕化</h3>
<p>最初はAll Englishでがんばろうとしましたが、</p>
<p>&nbsp;</p>
<p><span style="font-size:36px;">無理</span></p>
<p>&nbsp;</p>
<p>ってことで日本語字幕化します。</p>
<p>&nbsp;</p>
<p>GTAIVインストールフォルダにあるcommon\textの中に、american.gxtというファイルがあります。</p>
<p>これを適当にリネーム（僕はbak_american.gxt）します。</p>
<p>そして、同じフォルダにあるjapanese.gxtをamerican.gxtにリネームします。</p>
<p>&nbsp;</p>
<p>これで一応日本語字幕化は成功なのですが、おそらく文字化けすると思います。</p>
<p>&nbsp;</p>
<p>対処法として、まずレジストリエディタを開きます。</p>
<p>キーボードのWindowsロゴ＋Rキーでファイル名を指定して実行を開き、regeditと入力してEnterです。</p>
<p></p>
<p>64bit：HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Rockstar Games\Grand Theft Auto IV</p>
<p>32bit：HKEY_LOCAL_MACHINE\SOFTWARE\Rockstar Games\Grand Theft Auto IV</p>
<p>を開き、</p>
<p><img src="https://lh4.googleusercontent.com/-bG0FtmtqrM4/UefxH151cdI/AAAAAAAACc0/ckxmefW4zP4/s640/%25E5%2590%258D%25E7%25A7%25B0%25E6%259C%25AA%25E8%25A8%25AD%25E5%25AE%259A%25203.png" /></p>
<p>右クリックで新規→文字列値</p>
<p><img src="https://lh3.googleusercontent.com/-qyOLGCK_j0c/UefxH1YsnoI/AAAAAAAACcw/f1vI2I2a1Eo/s640/%25E5%2590%258D%25E7%25A7%25B0%25E6%259C%25AA%25E8%25A8%25AD%25E5%25AE%259A%25204.png" /></p>
<p>名前をINSTALL_LANG、値を1041にします。</p>
<p>&nbsp;</p>
<p>これで文字化けは解消されたはずです。</p>
<p>なお、<span style="color:red;">英語字幕の時にプレイしたときのセーブデータは日本語化すると読み込めなくなる</span>ようなので注意してください。</p>
<p>僕も序盤でしたがやり直しました・・・</p>
<p>&nbsp;</p>
<p>参考：<a href="http://wikiwiki.jp/gta4pc/?%C6%FC%CB%DC%B8%EC%B2%BD">日本語化 - Grand Theft Auto 4 PC Wiki*</a></p>
<p>&nbsp;</p>
<h3>Speedometer IVの導入</h3>
<p>スピードメーターです。なぜか入れたくなるんですよねぇ・・・</p>
<p><img src="https://lh4.googleusercontent.com/-9tx7Diw9x6c/Uefz9rriQ8I/AAAAAAAACdE/FYfWmaHm9O0/s640/GTAIV%25202013-07-14%252014-45-16-29.png" /></p>
<p>&nbsp;</p>
<p>これと</p>
<p><a href="http://www.gtaforums.com/index.php?showtopic=420021">GTAForums.com -> [WIP|SCR|IV] Speedometer IV</a></p>
<p>これ</p>
<p><a href="http://www.gta-modding.com/area/index.php?act=view&id=598">GTA-Modding.com - Download Area » GTA IV » Mods » HUD Speedometer</a></p>
<p>またはこれ</p>
<p><a href="https://dl.dropboxusercontent.com/u/55743933/SpeedometerIVv03a_and_HUD_Speedometer.rar">勝手にまとめたー</a></p>
<p>をダウンロード、解凍。</p>
<p>SpeedometerIVv03a.rarからScriptHook.dll、SpeedoIV.asiをインストールフォルダに突っ込み、</p>
<p>さらにSpeedoIVという名前でフォルダを作成し、その中に598_hud_speedometer.rarのDefaultフォルダとConfig.iniを突っ込みます。</p>
<p>これで画像のようなスピードメーターが乗り物に乗ると表示されるはずです。</p>
<p>&nbsp;</p>
<p>このスピードメーターModにはいろいろテーマがあるので、好みのものを探してみるといいかもしれません。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>とりあえず僕がGTAIVをインストールしてからやったことはこんな感じです。</p>
<p>タイトル画面の表示がおかしいので、現在情報収集中です。プレイに支障はないですが。</p>
<p>&nbsp;</p>
<p>それにしてもMod入れにくくなりましたね。</p>
<p>一度試しにレミリアスキンModを入れてみましたが・・・面倒すぎです。</p>
<p><img src="https://lh6.googleusercontent.com/-q2gKPKbzQzU/Uef4akqYT0I/AAAAAAAACdU/sLVoVKKu8ZU/s640/GTAIV%25202013-05-18%252012-35-45-02.png" /></p>
<p>&nbsp;</p>
<p>ではでは～</p>
