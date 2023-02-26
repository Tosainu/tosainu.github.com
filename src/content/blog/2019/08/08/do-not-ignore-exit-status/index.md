---
title: Exit status は無視しないようにしよう
date: 2019-08-08 13:09:56+0900
tags:
  - Linux
---

**「手順に従ってコマンドを順番に実行したけどなんか動かなかった」**

\*nix 系のシステムを使った開発などで、何らかの目的を実現するために複数のシェルコマンドを実行する場面はよくあると思います。その操作が上手くいかなかったとき、こんな感じの質問をしてはいないでしょうか。また、このような場面で躓いているメンバーからこんな質問を受けたりすることはないでしょうか。

僕はこういった質問をたまに受けたりするのですが、これ、とても困るのです。まず実行したコマンドのうち何が失敗したのかの特定から始めることになるため、例えば互いの貴重な時間をそれなりに消費することになったりで双方にいいことがありません[^log]。

[^log]: せめて実行結果のログを送ってくれるだけでもいいのですが、それすらない場合が...

コマンドの出力をちゃんと読んでエラーを特定してから質問しろとは言いません[^2]。でもせめて、**Exit status** ってやつくらいは確認してください。**たった数桁の数字がゼロでないかを確認するだけ**です。これで、「xxx のコマンドの実行に失敗したんだけど...」と言えるようになりましょう。

[^2]: もちろんコマンドの出力はちゃんと把握できたほうがいいですし、特に重要なメッセージ (エラーとか警告とか) だけでも拾えてほしいですが...

<!--more-->

## Exit status って何？

Exit status (exit code や return status などとも呼ばれます) は、あるプロセス (≒ コマンド) が終了するときに、そのプロセスを起動した親のプロセスに返す 0 ~ 255 の値のことです。今回の話題であるシェル (Bash や Zsh など) での作業であれば、実行したコマンドがシェルに返す値のことを指します。

