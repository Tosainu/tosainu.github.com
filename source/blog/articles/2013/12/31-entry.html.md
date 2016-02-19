---
title: 2013年まとめの挨拶＆muninがやっと動いたのでメモ
date: 2013-12-31 22:59:23 JST
tags: Linux,Diary
---
大晦日ですねぇ・・・

今年も、私「とさいぬ」、そして「とさいぬの隠し部屋」をいろいろしていただきありがとうございました。

ついったーも始め、よりいろいろな方と交流できるようになったり、とても充実した1年でした。

来年もよろしくお願いします。

&nbsp;

タイトル通りです。興味がある方だけ続きをどうぞ。

技術系記事連続で申し訳ないです・・・

READMORE

正直、自分でも原因がよくわかっていないのですが、長い間悩んできたmuninがやっと動いてくれました。

忘備録程度にまとめておこうと思います。

なんせVirtualhostやReverseproxyを多用した副雑な環境ですので、構築にとても時間がかかってしまいました・・・

/etc/munin/munin.conf

デフォルト設定から以下の項目をコメントアウト・編集

```
dbdir	/var/lib/munin
htmldir /var/www/munin
logdir /var/log/munin
rundir  /var/run/munin

graph_strategy cgi

cgiurl_graph /cgi-bin/munin-cgi-graph

html_strategy cgi

# a simple host tree
[YourHostName]
    address 127.0.0.1
    use_node_name yes
```

&nbsp;

/etc/apache2/sites-available/munin

このファイルは/etc/apache2/sites-enabled/hogeにシンボリックリンクを張っておきます

```
<VirtualHost *:1234>
ServerName 123.456.789.012:1234

DocumentRoot /var/www/munin

Alias /cgi-bin/static /var/www/munin
ScriptAlias /cgi-bin /usr/lib/cgi-bin/munin-cgi-html

<Directory />
Options FollowSymLinks
AllowOverride None
Order deny,allow
Allow from All
Deny from all
</Directory>

<Directory /var/www/munin>
Order allow,deny
Allow from all
Options None

<IfModule mod_expires.c>
ExpiresActive On
ExpiresDefault M310
</IfModule>

</Directory> 

<Location /cgi-bin/munin-cgi-graph>
<IfModule mod_fastcgi.c>
SetHandler fastcgi-script
</IfModule>
</Location>

<Location /cgi-bin/munin-cgi-html>
<IfModule mod_fastcgi.c>
SetHandler fastcgi-script
</IfModule>
</Location>

ErrorLog ${APACHE_LOG_DIR}/error_munin.log
LogLevel warn
CustomLog ${APACHE_LOG_DIR}/access_munin.log combined
</VirtualHost>
```

&nbsp;

/etc/nginx/sites-available/munin

同様に、/etc/nginx/sites-enabled/hogeにシンボリックリンクを張っておきます

```
server {
server_name  munin.YourDomain;

location / {
  proxy_pass http://127.0.0.1:1234;
  proxy_set_header Host  $host;
  proxy_set_header X-Real-IP  $remote_addr;
  proxy_set_header X-Forwarded-Host  $host;
  proxy_set_header X-Forwarded-Server  $host;
  proxy_set_header X-Forwarded-For  $proxy_add_x_forwarded_for;
 }
}
```

&nbsp;

何かアレなことがあるかもれませんが、これで動きました。

もう下手に弄ってまた動かなくなるとつらみでしかないのでやめておきます。

&nbsp;

ディレクトリ、パーミッション、所有者などは環境に合わせて調整してください。

&nbsp;

ではでは〜
