---
title: ブログを Hakyll に移行した
date: 2018-03-21 22:44:00+0900
tags: Haskell, Hakyll, Website
---

[Middleman](https://middlemanapp.com/) で構築していたこのブログを、Haskell 製の静的サイトジェネレータである [Hakyll](https://jaspervdj.be/hakyll/) に移行しました。

<!--more-->

## 移行した理由

主な理由は次の通り

- **Middleman 4.x になってからの不安定さに耐えられなくなった**
- 以前から Hakyll 興味があった
- 普段書かない言語で設定を書くのはつらい

この中でも、特に1つ目の要因が大きいです。

まず、重くなりました。以前 Travis CI 上で数分で済んでいた記事のビルドが、今では10分を超えることもあります。また、Middleman ではページの変更を監視してプレビューに反映させる Livereload を利用できるのですが、これも今では10~20秒程度 CPU 食いつぶさないと反映されなくなってしまいました。

なかなか Middleman から移行できなかった理由でもあるフロントエンドライブラリの扱いやすさ (`Gemfile` に記述するだけで利用できる、Rails のおかげで gem も豊富) も微妙になってしまいました。この機能を実現していた部分が middleman-sprockets に分離され、またその利用はあまり推奨されなくなりました。その middleman-sprockets も、初期は middleman が起動しなくなるほど不安定で、そこそこ動くようになってからも gem の種類やバージョンの違いでフロントエンドライブラリがロードできたりできなかったりで、更新のたびに動作する組み合わせを探さないといけないのは不満でした。

## 移行してみて

### Hakyll の Rules

Hakyll では、「どのファイルを、どう加工して、どこに出力するか」という設定 (rule) を、出力するファイル全てに対して記述する必要があります。例えばこんな感じ。

```haskell
main :: IO ()
main = hakyll $ do
  -- css/ 下のファイルを、minify して、/css/* に出力
  match "css/*" $ do
    route   idRoute
    compile compressCssCompiler

  -- entry/ 下の Markdown ファイルを、pandoc で変換して、/entry/*.html に出力
  match "entry/*.md" $ do
    route $ setExtension "html"
    compile pandocCompiler
```

このため、複雑な設定ができる反面、出力先を指定するだけのような Middleman と比較すると記述量は多くなります。コード書くのは好きなので記述量が増えるのはいいのですが、Middleman で実現していたものと同じ出力をする rule を記述するのは、Hakyll が初めてということもあってちょっと大変でした。

この Rules の設定をもとに、Hakyll では対象の依存関係を調べ、ページを更新するかなどの判断をしているようです。この依存関係の管理が賢くて驚きました。例えばこんな rule があったとします。

```haskell
match "posts/*" $ do
  route $ setExtension "html"
  compile $ do
    posts <- recentFirst =<< loadAll "posts/*"
    let ctx = listField "posts" postCtx (return posts)
            <> postCtx

    pandocCompiler
      >>= loadAndApplyTemplate "templates/post.html"    ctx
      >>= loadAndApplyTemplate "templates/default.html" ctx
      >>= relativizeUrls
```

これを実行してみると、こんなエラーをだして終了します

    $ stack exec myon rebuild
    Removing _site...
    Removing _cache...
    Removing _cache/tmp...
    Initialising...
      Creating store...
      Creating provider...
      Running rules...
    Checking for out-of-date items
    Compiling
      updated templates/default.html
      updated about.rst
      [ERROR] Hakyll.Core.Runtime.chase: Dependency cycle detected: posts/2015-08-23-example.markdown depends on posts/2015-08-23-example.markdown

`"posts/*"` に対する rule の中で `"posts/*"` の情報を取得しているので、自身が自身に依存するという状況ができてしまいます。このような依存関係のループも検出してくれるみたいです。

ちなみに、このようなルールを実現したいときは、コンパイルの途中の結果を保存しておく snapshot を利用すると良さそうです。

```haskell
match "posts/*" $ do
  route $ setExtension "html"
  compile $ do
    -- pandoc でコンパイルした結果を "content" という名前で snapshot を取る
    r <- pandocCompiler
      >>= saveSnapshot "content"

    -- "posts/*" の記事の "content" という名前の snapshot を読み込む
    posts <- recentFirst =<< loadAllSnapshots "posts/*" "content"
    let ctx = listField "posts" postCtx (return posts)
            <> postCtx

    -- コンパイルの続き
    loadAndApplyTemplate "templates/post.html" ctx r
      >>= loadAndApplyTemplate "templates/default.html" ctx
      >>= relativizeUrls
```

### Pandoc の拡張

Markdown はたくさんの方言があることで有名です。Hakyll が記事のビルドに使っている Pandoc も特徴的な Markdown を実装している処理系の1つで、[Pandoc User’s Guide](https://pandoc.org/MANUAL.html) にはたくさんの拡張が紹介されています。基本的な文法[^2]に大きく手を加えているようなことはないようで、記事の修正はほとんどいらなかった[^3]のは助かりました。

[^2]: 何を基本的な文法とするかは微妙だけど...

[^3]: ネストしたリストの小要素のインデントが4文字じゃないといけなかった点と、Middleman 時代に数式表示のために加えていた拡張の修正はした

Hakyll における Pandoc の拡張の有効無効は、[`pandocCompilerWith`](https://hackage.haskell.org/package/hakyll-4.11.0.0/docs/Hakyll-Web-Pandoc.html#v:pandocCompilerWith) を使って任意の [`ReaderOptions`](https://hackage.haskell.org/package/pandoc-2.1/docs/Text-Pandoc-Options.html#t:ReaderOptions) と [`WriterOptions`](https://hackage.haskell.org/package/pandoc-2.1/docs/Text-Pandoc-Options.html#t:WriterOptions) を渡してやることで実現できます。例えばこのブログでは、こんな感じの `ReaderOptions` を設定しています。

```haskell
main :: IO ()
main = hakyll $ do
  match "posts/*" $ do
    route $ setExtension "html"
    compile $ pandocCompilerWith readerOptions writerOptions

    -- ...

readerOptions :: ReaderOptions
readerOptions = defaultHakyllReaderOptions
  { readerExtensions = enableExtension  Ext_east_asian_line_breaks $
                       enableExtension  Ext_emoji $
                       disableExtension Ext_citations $
                       readerExtensions defaultHakyllReaderOptions
  }

writerOptions :: WriterOptions
writerOptions = -- ...
```

`Ext_emoji` 拡張は、`:sushi:` を :sushi: に変えてくれるものです。また `Ext_citations` 拡張を無効にしているのは、`[@myon___](https://twitter.com/myon___)` のような `@` で始まるリンクを貼ろうとしたときにこっちの文法が呼び出されてしまったためです。

ちなみに、先程の例では `WriterOptions` を省略していますが、`ReaderOptions` も `WriterOptions` もたくさん設定があるので、どちらも一度確認してみるといいと思います。例えばこのブログでは、`WriterOptions` の `writerHTMLMathMethod` に `KaTeX` を設定しています。この設定をすると、本文中の数式を `math` class のついた `div` や `span` で囲ってくれます。[Middleman 時代には独自の拡張を加えていましたが](/entry/2016/07/03/new-design/)、この辺がデフォルトで対応しているのはいいですね。

### 記事のビルドは早くなったけど...

Hakyll に移行した結果、予想通り記事のビルドは早くなりました。Middleman のときとほぼ同じ構成のページを出力するように設定して手元の環境で比較してみたところ、Middleman が約5分30秒、Hakyll が約1分30秒という感じでした。複雑なルールなだけあって Hakyll の Example と比較するとかなり速度が落ちてしまいましたが、それでも十分早いです。処理自体もそこまで重いものではなく、CPU のコア全てに負荷がかかったりしないのもいいですね。

ただし、Hakyll では記事をビルドする前に、自分の設定ファイルと Hakyll をはじめとする依存パッケージをビルドする必要があります。Hakyll は Pandoc のような大きなパッケージにも依存しているので、初回のビルド時間全体で比較すると Hakyll のほうが確実に時間が掛かってしまいます。そこはまぁ、仕方ないですね...

### Travis CI でのビルドが out of memory / maximum time limit で失敗する

<blockquote class="twitter-tweet tw-align-center" data-lang="en"><p lang="ja" dir="ltr">えぇ... / <a href="https://t.co/JReauEoUdA">https://t.co/JReauEoUdA</a></p>&mdash; (✿╹◡╹)ﾉ (@myon___) <a href="https://twitter.com/myon___/status/975649670222397441?ref_src=twsrc%5Etfw">March 19, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

最初に Travis CI 上でビルドさせてみたところ、依存パッケージのビルドがこんなメッセージを出して失敗しました。

    --  While building custom Setup.hs for package Cabal-2.0.1.1 using:
          /home/travis/.stack/setup-exe-cache/x86_64-linux/Cabal-simple_mPHDZzAJ_2.0.1.0_ghc-8.2.2 --builddir=.stack-work/dist/x86_64-linux/Cabal-2.0.1.0 build --ghc-options " -ddump-hi -ddump-to-file"
        Process exited with code: ExitFailure (-9) (THIS MAY INDICATE OUT OF MEMORY)
        Logs have been written to: /home/travis/build/Tosainu/blog/.stack-work/logs/Cabal-2.0.1.1.log

[Build Environment Overview - Travis CI](https://docs.travis-ci.com/user/reference/overview/) によれば Container-based 環境の Memory の欄は **4GB max** となっていました。起動の速さから Container-based 環境を利用していましたが、7.5GB 使える Sudo-enabled 環境に切り替えることにしました。

で、これで解決するかと思いきや... [Build #118 - Tosainu/blog - Travis CI](https://travis-ci.org/Tosainu/blog/builds/355674436#L1741)

    The job exceeded the maximum time limit for jobs, and has been terminated.

今度はビルドの最終段階でこんなメッセージを出してジョブが中断されてしまいました。あとキャッシュをアップロードするだけじゃん...

結局、この問題は [Haskell-jp Blog](https://github.com/haskell-jp/blog) でやっているような方法で解決できました。Beta 機能の [Build Stages](https://docs.travis-ci.com/user/build-stages/) を使って Job を分割し、Out of memory しちゃう Cabal や時間のかかる Panoc のビルドを別々に行うというものです。`.travis.yaml` の一部を載せるとこんな感じ。

```yaml
sudo: false
dist: trusty

language: generic

install:
  - stack のインストールとかする

jobs:
  include:
    - stage:  install npm packages
      script: npm install

    - stage:  build cabal
      script: stack --no-terminal build -j 1 Cabal
    - stage:  build pandoc
      script: travis_wait 30 stack --no-terminal build pandoc
    - stage:  build other dependencies
      script: stack --no-terminal build  --only-dependencies

    - stage: deploy site
      script: ...

cache:
  directories:
    - $HOME/.stack
    - .stack-work
    - node_modules
```

時間のかかるビルドは Travis CI で問題になりそうだなあと予想はしていたけど、ここまで苦労することになるとは思わなかった...

あと、これはまだ検証していないけれども、[Cron Jobs](https://docs.travis-ci.com/user/cron-jobs/) で定期的にビルドを回してキャッシュを更新し続けるのもやってみようかなと思っています。記事を追加しただけなのにキャッシュの期限が切れてて全体の再ビルドが掛かったりするのは (╯•﹏•╰) なので。

## その他いろいろ

### テンプレートに Lucid を使いたい

Hakyll には独自のテンプレートエンジンが実装されていますが、せっかくなので以前 Haskell のプロの方が紹介していた[^1]テンプレートエンジンである [Lucid](https://github.com/chrisdone/lucid) を使ってみることにしました。Lucid は、こんな感じに HTML を出力することができるパッケージです。

```haskell
λ> :m +Lucid Data.Monoid 
λ> div_ (p_ ("hello, " <> strong_ "World!")) :: Html ()
<div><p>hello, <strong>World!</strong></p></div>
```

[^1]: 今確認したら記事消えてた...

[lfairy さんの Github pages](https://github.com/lfairy/lfairy.github.io) が Lucid を使ってテンプレートを書いていたので、これを参考にさせてもらいました。ただ、テンプレート側で `ContextField` を受け取るために、こんな感じにラムダ式使っているのがちょっと気に入らなかったのでいじってみました。

```haskell
postTemplate = LucidTemplate $ \ask -> do
  StringField body <- lift $ ask "body"
  -- ...
```

Lucid は Monad Transformer としても使えるので、`LucidTemplate` の中身を [`HtmlT`](https://hackage.haskell.org/package/lucid-2.9.10/docs/Lucid-Base.html#t:HtmlT) と [`ReaderT`](https://hackage.haskell.org/package/transformers-0.5.5.0/docs/Control-Monad-Trans-Reader.html#t:ReaderT) を組み合わせたものにしてみます。

```haskell
type LucidTemplateMonad a r = HtmlT (ReaderT (Context a, Item a) Compiler) r

newtype LucidTemplate a = LucidTemplate
    { runLucidTemplate :: LucidTemplateMonad a () }
```

[`Context a`](https://hackage.haskell.org/package/hakyll-4.11.0.0/docs/Hakyll-Web-Template-Context.html#t:Context) と [`Item a`](https://hackage.haskell.org/package/hakyll-4.11.0.0/docs/Hakyll-Core-Item.html#t:Item) は、[`ContextField`](https://hackage.haskell.org/package/hakyll-4.11.0.0/docs/Hakyll-Web-Template-Context.html#t:ContextField) を取り出す `unContext` を呼び出すときに必要となるパラメータです。ちなみに、`unContext` はこのようになっていますが

> ```haskell
> unContext :: String -> [String] -> Item a -> Compiler ContextField
> ```

この1つ目の `String` が field のキーに、2つ目の `[String]` が [`functionField`](https://hackage.haskell.org/package/hakyll-4.11.0.0/docs/Hakyll-Web-Template-Context.html#v:functionField) などを呼び出すときの引数に相当するようです。

テンプレートを適用するための関数はこんな感じ。`renderTextT` の後に `runReaderT` で `ReaderT` もほどいてやります。

```haskell
applyLucidTemplate :: LucidTemplate a -> Context a -> Item a -> Compiler (Item String)
applyLucidTemplate tpl ctx item = do
  body <- TL.unpack <$> runReaderT (renderTextT (runLucidTemplate tpl)) (ctx', item)
  return $ itemSetBody body item
  where ctx' = ctx `mappend` missingField
```

そしてこんな関数を用意して

```haskell
lookupMeta :: String -> LucidTemplateMonad a ContextField
lookupMeta k = do
  (c, i) <- lift ask
  lift $ lift $ applyTemplateExpr c i (Ident (TemplateKey k))

-- https://hackage.haskell.org/package/hakyll-4.11.0.0/docs/src/Hakyll-Web-Template-Internal.html#applyTemplate%27
applyTemplateExpr :: Context a -> Item a -> TemplateExpr -> Compiler ContextField
applyTemplateExpr _ _ (StringLiteral s)         = return (StringField s)
applyTemplateExpr c i (Ident (TemplateKey k))   = unContext c k [] i
applyTemplateExpr c i (Call  (TemplateKey k) a) = do
  a' <- mapM (\e -> applyTemplateExpr c i e >>= getString e) a
  unContext c k a' i
  where getString _ (StringField s) = return s
        getString e (ListField _ _) =
          fail $ "expected StringField but got ListField for expr " ++ show e
```

テンプレート側ではこんな感じ書けるようにしてみました。

```haskell
postTemplate = LucidTemplate $ do
  StringField body <- lookupMeta "body"
  -- ...
```

また、記事リストなどを受け渡すときに使う `ListField (Context a) [Item a]` のためにこんな関数も用意し

```haskell
withContext :: Monad m => a' -> HtmlT (ReaderT a' m) r -> HtmlT (ReaderT a m) r
withContext c = HtmlT . withReaderT (const c) . runHtmlT
```

テンプレート側ではこんな感じで記事リストが書けるようにしてみました。

```haskell
listTemplate :: LucidTemplate a
listTemplate = LucidTemplate $
  ul_ $ do
    ListField ctx items <- lookupMeta "posts"
    forM_ (zip (repeat ctx) items) $ flip withContext $ do
      StringField title <- lookupMeta "title"
      li_ $ toHtml title
```

余談ですが、[`TemplateExpr`](https://hackage.haskell.org/package/hakyll-4.11.0.0/docs/Hakyll-Web-Template-Internal-Element.html#t:TemplateExpr) などの扱いを調べるために Hakyll のソースを眺めたときに「はぇーーーーっ」ってなりました。個人的にとても衝撃的で、言語処理系を書いてみたくなりました。コンパイラの講義を履修していたこともあってその方面のことにもちょっと興味あったので、いつかやってみたいなと。

### FontAwesome の SVG を記事生成時に埋め込みたい

フロントエンドライブラリは、素直に npm で管理することにしました。例えば [KaTeX](https://khan.github.io/KaTeX/) の css やフォントをコピーする rule はこんな感じでです。`"*.js"` をコピーしていないのは、今回も例によってビルド時にレンダリングしており、必要ないためです。

```haskell
match ("node_modules/katex/dist/**" .&&. complement "**.js") $ do
  route $ gsubRoute "node_modules/katex/dist/" (const "vendor/katex/")
  compile copyFileCompiler
```

こうやってパッケージマネージャが管理するディレクトリ内を参照するのがあまり気にらないのですが、そういうものなんですかね...


さて、[FontAwesome](https://fontawesome.com/) の話に戻ります。知らないうちにバージョン 5.x が出ていた FontAwesome は、従来の Web フォントを使ったもののほかに、SVG を利用できるようになっていました。けれども、[推奨された使い方](https://fontawesome.com/how-to-use/svg-with-js)は JavaScript により表示された時に置き換えるというもの。うーん、静的サイトジェネレータ大好きマンとしては納得できないですね。

幸いにも、[Server Side Rendering に関するドキュメント](https://fontawesome.com/how-to-use/server-side-rendering) がありましたので、この辺を参考にやってみましょう。

まず、表示に必要になる CSS です。どうやら `fontawesome.dom.css()` を呼び出せばいいようなので、こんな感じの JavaScript を用意して

```javascript
#!/usr/bin/env node

const fontawesome = require('@fortawesome/fontawesome');
const brands      = require('@fortawesome/fontawesome-free-brands').default;
const solid       = require('@fortawesome/fontawesome-free-solid').default;

fontawesome.library.add(brands);
fontawesome.library.add(solid);

console.log(fontawesome.dom.css());
```

Haskell 側でこんな感じの rule を書いて、その実行結果を出力してみました。

```haskell
create ["stylesheets/fontawesome.css"] $ do
  route   idRoute
  compile $ unsafeCompiler (readProcess "./fontawesome_css.js" [] [])
    >>= makeItem . compressCss
```

次はアイコンです。[ドキュメント](https://fontawesome.com/how-to-use/font-awesome-api#icon)によると、`fontawesome.icon({prefix: prefix, iconName: name}).abstract` でこんな感じの情報を取得できるようです。これ、このまま HTML の要素にできそうですね。

> ```javascript
> [
>   {
>     "tag": "svg",
>     "attributes": {
>       "data-prefix": "fa",
>       "data-icon": "user",
>       "class": "svg-inline--fa fa-user fa-w-16",
>       "role": "img",
>       "xmlns": "http://www.w3.org/2000/svg",
>       "viewBox": "0 0 512 512"
>     },
>     "children": [
>       {
>         "tag": "path",
>         "attributes": {
>           "fill": "currentColor",
>           "d": "M96…112z"
>         }
>       }
>     ]
>   }
> ]
> ```

ということで、まずは こんな感じの JavaScript で全アイコンの情報を JSON で出力します。

```javascript
#!/usr/bin/env node

const fontawesome = require('@fortawesome/fontawesome');
const brands      = require('@fortawesome/fontawesome-free-brands').default;
const solid       = require('@fortawesome/fontawesome-free-solid').default;

fontawesome.library.add(brands);
fontawesome.library.add(solid);

let o = {};
for (prefix in fontawesome.library.definitions) {
  o[prefix] = {};
  for (name in fontawesome.library.definitions[prefix]) {
    o[prefix][name] = fontawesome.icon({prefix: prefix, iconName: name}).abstract[0];
  }
}
console.log(JSON.stringify(o));
```

Haskell 側ではまず、JS 側で出力した JSON を読み込むためのデータ構造を作ってやります。[Aeson](https://hackage.haskell.org/package/aeson) 大好き。

```haskell
data Element = Element { tag        :: T.Text
                       , attributes :: [Attribute]
                       , children   :: [Element]
                       }
             deriving Show

instance FromJSON Element where
  parseJSON = withObject "Element" $ \o -> do
    tag        <- o .: "tag"
    attributes <- objectToAttributes <$> o .:? "attributes" .!= HM.empty
    children   <- o .:? "children" .!= []
    return Element {..}

    where objectToAttributes = map (uncurry makeAttribute) . HM.toList

-- FontAwesomeIcons [(prefix, [(name, icon-meta)])]
type FontAwesomeIcons = HM.HashMap T.Text (HM.HashMap T.Text Element)

parseFontAwesomeIcons :: String -> Maybe FontAwesomeIcons
parseFontAwesomeIcons = decode . BSL.pack
```

次に、`FontAwesomeIcons` と `prefix`、`name` を与えたら Lucid の `HtmlT` を返す関数を作ってやります。

```haskell
fontawesome :: Monad m => FontAwesomeIcons -> T.Text -> T.Text -> Maybe (HtmlT m ())
fontawesome db prefix name = toLucid <$> (HM.lookup prefix db >>= HM.lookup name)

toLucid :: Monad m => Element -> HtmlT m ()
toLucid = termWith <$> tag <*> attributes <*> children'
  where children' = mconcat . map toLucid . children
```

いい感じですね。

```haskell
λ> :m +System.Process 
λ> Just db <- parseFontAwesomeIcons <$> readProcess "fontawesome_list.js" [] []
λ> fontawesome db "fas" "plus"
Just <svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" data-prefix="fas" viewBox="0 0 448 512" role="img" class="svg-inline--fa fa-plus fa-w-14" data-icon="plus"><path d="M448 294.2v-76.4c0-13.3-10.7-24-24-24H286.2V56c0-13.3-10.7-24-24-24h-76.4c-13.3 0-24 10.7-24 24v137.8H24c-13.3 0-24 10.7-24 24v76.4c0 13.3 10.7 24 24 24h137.8V456c0 13.3 10.7 24 24 24h76.4c13.3 0 24-10.7 24-24V318.2H424c13.3 0 24-10.7 24-24z" fill="currentColor"></path></svg>
```

これをテンプレートから直接呼んでもいいのですが、[`Text.HTML.TagSoup.Tree`](https://hackage.haskell.org/package/tagsoup-0.14.6/docs/Text-HTML-TagSoup-Tree.html) でページの HTML をパースし、`"fas fa-plus"` のようなclass が設定された要素を置換するコードを書いてみました。雑な実装ですが、こんな感じ。

```haskell
renderFontAwesome :: FontAwesomeIcons -> Item String -> Compiler (Item String)
renderFontAwesome icons = return . fmap
    (TS.renderTreeOptions tagSoupOption . TS.transformTree renderFontAwesome' . TS.parseTree)
  where
    renderFontAwesome' tag@(TS.TagBranch "i" as []) =
      case toFontAwesome $ classes as of
           Just html -> TS.parseTree $ TL.unpack $ renderText html
           Nothing   -> [tag]
    renderFontAwesome' tag = [tag]

    toFontAwesome (prefix:('f':'a':'-':name):cs) =
      let prefix'  = T.pack prefix
          name'    = T.pack name
          classes' = T.pack $ " " ++ unwords cs
      in  fmap (`with` [class_ classes']) (fontawesome icons prefix' name')
    toFontAwesome _ = Nothing

    classes = words . fromMaybe "" . lookup "class"
```

あとは、rule をこんな感じに書けば置換してくれます。

```haskell
match "posts/*" $ do
  route $ setExtension "html"
  compile $ pandocCompiler
    >>= loadAndApplyTemplate "templates/post.html"    postCtx
    >>= loadAndApplyTemplate "templates/default.html" postCtx
    >>= renderFontAwesome icons
```

## おわり

Hakyll、自分の好きな言語で細かなところまでいじれて、とてもおもしろい静的サイトジェネレータだなという感じです。ただ、こだわり始めると止まらなくなってしまう...

この記事に載せた Haskell のコードは、ほぼ全て `import` など一部の記述を省略しているので、詳しいことが気になったら [Tosainu/blog](https://github.com/Tosainu/blog) を見てください。うーん、複数ファイルにまたがるコードを部分的に紹介していくのってどうするのがいいんだろう...