シェルで直前に実行したコマンドの Exit status は、シェル変数 `$?` を見ることで確認することができます。[`true(1)`](https://linux.die.net/man/1/true) と [`false(1)`](https://linux.die.net/man/1/false) の Exit status を確認してみるとこんな感じになると思います。

    $ true
    $ echo $?
    0

    $ fase
    $ echo $?
    1

この Exit status は何のための値なのかというと、プロセスの実行結果を簡潔に親プロセスに伝える役割があります。例えば [`ls(1)`](https://linux.die.net/man/1/ls) コマンドの `man` をみてみると、このコマンドの Exit status についてこのような説明がされています。

> ### Exit status:
> 0. if OK,
> 1. if minor problems (e.g., cannot access subdirectory),
> 2. if serious trouble (e.g., cannot access command-line argument).

で、ここで僕が伝えたいのは、実行したコマンドの Exit status がどういう意味を持っているか調べようということではありません。\*nix のシェルコマンドの大半は Exit status がゼロなら正常終了、それ以外の値は何かしらの問題が発生しているのだということです。つまり、**Exit status という数桁の数字がゼロでないかを確認するだけで、コマンドが出力したメッセージなどを読まなくとも正常終了したか判断できる**のです。



## プロンプトに Exit status を表示するようにしよう

でもいちいち `echo $?` とかするの面倒だし、`$?` はすぐ上書きされちゃって必要なときに参照できないし... となると思います。そこで今回紹介するのが**プロンプトに Exit status を表示**する方法です。プロンプトってのはコマンドを入力するとき右に表示されている `$` や `username@hostname` とかが表示されている部分のことです。

例えば僕のシェル[^dotfiles]では、直前に実行したコマンドの Exit status がゼロでなかったときに、赤の太字でその値を表示するようにしています。
![](shell.svg)

こんな感じにしておけば、直前のコマンドが失敗したかを次のコマンドを入力する前に気づけますし、仮に複数のコマンドをコピペ[^copy_paste]したときでも、どこで失敗したのかがひと目でわかるようになります。便利ですね。

[^copy_paste]: 複数コマンドを一度にコピペするのは安全でないのであまりおすすめはしませんね... 具体的な手法を書くのは最近不穏なのでやらないですが  
ちなみに僕はなにか説明するテキストを書くとき、コマンドの最初にわざと `$` 記号を付けるようにしているのですが、これは複数のコマンドのコピペをしにくくするというねらいがあったりもします

[^dotfiles]: 僕の Zsh の設定はここにあります <https://github.com/Tosainu/dotfiles/blob/master/.zshrc>

### Bash の場合

`echo $SHELL` という感じのコマンドを実行したときに `/bin/bash` などが表示されたら、その環境では Bash というシェルがデフォルトで使われるようになっています。

僕は普段 Bash を (カスタマイズして) 使わないのでいろいろ調べてみたところ、[`PROMPT_COMMAND`](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#index-PROMPT_005fCOMMAND) をいじるといろいろ高度なことができそうです。とはいえ、最小限の設定で済ませるのであれば、`~/.bashrc` にこんな感じの行を追記するだけでよさそうです。

```bash
PS1="\$(ret=\$?; if [[ \$ret != '0' ]]; then echo -n \"$(tput bold)$(tput setaf 1)\$ret$(tput sgr0) \"; fi)${PS1}"
```

[`PS1`](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#index-PS1)は、通常のプロンプトの文字列が設定されるシェル変数です。`./bashrc` に上記の行を追記することで、デフォルトで設定された `PS1` の先頭に Exit status 表示のための設定が入った文字列が再設定されます。追加している文字列は `\$(...)` という感じになっています。詳しい説明は省略しますが、こうすることでプロンプトが表示されるときにカッコ内のコマンドが評価され、そこで出力された文字列で `\$(...)` が置換されるようになります。

`\$(...)` 内のコマンドを展開するとだいたいこんな感じ[^escape]になります。まず直前のコマンドの Exit status `$?` を変数 `ret` に退避させ、その値がゼロでなかったら `echo(1)` で表示、という感じです。ちなみに `echo(1)` に `-n` オプションを付けると、末尾の改行が出力されなくなります。

```bash
ret=$?
if [[ $ret != '0' ]]; then
  echo -n "$ret "
fi
```

[^escape]: 上記例で実際に設定されている文字列は、[`tput(1)`](https://linux.die.net/man/1/tput) により出力した Exit status を赤太字で表示するためのエスケープシーケンスなどが含まれています

この設定をしてみた Bash (version 5.0.7) の例がこれです。いい感じですね。
![](bash.svg)

### Zsh の場合

`echo $SHELL` という感じのコマンドを実行したときに `/bin/zsh` などが表示されたら、その環境では Zsh というシェルがデフォルトで使われるようになっています[^zsh]。

[^zsh]: まぁ Zsh が設定されているなら、たぶんこんなこと書かなくてもわかる方が大半だとは思いますが

Zsh でも Bash で上げた例は有効です[^prompt_subst]。けれども Zsh は [zsh: 13 Prompt Expansion](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html) にあるように `%` で始まるエスケープシーケンスが豊富で、これを使ったほうがいい感じに書くことができます。

[^prompt_subst]: ただし、プロンプト文字列内の `$()` ([Command Substitution](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Command-Substitution) というらしい) を展開するため [`PROMPT_SUBST`](http://zsh.sourceforge.net/Doc/Release/Options.html#Prompting) オプションが有効にされている必要があります

[Shell state](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Shell-state) にあるように、Zsh のプロンプトでは `%?` が Exit status に展開されます。これに [Conditional Substrings in Prompts](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Conditional-Substrings-in-Prompts) で紹介されている `%(x.true-text.false-text)` と [Visual effects](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Visual-effects) の各種エスケープシーケンスを組み合わせ、こんな感じの記述を `~/.zshrc` に追記することで Exit status が非ゼロならプロンプトの先頭にその値を赤太字で表示が実現できます。

```zsh
# '%' で始まるエスケープシーケンスが展開されるようにする
# デフォルトで有効になっている？ので必要ないかも
setopt prompt_percent

PROMPT='%(?..%B%F{red}%?%f%b )${PROMPT}"
```

これを設定してみた Zsh (5.7.1) の例がこんな感じです。
![](zsh.svg)

## おわり

Exit status の重要さと、その値をプロンプトに表示することで、コマンド実行結果をひと目でわかるようにするテクニックを紹介をしました。これでシェル上での作業の問題を特定しやすくしたり、あいまいな質問に困る方が少しでも減ってくれるといいなと思います。

重要な値や文字列をプロンプトに表示したり、色を付けたりするのは Exit statusに限らず有効的だと思います。例えば Git などのバージョン管理システムの状態を表示するようにしたり、SSH などで複数のマシンをまたいだ作業をするならホスト名を目立つようにしておくと、コマンドを目的と違うホストで実行してしまう事故の抑制になったりするでしょう。この機会に、自分だけの最高のプロンプトを作ってみるのもいいのではないでしょうか。
