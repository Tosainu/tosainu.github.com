---
title: 【Ubuntu】MySQL-5.5→MariaDB-5.5に移行する
date: 2013-12-29 13:18:12 JST
tags: Linux
---
みょみょみょ

&nbsp;

僕が書く記事にしては珍しいですが、Ubuntu 12.10の記事です。

他の有名ディストリは次々とMariaDBを採用していっていますが、未だUbuntuはアレだったのと、深刻なRAM不足に悩まされている中でmysqldがRAM結構食っていたことから改善しないかなと思い移行してみました。

元々MariaDBはMySQLから派生したものですし、エラーもなく乗り換え出来ました。

&nbsp;

<a href="https://mariadb.org/en/">Welcome to MariaDB! - MariaDB</a>

&nbsp;

```
// インストールされているMySQLのバージョン確認。この環境では5.5でした。
$ mysql -V

// GoodBye MySQL
$ sudo service mysql stop
$ sudo update-rc.d -f mysql remove
$ sudo apt-get remove mysql-common

// Hello MariaDB
$ sudo apt-get install software-properties-common
$ sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
$ sudo add-apt-repository 'deb http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/5.5/ubuntu quantal main'
$ sudo apt-get update
$ sudo apt-get install mariadb-server
// ここでMySQLのrootユーザーのパスワードを入力したり、my.conf書き換えるか尋ねられるのでnを選択したりします。

$ sudo update-rc.d mysql defaults
```

これだけです。簡単簡単。

まだ長時間稼働させていないので詳しいことはわかりませんが、psコマンドで確認するとメモリ使用量は約半分になりました。やったね！

&nbsp;

<span class="fontsize1"><del>(実は間違えてUbuntu12.04のパッケージ入れようとしてaptのDB死にかけたりで時間掛かったとか言えない・・・)</del></span>
