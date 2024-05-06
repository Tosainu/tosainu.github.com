---
title: metaタグでページ説明を追加した
date: 2013-04-08 14:03:50+0900
noindex: true
tags:
  - Website
---
<p>どーもー</p>
<p>ついカッとなってプレミアム会員になっちゃったとさいぬです。</p>

![](./Screenshot_from_2013-04-08_13:42:07.png)

<p>&nbsp;</p>
<p>Webサイト管理者にとって何より重要なことはページをより多くの人に見てもらうことだと思っています。</p>
<p>そのために、</p>
<ul>
<li>検索サイトの検索結果上位からアクセスできるようにする</li>
<li>自サイトを紹介できるサイト（ex:ブログのランキングサイト）に登録する</li>
<li>それなりに記事を更新する</li>
</ul>
<p>などを意識してたりします。</p>
<p>&nbsp;</p>
<p>今朝、アドレス変更したこのサイトがちゃんとGoogleに登録されているか確認したんですが、</p>

![](./Screenshot_2013-04-08-08-34-22.png)

<p>うん、ちゃんと変更後のアドレスが登録されてるね・・・</p>
<p>&nbsp;</p>

![](./Screenshot_2013-04-08-08-34-222.png)

<p><span style="font-size:36px;">ん！？</span></p>
<p>&nbsp;</p>
<p>これって絶対左側に設置してるブログパーツだよね・・・</p>
<script src="http://makomayo.com/flash/blogparts/hakureichan/hakureichan.js" type="text/javascript"></script><br><a href="http://makomayo.com/" title="博麗ちゃんの賽銭箱" target="_blank">まよねーず工場</a>
<p>&nbsp;</p>
<p>とりあえず対処方法としてトップページにメタタグを使ってサイト説明を指定するようにします。</p>
<p><u>※これはfreoでの場合だからね！！</u></p>
<p>templates/header.htmlのheadの中に、</p>
<pre class="prettyprint linenums">
&lt;!--{if $smarty.request.freo.mode == 'default'}--&gt;
&lt;meta name="description" content="{$freo.config.basis.description}" /&gt;
&lt;!--{/if}--&gt;
</pre>
<p>を追加します。</p>
<p>これは、トップページが読み込まれた時だけ</p>
<pre class="prettyprint linenums">
&lt;meta name="description" content="{$freo.config.basis.description}" /&gt;
</pre>
<p>を表示させるようにするってことです。</p>
<p>ちなみに、{$freo.config.basis.description}は、タイトルの下にある短い文章を取得する記述です。</p>
<p>&nbsp;</p>
<p>うーん、トップページは何とかなったけど、</p>
<p>サブページの説明文もメチャクチャなんだよな〜</p>
<p>&nbsp;</p>
<p>左側に表示されるカレンダーの部分である</p>
<p>日, 月, 火, 水, 木, 金, 土. -, -, -, -, -, 1, 2. 3, 4, 5, 6, 7, 8, 9 ...</p>
<p>が表示されてたり、</p>
<p>そもそも表示される記事が古かったり。（今は2008年のページが表示されてますね・・・）</p>
<p>&nbsp;</p>
<p>これからどうしよう・・・</p>
