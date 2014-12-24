---
title: Webサイトデザインのこと
date: 2013-05-06 09:50:13 JST
tags: Website
---
<p>どーもです。</p>
<p>&nbsp;</p>
<p>僕、結構細かいこと気にするタイプで、</p>
<p>写真を撮るときは何度も撮り直しますし（でも写真が微妙なのは許してヒヤシンス）、</p>
<p>部屋もしょっちゅう模様替えしたり、とあるPCのエラーが治るまで何時間もPCの前に座っていることもよくあります。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><span style="font-size:24px;">今の自分のサイトデザインが許せない</span></p>
<p>&nbsp;</p>
<p>ってことです。</p>
<p>&nbsp;</p>
<p>「いや、別にブログのデザインくらいどーでもいじゃなイカ」</p>
<p>っていう人もいるかもしれませんが、僕そういう性格なんで・・・</p>
<p>&nbsp;</p>
<p>今のデザインの気に入らないことを挙げるとするならば、</p>
<h3>コードが汚い</h3>
<p>ほんっっっっとうに汚いです。クラス名の定義とかは恥ずかしくて見せられないです。</p>
<p>「top_page」というクラス名が、サイトのトップページ関係に見えて、「ページの上部へ」のボタンだったこともありました。</p>
<p>&nbsp;</p>
<p>数年前からHTMLとかCSS、VBとかCなんか書いてますが、</p>
<p>最近になって、やたはら自分で定義する名前にこだわりはじめてしまったみたいです。</p>
<p>a、i、kekka、dainyuu、そんな変数名論外です。</p>
<p>一目見て「〇〇の△△の設定項目だ」と分かるものにしたいです。</p>
<p>&nbsp;</p>
<h3>すべてのページを自分で書いている</h3>
<p>ちょっと良くわからないことかもしれませんが、このサイトの管理には<a href="http://freo.jp/">freo</a>というのを使っています。</p>
<p>自分が書くのは記事だけで、記事の目次などは動的に作成られ、設定したテンプレートに合わせて表示してくれる便利なものです。</p>
<p>特に、このようなものを自分が借りているサーバーでやると、拡張性がすごく高いので大好きです。</p>
<p>&nbsp;</p>
<p>ですが、例えば目次のページを見てください。</p>
<p>これ、自分でページ管理からタグを打って書いたものです。</p>
<p>せっかくfreoには「記事一覧を表示」とか「記事の画像を取得」などがテンプレートの段階で作成できるというのにもったいないです。</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>これらを踏まえて、こんな感じのデザインにしようと思います。</p>
<h3>レスポンシブWebデザイン</h3>
<p>Webデザインの世界では今の流行らしいです。</p>
<p>例えば、<a href="http://skinnyties.com/">このサイト</a>のように、PC、タブレット、スマートフォン等、様々なデバイスに最適化したページを同じHTML、CSSでやってしまおうってものです。</p>
<p>先ほど挙げたサイトの横幅を変えていくと・・・</p>
<p><a href="https://picasaweb.google.com/lh/photo/K1m86psve-W_zgPmGmLdodMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh5.googleusercontent.com/-LsIfc37tnDg/UYb6Z6IncFI/AAAAAAAACEY/ppPBNcwAx9U/s400/Screenshot%2520from%25202013-05-06%252009%253A25%253A54.png" height="289" width="400" /></a></p>
<p>&nbsp;</p>
<p><a href="https://picasaweb.google.com/lh/photo/SQzyg2Vo9VR1cAdcrwzHm9MTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh4.googleusercontent.com/-lVbQjJMQrcs/UYb6aDtVsMI/AAAAAAAACEc/LF0oCeN5FgU/s400/Screenshot%2520from%25202013-05-06%252009%253A26%253A07.png" height="334" width="400" /></a></p>
<p>&nbsp;</p>
<p><a href="https://picasaweb.google.com/lh/photo/JKTVwutRwPSafSBdnVxsitMTjNZETYmyPJy0liipFm0?feat=embedwebsite"><img src="https://lh3.googleusercontent.com/-9LAwL5NKbZc/UYb6Znm6T4I/AAAAAAAACEU/Pz7J55sf1XM/s400/Screenshot%2520from%25202013-05-06%252009%253A26%253A20.png" height="400" width="239" /></a></p>
<p>というように、同じページなのに、様々なデザインに変化していきます。</p>
<p>このサイトはスマートフォンからアクセスしている方も多いらしいので、またfreo公式の初期デザインがレスポンシブWebデザインになったようなので、これを機に導入してみようと思います。</p>
<p>&nbsp;</p>
<h3>見出しの統一</h3>
<p>デザインに詳しい方がこのサイトを見るとすぐ気がつく気がしますが、見出しが統一されていません。</p>
<p>トップページの場合、サイドバーの見出しはh3タグ、メインページの大見出しはh2ですが、どちらも同じグラデーションがかかっています。</p>
<p>また、メール送信ページなどの一番上にある見出しはh1です。このデザインは地味すぎます。</p>
<p>&nbsp;</p>
<p>次のデザインでは、この辺にもこだわりたいと思います。</p>
<p>&nbsp;</p>
<p>まだ気になるところはいっぱいありますが、今日挙げるのはこれくらいにしておきます。</p>
<p>とはいえ、そろそろテストも近いので更新減らさなきゃな・・・</p>
<p>&nbsp;</p>
<p>ではでは〜</p>