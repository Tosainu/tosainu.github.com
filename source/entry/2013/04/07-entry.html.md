---
title: WBR-B11をイーサーネットコンバータ化した
date: 2013-04-07 17:04:52 JST
---
<p>どーもです</p>
<p>&nbsp;</p>
<p><img src="https://lh5.googleusercontent.com/-wn9ewHUqHWM/UTKmaBT-UjI/AAAAAAAABUc/G58KszEU9og/s640/IMG_0082.JPG" /></p>
<p>自作機2号の通信に使っているBuffalo WLI-UC-GNMがカスな子すぎて使い物になりませんでした。</p>
<p>以前の記事→<a href="http://tosainu.wktk.so/view/256">Buffalo WLI-UC-GNM</a></p>
<p>&nbsp;</p>
<p>なんとかできないかと考えた結果、僕の家には昔使っていたBuffalo WBR-B11がまだあったので、</p>
<p><img src="https://lh3.googleusercontent.com/-3_STouXiXyw/UWEfmW_4AoI/AAAAAAAAB3Y/pHQeAOW6m2g/s640/IMG_0361.JPG" /></p>
<p>こんな感じなネットワークを作ることにしました。</p>
<p><img src="https://lh3.googleusercontent.com/-UMvi0cMQNMo/UWEflobvjMI/AAAAAAAAB3U/Sp5ITADUPQM/s640/out.png" /></p>
<p>&nbsp;</p>
<p>環境</p>
<p>親ルーター：Buffalo WHR-G301n（FW:dd-wrt LocalIP:192.168.1.1）</p>
<p>子ルーター：Buffalo WBR-B11（FW:tomato LocalIP:192.168.1.2）</p>
<p>&nbsp;</p>
<p>やったこと</p>
<p>親ルーターにVirtual Interfaceを一つ作成し、子ルーターからこれに接続。</p>
<p>子ルーターはイーサーネットコンバータとして動作させ、有線でマシンと接続。</p>
<p>&nbsp;</p>
<h3>親ルータ側の設定</h3>
<p>管理ページのWireless→Basic Settingsの下の方にあるAddボタンをクリックし、Virtual Interfaceを一つ作成。</p>
<p>適当なSSIDを設定してSave。</p>
<p>※B11はIEEE802.11 b/gしか対応していないので、Physical InterfaceのWireless Network ModeはNG-Mixedとした。</p>
<p><img src="https://lh6.googleusercontent.com/-EnZtslG1tEw/UWEhtvw-gkI/AAAAAAAAB3o/T1-IrM_BjEM/s640/Screenshot%2520from%25202013-04-07%252016%253A33%253A35.png" /></p>
<p>&nbsp;</p>
<p>Wireless SecurityタブでVirtual Interfaceのセキュリティ設定し、Apply Settingsをクリック。</p>
<p>※今回は実験も兼ねていたので何も設定しなかったが、WEP（B11はWEPしか対応していない）でパスワードをかけて、さらにMACアドレスの制限で子ルーターのみ接続可能にしておく必要があると思われる。</p>
<p>&nbsp;</p>
<h3>子ルーターの設定</h3>
<p>管理ページのBasic→Networkを開き、</p>
<p>LAN</p>
<p>Router IP Address:192.168.1.2（親ルータは192.168.1.1）</p>
<p>&nbsp;</p>
<p>Wireless</p>
<p>Wireless Mode:Wireless Ethernet Bridge</p>
<p>B/G Mode:G Only</p>
<p>SSID:親ルータのVirtual Interfacesと同じもの</p>
<p>Security:親ルータのVirtual Interfacesと同じもの</p>
<p><img src="https://lh6.googleusercontent.com/-vW2Hxk4CPGw/UWEl5JBQcwI/AAAAAAAAB34/VRrZ9O770us/s640/Screenshot%2520from%25202013-04-07%252016%253A50%253A19.png" /></p>
<p>&nbsp;</p>
<p>こうすれば子ルータのLANポートとマシンを接続することで通信することができました。</p>
<p>&nbsp;</p>
<p>試しにSpeedTest.NETで通信速度を測定すると、こんな感じでした。</p>
<p><img src="https://lh5.googleusercontent.com/-Wit4qqfpm7s/UWEm5AsLSLI/AAAAAAAAB4E/R4m134KL1VU/s640/Screenshot%2520from%25202013-04-07%252015-52-57.png" /></p>
<p>下りの契約が約15Mbps、上りが約1Mbpsなので、まあまあな方でしょうか。</p>
<p>&nbsp;</p>
<p>いやー</p>
<p>本当に快適になりました。</p>
<p>異常な発熱も極端な速度低下や切断などは今のところ全くありません。</p>
<p>&nbsp;</p>
<p>心配なのは子ルーターの消費電力とVirtual Interfaceのセキュリティでしょうか。</p>
<p>まあ、いずれはまともな子機をPCに付けてやりたいです。</p>
<p>&nbsp;</p>
