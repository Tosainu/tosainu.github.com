---
title: OpenShift OnlineでNode.jsアプリを動かしてみたよ！(その1)
date: 2014-02-27 23:25:05 JST
tags: JavaScript,Programming
---
どーもですん。

<blockquote class="twitter-tweet" lang="en"><p>【悲報】友人氏に確認取ったらやっぱり鯖の調子おかしかった <a href="http://t.co/QFoRTM0Pcs">pic.twitter.com/QFoRTM0Pcs</a></p>&mdash; サーバ故障(物理) (@tosainu_3930k) <a href="https://twitter.com/tosainu_3930k/statuses/438333734257844224">February 25, 2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

はい、友人宅鯖逝きました。

ってことで、流行のPaaSと呼ばれるものの一種、OpneShift Onlineを試してみました。

[Get Started with OpenShift | OpenShift by Red Hat](https://www.openshift.com/get-started#cli "Get Started with OpenShift | OpenShift by Red Hat")を参考に、Node.jsなアプリケーションを動かしてみます。

READMORE

## Sign up
[Create an account | OpenShift Online by Red Hat](https://www.openshift.com/app/account/new?then=/community/get-started "Create an account | OpenShift Online by Red Hat")

で、メールアドレスやパスワードを入力し登録を行います。すぐに確認のメールが来るので、送られてきたリンク先を開き認証します。

次に、[Sign in to OpenShift Online | OpenShift Online by Red Hat](https://openshift.redhat.com/app/login?then=%2Fcommunity%2Fget-started "Sign in to OpenShift Online | OpenShift Online by Red Hat")からログインします。

これを行わないと、OpenShiftのクライアントツールであるrhcでログインできませんでした。

ログインできたら、とりあえず何もせずページは閉じてもらって構いません。

&nbsp;

## rhcコマンドのインストールと設定
予めPCにはRuby 1.8.7以降、rubygems、gitを入れておきます。

また、後々便利なのでssh鍵も作っておきましょう。

Terminalを開き、

    $ gem install rhc --no-ri --no-rdoc

とするとインストールできます。

相変わらずgemのインストールには時間かかりますねぇ......

次にOpenShift Onlineにrhcコマンドからログインします。

何度か質問されますが、全部yesで良いと思います。

```
$ rhc setup                                                                                                                                                                                                            Feb 27, 2014 11:21:04
OpenShift Client Tools (RHC) Setup Wizard

This wizard will help you upload your SSH keys, set your application namespace, and check that other programs like Git are properly installed.

Login to openshift.redhat.com: [登録したメールアドレス]
Password: ************

OpenShift can create and store a token on disk which allows to you to access the server without using your password. The key is stored in your home directory and should be kept secret.  You can delete the key at any time by running 'rhc
logout'.
Generate a token now? (yes|no) yes
Generating an authorization token for this client ... lasts about 1 month

Saving configuration to /home/username/.openshift/express.conf ... done

Your public SSH key must be uploaded to the OpenShift server to access code.  Upload now? (yes|no) yes

Since you do not have any keys associated with your OpenShift account, your new key will be uploaded as the 'default' key.

Uploading key 'default' ... done

Checking for git ... found git version 1.9.0

Checking common problems .. done

Checking for a domain ... none

Applications are grouped into domains - each domain has a unique name (called a namespace) that becomes part of your public application URL. You may create your first domain here or leave it blank and use 'rhc create-domain' later. You
will not be able to create an application without completing this step.

Please enter a namespace (letters and numbers only) |<none>|: [任意の文字列(今回はtosainu)]
Your domain 'tosainu' has been successfully created

Checking for applications ... none

Run 'rhc create-app' to create your first application.

  Do-It-Yourself 0.1                      rhc create-app <app name> diy-0.1
  JBoss Application Server 7              rhc create-app <app name> jbossas-7
  JBoss Enterprise Application Platform 6 rhc create-app <app name> jbosseap-6
  Jenkins Server                          rhc create-app <app name> jenkins-1
  Node.js 0.10                            rhc create-app <app name> nodejs-0.10
  Node.js 0.6                             rhc create-app <app name> nodejs-0.6
  PHP 5.3                                 rhc create-app <app name> php-5.3
  PHP 5.3 with Zend Server 5.6            rhc create-app <app name> zend-5.6
  PHP 5.4                                 rhc create-app <app name> php-5.4
  PHP 5.4 with Zend Server 6.1            rhc create-app <app name> zend-6.1
  Perl 5.10                               rhc create-app <app name> perl-5.10
  Python 2.6                              rhc create-app <app name> python-2.6
  Python 2.7                              rhc create-app <app name> python-2.7
  Python 3.3                              rhc create-app <app name> python-3.3
  Ruby 1.8                                rhc create-app <app name> ruby-1.8
  Ruby 1.9                                rhc create-app <app name> ruby-1.9
  Tomcat 6 (JBoss EWS 1.0)                rhc create-app <app name> jbossews-1.0
  Tomcat 7 (JBoss EWS 2.0)                rhc create-app <app name> jbossews-2.0

  You are using 0 of 3 total gears
  The following gear sizes are available to you: small

Your client tools are now configured.
```

で設定が完了しました。

&nbsp;

## 試しにNode.jsアプリケーションを動かしてみる
とり何か動かしてみましょう。

```
$ cd /path/to/workdir
$ rhc app create myapp nodejs-0.10                                                                                                                                                                                     Feb 27, 2014 12:11:39
Application Options
-------------------
Domain:     tosainu
Cartridges: nodejs-0.10
Gear Size:  default
Scaling:    no

Creating application 'myapp' ... done


Waiting for your DNS name to be available ... done

Cloning into 'myapp'...
The authenticity of host 'myapp-tosainu.rhcloud.com (72.44.62.62)' can't be established.
RSA key fingerprint is cf:ee:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'myapp-tosainu.rhcloud.com,72.44.62.62' (RSA) to the list of known hosts.

Your application 'myapp' is now available.

  URL:        http://myapp-tosainu.rhcloud.com/
  SSH to:     xxxxxxxxxxxxxxx@myapp-tosainu.rhcloud.com
  Git remote: ssh://xxxxxxxxxxxxxxx@myapp-tosainu.rhcloud.com/~/git/myapp.git/
  Cloned to:  /home/sunausagi/codes/myapp

Run 'rhc show-app myapp' for more details about your app.

$ cd myapp/
$ ls -la
total 72
-rw-r--r-- 1 sunausagi sunausagi   444 Feb 27 12:16 deplist.txt
drwxr-xr-x 8 sunausagi sunausagi  4096 Feb 27 12:17 .git/
-rw-r--r-- 1 sunausagi sunausagi 39635 Feb 27 12:16 index.html
drwxr-xr-x 2 sunausagi sunausagi  4096 Feb 27 12:16 node_modules/
drwxr-xr-x 5 sunausagi sunausagi  4096 Feb 27 12:16 .openshift/
-rw-r--r-- 1 sunausagi sunausagi   666 Feb 27 12:16 package.json
-rw-r--r-- 1 sunausagi sunausagi   175 Feb 27 12:16 README.md
-rwxr-xr-x 1 sunausagi sunausagi  4631 Feb 27 12:16 server.js*

```

myapp-tosainu.rhcloud.comにアクセスすると、"Welcome to your Node.js application on OpenShift"といったページが表示されてると思います。

やったぜ。

&nbsp;

## httpやMySQLを動かしてみる
かなーーーりハマりました。

### http関連
.listenに、ipとポートを設定しないとこのようなエラーが出てしまいます。

```
events.js:72
        throw er; // Unhandled 'error' event
              ^
Error: listen EACCES
    at errnoException (net.js:884:11)
    at Server._listen2 (net.js:1003:19)
    at listen (net.js:1044:10)
    at Server.listen (net.js:1110:5)
    at Object.<anonymous> (/path/to/app/server.js:58:24)
    at Module._compile (module.js:456:26)
    at Object.Module._extensions..js (module.js:474:10)
    at Module.load (module.js:356:32)
    at Function.Module._load (module.js:312:12)
    at Function.Module.runMain (module.js:497:10)
```

なので、このようにしてやります。

```javascript
var http = require('http');

var ip_addr = process.env.OPENSHIFT_NODEJS_IP   || '127.0.0.1';
var port    = process.env.OPENSHIFT_NODEJS_PORT || '8080';

http.createServer(hoge).listen(port, ip_addr, function(){
  console.log('Server Working!!'));
});
```

&nbsp;

### MySQLのCartridgeの追加とnode-mysqlでの接続
まず、MySQLのCartridgeを追加します。

```
$ rhc add-cartridge mysql-5.5                                                                                                                                                                                          Feb 27, 2014 13:47:52
Adding mysql-5.5 to application 'myapp' ... done

mysql-5.5 (MySQL 5.5)
---------------------
  Gears:          Located with nodejs-0.10
  Connection URL: mysql://$OPENSHIFT_MYSQL_DB_HOST:$OPENSHIFT_MYSQL_DB_PORT/
  Database Name:  myapp
  Password:       xxxxxx
  Username:       xxxxxx

MySQL 5.5 database added.  Please make note of these credentials:

       Root User: xxxxxx
   Root Password: xxxxxx
   Database Name: myapp

Connection URL: mysql://$OPENSHIFT_MYSQL_DB_HOST:$OPENSHIFT_MYSQL_DB_PORT/

You can manage your new MySQL database by also embedding phpmyadmin.
The phpmyadmin username and password will be the same as the MySQL credentials above.
```

そして、Node.jsコードはこんな感じになります。

先ほどのコマンド実行後に表示されたパスワード等を直接設定してもよいですが、環境変数を設定してやると便利です。

```javascript
var my = require('mysql').createConnection({
  host: process.env.OPENSHIFT_MYSQL_DB_HOST,
  database: process.env.OPENSHIFT_GEAR_NAME,
  user: process.env.OPENSHIFT_MYSQL_DB_USERNAME,
  password: process.env.OPENSHIFT_MYSQL_DB_PASSWORD
});
var query = "select * from table;";
my.query(query, function(err, user) {
  hogehoge
});
```

すいません、もっと書くことあるのですが、次記事に回します

ではでは〜
