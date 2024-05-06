---
title: Steam版GTAIV 日本語化・asiModとかの備忘録
date: 2013-07-18 23:17:22+0900
noindex: true
---
<p>どーもです。</p>
<p>&nbsp;</p>
<p>GTASAに続き、GTAIVをちまちまプレイ中です。</p>

![](./GTAIV_2013-07-14_14-45-16-29.png)


![](./GTAIV_2013-07-18_21-17-04-89.png)

<p>さっき銀行強盗ミッションをやっとクリアしたところです。</p>
<p>いやぁ、大変だった。</p>
<p>&nbsp;</p>
<p>さて、僕は安さにつられてGTAIVをSteamで買いました。</p>

![](./E5908DE7A7B0E69CAAE8A8ADE5AE9A_1.png)

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

![](./E5908DE7A7B0E69CAAE8A8ADE5AE9A_2.png)

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

![](./E5908DE7A7B0E69CAAE8A8ADE5AE9A_3.png)

<p>右クリックで新規→文字列値</p>

![](./E5908DE7A7B0E69CAAE8A8ADE5AE9A_4.png)

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

![](./GTAIV_2013-07-14_14-45-16-29_2.png)

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

![](./GTAIV_2013-05-18_12-35-45-02.png)

<p>&nbsp;</p>
<p>ではでは～</p>
