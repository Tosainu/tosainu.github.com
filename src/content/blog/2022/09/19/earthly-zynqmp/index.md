---
title: とにかく複雑な Zynq のソフトウェアを Earthly でビルドする
date: 2022-09-19 21:32:00+0900
tags:
  - FPGA
---

Zynq はソフトウェアだけにフォーカスしても構成するものが多く、動かすまでがとにかく大変です。Zynq UltraScale+ MPSoC をターゲットにして、APU で Linux を動かしつつ、RPU ではベアメタルアプリケーションを動かして相互に通信…とかやっていくのは実際気の遠くなる作業です。おまけに各種ツールが絶妙にアレなので、この規模にもなると edit-build-run のループを回すのに一苦労です。

Zynq に限らず、規模の大きくなったソフトウェアは edit-build-run あるいは build-test-release-deploy 一連のタスクが複雑になりがちです。複数のプログラミング言語やライブラリが絡むために異なるツールを呼び出さないといけなかったり、ビルドした個々のソフトウェアをパッケージするためにビルドツールを伴わないファイル操作などが絡んだり…。クリーンな状態から1度だけの実行を想定したものでよければ適当なスクリプトで解決するかもしれません。でも普段の開発での利用も想定すると、個々のビルドプロセスとその依存関係を適切に管理できたり、キャッシュなどを使って必要なところだけをいい感じにビルドし直してくれたりするもの、言葉にするなら *Build automation tool* がほしくなってきます。

なにかいいツールがないかなーと探し回り、あるときはいっそ自分で作ってやろうかと考えたこともありました。そんなときに見つけたのが [Earthly](https://earthly.dev/) です。これが自分が探していたものにかなり近く、Zynq ソフトウェアプロジェクトをはじめ様々な用途で使ってみていい感じだったので紹介しようとおもいます。

<!--more-->

## Earthly

[Earthly](https://earthly.dev/) はコンテナを活用した Build automation tool です。`Makefile` と `Dockerfile` を組み合わせたかのような `Earthfile` を見れば、これがどんなことをしてくれるものなのかすぐにイメージできるんじゃないかなと思います。実際、Earthly は buikdkit をバックエンドに使っていて、Docker の [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) にかなり近い動作をします。各ターゲットはそれぞれ独立したコンテナ環境で実行されるので、ちゃんと設定さえすればどの実行環境でもほぼ同じビルドが再現できますし、ある別のターゲットで作られたものやリポジトリ管理外のファイルを暗黙的に参照してしまうこともありません。また、ターゲット間の依存関係に問題なければ可能な限り並列で実行してくれたり、一度実行したターゲットは自身が依存するファイルや別のターゲットに変更がない限りキャッシュが効いてくれるのもポイントです。これだけの利点がありながら、Earthly の導入作業は基本的には普段の dockerize と同じ感覚なので、個々のビルド方法自体は大きく変えなくてよく、比較的敷居が低いのも強みです。

```Earthfile
hoge:
    FROM alpine
    RUN echo "Hoge!" > awesome.txt
    SAVE ARTIFACT awesome.txt

fuga:
    FROM alpine
    RUN echo "Fuga!" > awesome.txt
    SAVE ARTIFACT awesome.txt

myon:
    FROM alpine
    COPY +hoge/awesome.txt a.txt
    COPY +fuga/awesome.txt b.txt
    RUN cat a.txt b.txt > awesome.txt
    SAVE ARTIFACT awesome.txt
```

Earthly のインストールは、[公式の手順](https://earthly.dev/get-earthly)の通りビルド済みのバイナリを使うのが簡単です。ただ自分なら不必要に root で作業したくないので、例えばインストール先は `~/.local/bin` にして、また `/usr` 下に書き込もうとしてくる `earthly bootstrap --with-autocomplete` は実行しないと思います[^earthly-selfbuilt]。

    $ curl -L https://github.com/earthly/earthly/releases/latest/download/earthly-linux-amd64 \
        -o ~/.local/bin/earthly
    $ chmod +x $_

[^earthly-selfbuilt]: もっと言えば、インターネットから拾ってきた実行ファイルをむやみに実行したくないのでソースコードからビルドしています。Earthly の最新機能を追うきっかけにもなりますしね。

インストールが済んだら早速 Earthly を動かしてみます。適当な場所に空のディレクトリを作り、そこに先ほどあげた `Earthfile` の例を保存してください。`Earthfile` に定義されたあるターゲットを実行するには `earthly +<ターゲット名>` を実行します。例えば `hoge` と `fuga` を実行するならそれぞれこうなります。

    $ earthly +hoge
    $ earthly +fuga

ターゲット `myon` は `hoge` と `fuga` で作ったファイルに依存しています。あるターゲットで作ったものを後段のタスクや Earthly 実行ホストに渡すには、そのファイルを [`SAVE ARTIFACT`](https://docs.earthly.dev/docs/earthfile#save-artifact) コマンドで指定します。そして、別のターゲットからそれを参照するには [`COPY`](https://docs.earthly.dev/docs/earthfile#copy) コマンドを使います。

実際に `myon` を動かしてみると、`myon` が依存するターゲットである `hoge` と `fuga` が実行されようとしたこと、またそれらターゲットは先程ビルドしたばかりなのでキャッシュが参照されたことがわかります。

```
 2. Build 🔧
————————————————————————————————————————————————————————————————————————————————

      alpine | --> Load metadata linux/amd64
       +fuga | --> FROM alpine
       +fuga | [██████████] 100% resolve docker.io/library/alpine@sha256:bc41182d7ef5ffc53a40b044e725193bc10142a1243f395ee852a8d9730fc2ad
       +fuga | *cached* --> RUN echo "Fuga!" > awesome.txt
       +hoge | *cached* --> RUN echo "Hoge!" > awesome.txt
       +hoge | --> SAVE ARTIFACT awesome.txt +hoge/awesome.txt
       +fuga | --> SAVE ARTIFACT awesome.txt +fuga/awesome.txt
       +myon | --> COPY +hoge/awesome.txt a.txt
       +myon | --> COPY +fuga/awesome.txt b.txt
       +myon | --> RUN cat a.txt b.txt > awesome.txt
      output | --> exporting outputs
```

Earthly で作られたものを実行ホスト側に持ってくるには `earthly --artifact` コマンドを使います。`myon` で作ったファイル `awesome.txt` をカレントディレクトリ直下の `build/` にコピーするならこうなります。コピー先として渡すパスは末尾を必ず `/` にします。また先程カレントディレクトリと書きましたが、Earthly は相対パス受け取ったとき、それが `Earthfile` のあるディレクトリを基準としたものと解釈するのにも注意です。ターゲットからコピーするファイルの指定には `*` が使えます。たぶん Go 製アプリにありがちな [`filepath.Match`](https://pkg.go.dev/path/filepath#Match) を使うやつです。シェルの設定次第では `*` を glob として展開しちゃう場合があるのでエスケープしておくと安心です。

    $ earthly --artifact +myon/awesome.txt ./build/

    $ earthly --artifact +myon/\* ./build/

Earthly の主要操作はだいたいこんな感じです。基本的には `Dockerfile` と同じなので、Docker を使ったことさえあればあまり難しいことはないと思います。

## 実際に Zynq をターゲットにした何かを作ってみる

### L チカ…？

それでは本題、Earthly をどうやって Zynq UltraScale+ のソフトウェアプロジェクトに適用したかです。この紹介にあたって、こんなものを作ってみました。

<video controls loop>
    <source src="./led.mp4" type="video/mp4">
</video>

一言でいえば、特に理由もなく面倒なことをしている L チカの亜種です。RPU で動く LED 制御のベアメタルアプリケーションと APU 上の Ubuntu で動くアプリケーションが IPI (Inter-Processor Interrupt) を飛ばし合います。APU から RPU への IPI で LED 点滅開始、その後 APU が RPU から飛んでくる IPI に応答し続けないと LED は消えてしまうというものです。題材を複雑にしすぎても準備が大変なだけだし、かといって簡単にしすぎてもおもしろくないし…と悩んだ末のものになります。ソースコードはすべて GitHub リポジトリ [Tosainu/earthly-zynqmp-example](https://github.com/Tosainu/earthly-zynqmp-example) にあり、この記事は [`322ce449`](https://github.com/Tosainu/earthly-zynqmp-example/tree/322ce449da698ac1db1641cf12240bbfaa36d6eb) をベースに書いています。

ちなみに、FPGA としての機能をほぼ使っていないのでブロックデザインは実質 PS だけです。Ultra96 ちゃん、XCZU3EG-1SBVA484E ちゃんごめんね…

### コンテナ内に必要なツールをそろえる

最初に書く `Earthfile` のターゲットが、ビルドなど全体のタスク実行に必要なツール類をインストールしてベースイメージのように使うものです。ほかのターゲットから `FROM +prep` みたいにして使います。

必要になるのは RPU と APU で動かすアプリケーションをビルドするクロスコンパイラ、ディスクイメージ作成のためにファイルシステムやパーティションテーブル操作系のツール、そして `.xsa` から BSP や FSBL, PMUFW などを生成するための Xilinx のツール類です。クロスコンパイラの大半と Xilinx のツール類は、PetaLinux Tools などで使われているらしい [xsct-trim](https://github.com/Xilinx/meta-xilinx-tools/blob/e2ff6325931b008565f558cb35ac38dfb01116c9/classes/xsct-tarball.bbclass#L7) から拝借しました。xsct-trim には AArch64 Linux 向けクロスコンパイラは入っていないので、かわりに Ubuntu の `crossbuild-essential-arm64` パッケージを使うことにしました。

```Earthfile
prep:
    FROM ubuntu:jammy@sha256:20fa2d7bb4de7723f542be5923b06c4d704370f0390e4ae9e1c833c8785644c1
    RUN \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            autoconf automake bc bison build-essential ca-certificates cmake cpio \
            crossbuild-essential-arm64 curl dbus-x11 dosfstools e2fsprogs fdisk flex gzip \
            kmod libncurses-dev libssl-dev libtinfo5 libtool-bin locales rsync xz-utils zstd && \
        rm -rf /var/lib/apt/lists/* && \
        sed -i 's/^#\s*\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
        dpkg-reconfigure --frontend noninteractive locales
    ARG XSCT_URL=https://petalinux.xilinx.com/sswreleases/rel-v2022/xsct-trim/xsct-2022-1.tar.xz
    ARG XSCT_SHA256SUM=e343a8b386398e292f636f314a057076e551a8173723b8ea0bc1bbd879c05259
    RUN --mount=type=tmpfs,target=/tmp \
        curl --no-progress-meter -L "${XSCT_URL}" -o /tmp/xsct.tar.xz && \
        echo "${XSCT_SHA256SUM} /tmp/xsct.tar.xz" | sha256sum -c - && \
        mkdir -p /opt/xsct && \
        tar xf /tmp/xsct.tar.xz -C /opt/xsct --strip-components=2
    ENV PATH="/opt/xsct/bin:/opt/xsct/gnu/aarch64/lin/aarch64-none/bin:/opt/xsct/gnu/armr5/lin/gcc-arm-none-eabi/bin:/opt/xsct/gnu/microblaze/lin/bin:${PATH}"
    WORKDIR /build

```

今回は `Earthfile` の中にこうしたターゲットを書いていますが、よりビルドの再現性を重視したいのであれば別のアプローチを取るべきです。`apt-get` などのコマンドは、パッケージの更新などのために実行するタイミングで結果が大きく変わりうるためです。対策の一例としては、この部分だけ独立したコンテナイメージ化し、レジストリで管理するなどがあると思います。

### xsct-trim で FSBL, PMUFW, BSP, Devicetree を出力させる

次は FSBL、PMUFW、RPU ベアメタルアプリケーションの BSP、そして Devicetree のテンプレートなど、Vitis でいう platform に相当するものたちを xsct-trim に入っている [XSCT](https://docs.xilinx.com/r/en-US/ug1400-vitis-embedded/XSCT-Commands) に出力させます。

いつもの XSCT コマンドを並べた TCL スクリプトを作っておきます。コマンドラインから `.xsa` ファイルのパスを受け取ったり、`Earthfile` 側から `.bit` ファイルを常に同じファイル名で扱えるように symlink を張るようにもしておきます。

```tcl
set xsa_file [lindex $argv 0]

hsi open_hw_design $xsa_file

set bit_file [lindex [hsi get_hw_files -filter {TYPE==bit}] 0]
file link -symbolic system.bit $bit_file

hsi set_repo_path embeddedsw

hsi create_sw_design fsbl -proc psu_cortexa53_0 -os standalone
hsi set_property CONFIG.stdin  psu_uart_1 [hsi get_os]
hsi set_property CONFIG.stdout psu_uart_1 [hsi get_os]
hsi add_library xilffs
hsi add_library xilpm
hsi add_library xilsecure
hsi generate_app -app zynqmp_fsbl -dir fsbl
hsi close_sw_design [hsi current_sw_design]

hsi create_sw_design pmufw -proc psu_pmu_0 -os standalone
hsi set_property CONFIG.stdin  psu_uart_1 [hsi get_os]
hsi set_property CONFIG.stdout psu_uart_1 [hsi get_os]
hsi add_library xilfpga
hsi add_library xilsecure
hsi add_library xilskey
hsi generate_app -app zynqmp_pmufw -dir pmufw
hsi close_sw_design [hsi current_sw_design]

hsi create_sw_design bsp_psu_cortexr5_0 -proc psu_cortexr5_0 -os standalone
hsi set_property CONFIG.stdin  psu_uart_1 [hsi get_os]
hsi set_property CONFIG.stdout psu_uart_1 [hsi get_os]
# hsi add_library xilffs
# hsi add_library xilfpga
# hsi add_library xilmailbox
# hsi add_library xilpm
# hsi add_library xilsecure
# hsi add_library xilskey
hsi generate_bsp -dir bsp_psu_cortexr5_0
hsi close_sw_design [hsi current_sw_design]

hsi set_repo_path device-tree-xlnx

hsi create_sw_design device-tree -proc psu_cortexa53_0 -os device_tree
hsi set_property CONFIG.console_device psu_uart_1 [hsi get_os]
hsi generate_target -dir device-tree
```

あとはこれを `xsct` に実行させれば OK です。ビルド時に可変なパラメータを宣言する [`ARG`](https://docs.earthly.dev/docs/earthfile#arg) で `.xsa` ファイルへのパスを渡せるようにしておきます。生成したファイルは全部 `SAVE ARTIFACT` して別のターゲットから取り出せるようにしておきます。FSBL, PMUFW, BSP のビルドはそれぞれ独立したターゲットにして、ターゲット単位のビルド並列化が効くようにします[^xlnx-makefile]。

```Earthfile
generate-src:
    ARG --required XSA_FILE

    FROM +xsct
    COPY generate.tcl .
    COPY $XSA_FILE system.xsa
    RUN USER="$(id -u -n)" xsct -sdx -nodisp generate.tcl system.xsa
    SAVE ARTIFACT bsp_psu_cortexr5_0
    SAVE ARTIFACT device-tree
    SAVE ARTIFACT fsbl
    SAVE ARTIFACT pmufw
    SAVE ARTIFACT system.bit

fsbl.elf:
    FROM +prep
    COPY +generate-src/fsbl .
    RUN make
    SAVE ARTIFACT executable.elf /fsbl.elf

pmufw.elf:
    FROM +prep
    COPY +generate-src/pmufw .
    RUN make CFLAGS="-DENABLE_MOD_ULTRA96 -DULTRA96_VERSION=2 -DPMU_MIO_INPUT_PIN_VAL=1 -DBOARD_SHUTDOWN_PIN_VAL=1 -DBOARD_SHUTDOWN_PIN_STATE_VAL=1"
    SAVE ARTIFACT executable.elf /pmufw.elf

bsp-r5-0:
    FROM +prep
    COPY +generate-src/bsp_psu_cortexr5_0 .
    RUN make
    SAVE ARTIFACT psu_cortexr5_0/include /include
    SAVE ARTIFACT psu_cortexr5_0/lib/*a /lib/
```

[^xlnx-makefile]: BSP とかの `Makefile` を見ると `-j10` がハードコーディングされていたり、一方でどう見てもターゲットの依存関係や並列ビルドであやしくなりそうな箇所がありますよね…。Earthly が持つ、ある条件での処理をコンテナ内で1度だけ実行するという特徴は、こういったヤツらのトラブルを避けるのにも有効です。

### RPU と APU のアプリケーション

RPU アプリケーションは、素直に Vitis を使ってテンプレートプロジェクトを作りました。xsct-trim と [Xilinx/embeddedsw](https://github.com/Xilinx/embeddedsw) の組み合わせでは standalone のテンプレートが出てこなかったためです。でもアプリケーションのビルドは Vitis ではなく自分たちでやりたいので、[`lscript.ld`](https://github.com/Tosainu/earthly-zynqmp-example/blob/27538797d4663eb2637bf9e8570dc23e7465f126/apps/r5_0/lscript.ld) など必要なものだけを持ってくるのと、コンパイラに渡しているオプションの確認が済んだら Vitis の出番は終了です。

コードは CMake でビルドできるようにしました。[`FindLibXil.cmake`](https://github.com/Tosainu/earthly-zynqmp-example/blob/27538797d4663eb2637bf9e8570dc23e7465f126/apps/r5_0/cmake/Modules/FindLibXil.cmake) を書いたので、`libxil.a` などを `find_package()` で探せるようになっています。BSP をビルドしたターゲット `bsp-r5-0` からライブラリとヘッダファイルをコピーしてきて、それを `FindLibXil.cmake` が探せるように `-DLibXil_ROOT=` でパスを渡します。またクロスコンパイラを使ってビルドするために、CMake に toolchain file を渡して指示します。CMake は `-S`, `-B`, `-DLibXil_ROOT` などがカレントディレクトリからの相対パスを受け付けてくれるのに対して、`--toolchain` は絶対パス、またはビルドディレクトリ・ソースディレクトリからの相対パスを要求してくるのに注意です。

```Earthfile
app-r5-0:
    FROM +prep
    COPY +bsp-r5-0/ libxil
    COPY apps/r5_0 src
    COPY apps/toolchain/armr5-none-eabi.cmake .
    RUN cmake \
        --toolchain $PWD/armr5-none-eabi.cmake \
        -S src \
        -B build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=install \
        -DLibXil_ROOT=libxil
    RUN cmake --build build -- install
    SAVE ARTIFACT install/* /
```

APU のアプリケーションも C++ で書いて CMake でビルドします。RPU と違って標準ライブラリと Linux の機能しか使わないので、クロスコンパイルのために toolchain file を渡す以外は特別な設定もなくいつもどおりです。

```Earthfile
app-a53:
    FROM +prep
    COPY apps/a53 src
    COPY apps/toolchain/aarch64-linux-gnu.cmake .
    RUN cmake \
        --toolchain $PWD/aarch64-linux-gnu.cmake \
        -S src \
        -B build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=install/usr
    RUN cmake --build build -- install
    SAVE ARTIFACT install/* /
```

### Linux カーネルの .deb パッケージ

組み込みで Linux を使うなら、やっぱりカーネルのコンフィグはプロジェクト単位で細かく設定したいです。ということでカーネルも一緒にビルドします。今回作る Linux 環境は Ubuntu なので、`make bindeb-pkg` で `.deb` パッケージを作ることにしました。

カーネルのコンフィグファイルは実行環境に依存しない `defconfig` 形式を使うのが望ましいのですが、手抜きをして `menuconfig` で作ったものをそのままリポジトリに入れています。`SAVE ARTIFACT` するのは作った `.deb` パッケージと、あとで `.dts` をコンパイルするときに使うヘッダファイルです。

```Earthfile
linux:
    FROM +prep
    RUN --mount=type=tmpfs,target=/tmp \
        curl --no-progress-meter -L https://github.com/Xilinx/linux-xlnx/archive/75872fda9ad270b611ee6ae2433492da1e22b688.tar.gz -o /tmp/archive.tar.gz && \
        echo '75e40c693484710cd7fc5cd972adb272414d196121c66a6ee2ca6ef762cb60c9  /tmp/archive.tar.gz' | sha256sum -c && \
        tar xf /tmp/archive.tar.gz --strip-components=1
    COPY linux/.config .
    ARG nproc=$(nproc)
    RUN CROSS_COMPILE=aarch64-linux-gnu- make -j$nproc ARCH=arm64 bindeb-pkg
    SAVE ARTIFACT include/dt-bindings /include/dt-bindings
    SAVE ARTIFACT /*.deb
```

### Ubuntu の rootfs

今回のアプリケーションを動かす環境として、Ubuntu は完全にオーバーキルです。それどころかブート時間やデータ量などの面でマイナスです。それでも Ubuntu にしたのは、構築後もその上で変更を加えられて、デスクトップ用途でも使ったことがあるだろう環境が動いてほしいという風潮を感じたためです。Linux From Scratch 的なことをしはじめると `crossbuild-essential-arm64` と少し相性が悪くなってくるのと、単純に説明が面倒になるからというのもあります。

Ubuntu 環境の構築には `mmdebstrap` を使ってみました。よく知られた `debootstrap` と比較して、処理時間が早いことや、より小さな環境を作りやすかったりするのがウリだそうです。

```Earthfile
rootfs-base.tar:
    FROM --platform=linux/arm64 ubuntu:jammy@sha256:1bc0bc3815bdcfafefa6b3ef1d8fd159564693d0f8fbb37b8151074651a11ffb
    RUN apt-get update && \
        apt-get install -y --no-install-recommends mmdebstrap && \
        rm -rf /var/lib/apt/lists/*
    COPY +linux/*.deb kernels/
    RUN mmdebstrap \
        --verbose \
        --components='main restricted universe multiverse' \
        --variant='minbase' \
        --include='apt dbus e2fsprogs init iproute2 iputils-ping kmod libstdc++6 parted sudo systemd-timesyncd udev' \
        --customize-hook='cp -r kernels "$1/" && chroot "$1" sh -c "dpkg -i /kernels/*.deb" && rm -rf "$1/kernels"' \
        --customize-hook='sed -i "s/^#\s*\(%sudo\)/\1/" "$1/etc/sudoers"' \
        --customize-hook='chroot "$1" adduser --disabled-password user' \
        --customize-hook='chroot "$1" adduser user sudo' \
        --customize-hook='echo "user:user" | chroot "$1" chpasswd' \
        --customize-hook='chroot "$1" passwd --expire user' \
        --customize-hook='chroot "$1" passwd --lock root' \
        --dpkgopt='path-exclude=/usr/share/man/*' \
        --dpkgopt='path-include=/usr/share/man/man[1-9]/*' \
        --dpkgopt='path-exclude=/usr/share/locale/*' \
        --dpkgopt='path-include=/usr/share/locale/locale.alias' \
        --dpkgopt='path-exclude=/usr/share/doc/*' \
        --dpkgopt='path-include=/usr/share/doc/*/copyright' \
        jammy rootfs-base.tar http://ports.ubuntu.com/ubuntu-ports
    # Use .tar format since SAVE ARTIFACT and COPY drop permissions for some reason even specifying with the --keep-own option...
    SAVE ARTIFACT rootfs-base.tar
```

これまでのターゲットと違い、`FROM` には `--platform=linux/arm64` を渡して 64 bit ARM の Ubuntu が設定されています。Earthly にビルドさせる前に qemu-user-static と binfnt_misc を設定しておきましょう。`mmdebstrap` にこれを勝手にやってくれる機能もあるようですが、Earthly の起動するコンテナ内でやってもらおうとするとたぶん `--privileged` が必要なので使っていません。`mmdebstrap` 出力形式はディレクトリではなく `.tar` にしています。`SAVE ARTIFACT` や `COPY` にディレクトリを渡したとき、`-–keep-own` を渡したとしてもファイルのオーナーが root に変わってしまう現象があったためです。ちなみに無圧縮な `.tar` なのは時間短縮のためです。このターゲット内での処理は QEMU を介して動いてしまうのを忘れてはいけません[^qemu-xz]。

[^qemu-xz]: 何も意識せずに `tar.xz` を指定して、やけに時間かかるなーってなる出来事がありました…

`mmdebstrap` は、`--customize-hook=` などのコマンドラインオプションで構築中の環境に対して任意のコマンドを実行できます。しかし、このターゲット内でのカスタマイズは最低限のもの、具体的には `chroot` を介さないと難しいものだけにとどめています。これは、なにか変更をしようとしたときに毎回 `mmdebstrap` が走ってしまうのを防ぐためです。いくら `mmdebstrap` が速さをアピールしているといえ、ファイル追加といった簡単なタスクに対しても毎回 `mmdebstrap` が走ってしまうのはかなり不便なので。

作った Ubuntu の `.tar` にファイルの追加をしているのがこのターゲットです。追加するのは APU のアプリケーションやその他設定ファイル類です。ファイルを追加するだけなら `tar` を展開しなくてもできます。

```Earthfile
rootfs.tar:
    FROM +prep
    COPY +rootfs-base.tar/rootfs-base.tar rootfs.tar
    COPY linux/rootfs rootfs
    COPY +app-a53/ rootfs
    RUN tar --append -f rootfs.tar --xattrs --xattrs-include='*' -C rootfs .
    SAVE ARTIFACT rootfs.tar
```

### U-Boot

U-Boot のビルドは、`ARCH` に渡す値が `aarch64` に変わるくらいで Linux とほぼ同じです。ビルドで一緒に作られるツール `dtc` と `mkimage` がこの後の作業で必要なので、これらも忘れず `SAVE ARTIFACT` しておきます。

```Earthfile
u-boot:
    FROM +prep
    RUN --mount=type=tmpfs,target=/tmp \
        curl --no-progress-meter -L https://github.com/Xilinx/u-boot-xlnx/archive/refs/tags/xilinx-v2022.1.tar.gz -o /tmp/archive.tar.gz && \
        echo 'a02adc8d80f736050772367ea6f868214faaf47b6b3539781d6972dab26b227c  /tmp/archive.tar.gz' | sha256sum -c && \
        tar xf /tmp/archive.tar.gz --strip-components=1
    ARG nproc=$(nproc)
    COPY u-boot.config .config
    RUN CROSS_COMPILE=aarch64-linux-gnu- ARCH=aarch64 \
        make -j$nproc u-boot.elf
    SAVE ARTIFACT u-boot.elf
    SAVE ARTIFACT scripts/dtc/dtc /dtc
    SAVE ARTIFACT tools/mkimage /mkimage
```

Linux と同様に、コンフィグはこちらも `menuconfig` で作ったものをそのまま入れています。ちなみにこのコンフィグは `xilinx_zynqmp_virt_defconfig` をベースに使わない機能を削り、U-Boot 自身が使う Devicetree Blob をどうロードするかを変更したものです。Devicetree は FSBL にロードさせたいので `CONFIG_OF_BOARD` に変更しています。

```
Device Tree Control  --->
    Provider of DTB for DT control (Provided by the board (e.g a previous loader) at runtime)  --->
        (X) Provided by the board (e.g a previous loader) at runtime
```

### Trusted Firmware-A (TF-A)

以前は arm-trusted-firmware やそれを略して ATF と呼ばれていたやつです。これもいつもどおりの方法でビルドします。`ZYNQMP_CONSOLE=cadence1` をつけるとメッセージ出力先が UART1 になってくれます。

```Earthfile
tf-a:
    FROM +prep
    RUN --mount=type=tmpfs,target=/tmp \
        curl --no-progress-meter -L https://github.com/Xilinx/arm-trusted-firmware/archive/refs/tags/xilinx-v2022.1.tar.gz -o /tmp/archive.tar.gz && \
        echo 'e7d6a4f30d35b19ec54d27e126e7edc2c6a9ad6d53940c6b04aa1b782c55284e  /tmp/archive.tar.gz' | sha256sum -c && \
        tar xf /tmp/archive.tar.gz --strip-components=1
    ARG nproc=$(nproc)
    RUN CROSS_COMPILE=aarch64-linux-gnu- ARCH=aarch64 \
        make -j$nproc PLAT=zynqmp RESET_TO_BL31=1 ZYNQMP_CONSOLE=cadence1
    SAVE ARTIFACT build/zynqmp/release/bl31/bl31.elf /
```

### Devicetree Blob

XSCT で生成した `.dts` に必要なものを追記して、それを U-Boot と Linux の両方にロードさせることにします。`gcc` はプリプロセッサを処理するために呼んでいます。渡しているオプションは [Linux カーネルにならった](https://github.com/Xilinx/linux-xlnx/blob/75872fda9ad270b611ee6ae2433492da1e22b688/scripts/Makefile.lib#L351-L355)ものです。

```Earthfile
system.dtb:
    FROM +prep
    COPY +generate-src/device-tree .
    COPY +linux/include include
    COPY +u-boot/dtc .
    COPY system-top-append.dts .
    RUN cat system-top-append.dts >> system-top.dts && \
        gcc -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp -Iinclude -o - system-top.dts | ./dtc -@ -p 0x1000 -I dts -O dtb -o system.dtb
    SAVE ARTIFACT system.dtb
```

### Bootgen と boot.bin

`boot.bin` の生成に使う `bootgen` は [GitHub にソースコードがあります](https://github.com/Xilinx/bootgen)。まずこれをビルドします。ソースコードを持ってきて `make` すれば、同じディレクトリ内に実行ファイル `bootgen` が出来上がります。

```Earthfile
bootgen:
    FROM +prep
    RUN --mount=type=tmpfs,target=/tmp \
        curl --no-progress-meter -L https://github.com/Xilinx/bootgen/archive/refs/tags/xilinx_v2022.1.tar.gz -o /tmp/archive.tar.gz && \
        echo 'a7db095abda9820babbd0406e7036d663e89e8c7c27696bf4227d8a2a4276d13  /tmp/archive.tar.gz' | sha256sum -c && \
        tar xf /tmp/archive.tar.gz --strip-components=1
    RUN make
    SAVE ARTIFACT bootgen
```

次に `boot.bin` に含めるファイルとその構成を指示する `.bif` ファイルを作ります。ここに書いた `system.dtb` は U-Boot が使うものです。ロード先のアドレス `0x100000` は U-Boot の `CONFIG_XILINX_OF_BOARD_DTB_ADDR=0x100000` に対応しています。[UG1283](https://docs.xilinx.com/r/en-US/ug1283-bootgen-user-guide/destination_cpu) にある通り、PMUFW のロードのさせ方には `[pmufw_image]` と `[destination_cpu=pmu]` の2通りあり、その違いは BootROM にロードさせるか FSBL にロードさせるかです。BootROM にロードさせると PMUFW 実行直後のバージョンなどの方法が出てこない気がする[^csu]ので FSBL にロードさせています。

```
all:
{
  [destination_cpu=a53-0, bootloader]                       fsbl.elf
  [destination_cpu=pmu]                                     pmufw.elf
  [destination_device=pl]                                   system.bit
  [destination_cpu=a53-0, exception_level=el-3, trustzone]  bl31.elf
  [destination_cpu=a53-0, exception_level=el-2]             u-boot.elf
  [destination_cpu=a53-0, load=0x100000]                    system.dtb
  [destination_cpu=r5-lockstep]                             ipi-led.elf
}
```

[^csu]: FSBL の `psu_init()` 前に実行されてしまうから…？

あとはこれまでのターゲットでビルドしてきた必要なファイルと `.bif` ファイルを持ってきて、`bootgen` コマンドを実行すれば OK です。

```Earthfile
boot.bin:
    FROM +prep
    COPY +app-r5-0/bin/ipi-led.elf .
    COPY +bootgen/bootgen .
    COPY +fsbl.elf/ .
    COPY +generate-src/system.bit .
    COPY +pmufw.elf/ .
    COPY +system.dtb/ .
    COPY +tf-a/bl31.elf .
    COPY +u-boot/u-boot.elf .
    COPY boot.bif .
    RUN ./bootgen -arch zynqmp -image boot.bif -o boot.bin
    SAVE ARTIFACT boot.bin
```

### boot.scr

U-Boot には、ブートデバイスのファイルシステム直下にあるスクリプト `boot.scr` を実行してくれる機能があります。これを使ってカーネルがある場所を指示したり、ロードしたカーネルでブートさせたりします。`boot.scr` は、U-Boot のコマンドをテキストファイルに書き、`mkimage` に渡して作ります。

```Earthfile
boot.scr:
    FROM +prep
    COPY +u-boot/mkimage .
    COPY boot.cmd .
    RUN ./mkimage -c none -A arm64 -T script -d boot.cmd boot.scr
    SAVE ARTIFACT boot.scr
```

ブートデバイスとして使う SD カードには2つのパーティションを作り、1つ目のパーティションに `boot.bin`, `boot.scr`, `system.dtb`  を、2つ目のパーティションに Ubuntu ということにします。開発時の書き換えやすさを優先して、`system.dtb` も1つ目のパーティションに置いています。ということで `boot.cmd` はこんな感じです。カーネルは2つ目のパーティションの `/boot` にあるので `mmc 0:2 ...`, `system.dtb` は1つ目のパーティション直下にあるので `mmc 0:1 ...` になります。あとはファイルをロードしたアドレスを `booti` コマンドに渡してブートさせます。initramfs を使わないので、`booti` の第2引数は `-` にします。

```sh
load mmc 0:2 ${kernel_addr_r} /boot/vmlinuz-5.15.19
load mmc 0:1 ${fdt_addr_r} /system.dtb
booti ${kernel_addr_r} - ${fdt_addr_r}
```

ちなみに、`bindeb-pkg` で作ったカーネルの `.deb` パッケージは、Linux カーネルに含まれる `.dts` から作った `.dtb` を `/usr/lib/linux-image-*` にインストールするようです。カーネルにあるもので十分なケースではこちらのパスを設定すればよいです。

### SD カードのディスクイメージも作っちゃう

ここまでで必要なファイルが全て揃いました。でも、これですぐ Ultra96 で動かせるかといえば ✗ です。SD カードにパーティションを切って、それぞれフォーマットして、ファイルをコピーして…と、地味に面倒な作業が残っています。少しでも作業を減らすために、`Earthfile` の中で SD カードのディスクイメージまで作ってしまいます。

最初にパーティション毎にイメージを作ってフォーマット & データのコピー、最後にそれらを結合して `sfdisk` でパーティションテーブルの書き込み、という感じのことをやっています。`loop` デバイスの作成や `mount` などを実行しているため、ここだけは仕方なく `--privileged` をつけています。いきなりディスクイメージを作らずパーティション毎にファイルを分けて構築しているのは、コンテナ内で `mount` は動くけど `losetup` はうまく動いてくれない場合があったことと、そもそもカーネルモジュール `loop` のパラメータ `max_part` が指定しなければ大抵0なため、パーティションを持つ `loop` デバイスの作成がコンテナ内だけの処理で完結しにくいためです。

```Earthfile
disk.img.zst:
    FROM +prep
    COPY +boot.tar/ .
    COPY +rootfs.tar/ .
    ARG DISK_IMG_PART1_SIZE=16M
    ARG DISK_IMG_PART2_SIZE=256M
    RUN --mount=type=tmpfs,target=/tmp --privileged \
        truncate -s "$DISK_IMG_PART1_SIZE" /tmp/boot.img && \
        mkfs.vfat -F 16 /tmp/boot.img && \
        mount /tmp/boot.img /mnt && \
        tar xf boot.tar -C /mnt && \
        umount /mnt && \
        truncate -s "$DISK_IMG_PART2_SIZE" /tmp/root.img && \
        mkfs.ext4 /tmp/root.img && \
        mount /tmp/root.img /mnt && \
        tar xf rootfs.tar --xattrs --xattrs-include='*' -C /mnt && \
        umount /mnt && \
        truncate -s 1M /tmp/header.img && \
        cat /tmp/header.img /tmp/boot.img /tmp/root.img > /tmp/disk.img && \
        echo "label: dos\n1M,${DISK_IMG_PART1_SIZE},e\n,${DISK_IMG_PART2_SIZE},L\n" | sfdisk /tmp/disk.img && \
        zstd --no-progress -9 /tmp/disk.img -o disk.img.zst
    SAVE ARTIFACT disk.img.zst

boot.tar:
    FROM +prep
    COPY +boot.scr/boot.scr boot/
    COPY +boot.bin/ boot/
    COPY +system.dtb/ boot/
    RUN tar --create -f boot.tar -C boot .
    SAVE ARTIFACT boot.tar
```

もちろんディスクイメージを作ったからといって、なにか変更を加えたときに毎回焼き直す必要はありません。例えば RPU のアプリケーションや Devicetree を変更しただけなら第1パーティションだけ、といった感じに2回目以降は変更があった箇所だけ書き直せば十分です。またせっかく載せたリッチな Linux 環境を活用して、USB メモリやネットワーク経由でファイルが転送できると思います。APU のアプリケーションは、何かしらの修正を加えたものをシュッと転送してすぐ試す、ができます。

もちろん Ultra96 は SD カードからしかブートできないわけではありません。JTAG を使ってロードし直すのもアリですね。

### ビルド！

Earthly は1回のコマンド実行で1つのターゲットしか呼び出せないので、最終的に必要となるものをまとめるターゲットを作っておくのが便利です。今回の `Earthfile` では `build` がこれに対応します。`RUN` などのコマンドを使わないなら、`FROM` に `scratch` が指定できます。

```Earthfile
build:
    FROM scratch
    COPY +disk.img.zst/ .

    COPY +app-r5-0/bin/ipi-led.elf .
    COPY +boot.bin/ .
    COPY +boot.scr/ .
    COPY +fsbl.elf/ .
    COPY +generate-src/system.bit .
    COPY +pmufw.elf/ .
    COPY +system.dtb/ .
    COPY +tf-a/bl31.elf .
    COPY +u-boot/u-boot.elf .
    SAVE ARTIFACT ./*
```

早速このターゲットをビルドします。`rootfs-base.tar` のために qemu-user-static が準備できていることを再確認した上で次のコマンドを実行します。できたディスクイメージなどはローカルに持ってきたいので `--artifact` を、`--privileged` を付けたターゲット `disk.img.zst` のために `--allow-privileged` を付けます。

    $ earthly --artifact --allow-privileged +build/\* --XSA_FILE=design_1_wrapper.xsa ./build/

あとはこんな感じで `disk.img.zst` を SD カードに焼けば実機で動かせると思います。

    $ zstdcat build/disk.img.zst | sudo dd of=/dev/sdX bs=1M status=progress

## GitHub Actions

せっかく Vivado/Vitis を使うことなく (xsct-trim は使っていますが) ビルドできるようになったので、GitHub Actions 上でビルドするようにしてみました。ソフトウェアのパートに絞り、かつ GitHub Actions の設定は最低限のもののみであるとはいえ、あのバージョン管理ツールでさえ導入しにくさに定評のある Xilinx の開発環境を必要とするはずのものが GitHub Actions 上で動いているのは、Earthly 導入の副次効果であるとはいえ大きなことではないかと思います。

## 今後なんとかしたいこと

### デバッグ関連

なんとかできるといいなと思っていることの1つがデバッグです。Earthly でビルドしたバイナリはデバッグシンボルに含まれるファイルパスがコンテナ内のものなので、ホスト側環境のデバッガー等に食わせるとちゃんと認識してくれません。GDB は `set substitute-path` でファイルパスの置換ができますが、Xilinx の XSDB はできません。単なるマイコンと違って FPGA の bitstream をロードだとかもできてほしいので、じゃあ GDB だけ使おうってわけにもいかないんです。

<blockquote class="twitter-tweet tw-align-center" data-dnt="true"><p lang="ja" dir="ltr">なんか OpenOCD + GDB で Ultra96 の R5 で動いてるアプリのデバッグいけたっぽい <a href="https://t.co/EzRcJhCYyo">pic.twitter.com/EzRcJhCYyo</a></p>&mdash; ✧*。ヾ(｡ᐳ﹏ᐸ｡)ﾉﾞ。*✧ (@myon___) <a href="https://twitter.com/myon___/status/1564703405435928577?ref_src=twsrc%5Etfw">August 30, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

### ビルドをもっと速くしたい

Earthly は、基本的に同じ入力に対するビルドは1回きりで、それ以降はキャッシュを使ってくれます。言い換えれば、何かしらのターゲットが依存するファイルを少しでも変更すれば、その影響を受けた箇所以降を `RUN` などのコマンド単位で再実行しなくてはいけません。今回の `Earthfile` だと、例えば Linux カーネルをビルドする `linux` ターゲットでそれが顕著に出てくると思います。コンフィグを変更しない限り[^cache-gc]リビルドは起きません。しかしコンフィグを1行だけでも書き換えたのなら、前回のビルド結果の再利用もなく `RUN make` からやり直しです。`RUN –-mount=type=cache` や `CACHE` コマンドを使って追加のキャッシュを設定すれば何とかできたりしますが、同時に制御しづらい状態に依存を作ってしまいます。使いどころがちょっと難しいのですよね[^advanced-cache]。

[^cache-gc]: あるいはキャッシュを意図的に消すか GC がかからない限り。
[^advanced-cache]: パッケージマネージャなど、何かをダウンロードする系とは相性がよさそうです。一方でビルドキャッシュに使うのは注意な気がします、特に C や C++ を使っている場合。

もう一つビルド高速化に関連して、ターゲット内のビルド実行のジョブ数をどーやって決めるか問題があります。Earthly はターゲット間の依存関係に問題ない限り並列に実行してくれます。しかしターゲットのビルドに見込まれる時間やどれくらいの計算リソースが必要かなどはもちろん考慮してくれません。Earthly の並列実行を見込んでタスク内のジョブ数を減らせは (例えば1)、CPU が暇をしまくっているにもかかわらず時間のかかるターゲット1つだけがのんびり実行されることになったり。逆に `$(nproc)` などにすれば、一時的に CPU やメモリ、時にはディスクアクセスがすごいことになるのが十分に予想できます。今回は手抜きで `$(nproc)` を設定している箇所がいくつかあります。GitHub Actions でもメモリ不足で殺されることなく動いているようですし、[ThinkPad X13 Gen2](/blog/2020/09/01/thinkpad-x13/) の 16GB RAM と約 6 GB のスワップという環境でも、一瞬スワップの使用量がグンと上がる程度でなんとかなっているのでまぁ許容範囲？です。ブラウザのタブをめっちゃ開いていたらいくつかクラッシュしちゃうかもですが。

## おわり

Earthly という Build automation tool の紹介と、それを Zynq のソフトウェアプロジェクトに導入してみた例を紹介しました。Earthly が個々のソフトウェアのビルド方法自体は大きく変えなくてよく比較的簡単に導入できること、そしてコンテナ内でのビルドで様々な恩恵が得られることが伝わればと思います。Zynq に関しては、イマドキできて当たり前の開発ワークフローでさえ導入しづらく苦労していたものが、Earthly のおかげで随分と開発環境を改善できました。

## おまけ: 内部実装いろいろ

### Zynq UltraScale+ の IPI をそのまま使う

今回の IPI の用途はとても単純なので、この文脈でよく出てくる libmetal や OpenAMP は使っていません。RPU は embeddedsw に含まれる `XIpiPsu` で、APU 側は Userspace I/O を介して IPI を直接操作しています。

IPI の基本操作 (主要レジスタ) は、割り込みの有効・無効 (`IER`, `IDR`)、IPI の Trigger (`TRIG`)、割り込みを受けたときのステータス確認とクリア (`ISR`)、割り込みを起こせたか・ターゲットがそれをクリアしたかの確認 (`OBS`) です。どの操作も、読み書きする値はターゲットの channel に対応するビットマスクです。今回の実装では、RPU 0 をデフォルトの channel 1 に, APU を channel 7 を割り当てました[^ipi-ch-apu]。ビットマスクはそれぞれ 8 bit 目と 24 bit 目がこれに対応します。

[^ipi-ch-apu]: APU にデフォルトで割り当てられているのは channel 0 です。ただしこれは、XSCT が生成した Devicetree ノード `mailbox@ff990400` や OpenAMP 関連の資料にあるように PMU とやりとりするのに使っているようです。RPU 0 とやりとりで扱うビットに影響しない気もしますが、わざわざほかのプロセッサやソフトウェアが既に使っている領域を共有する必要もないです。channel 7 以降は未割り当てなのでこれを使います。

ということで、まずは embeddedsw の `XIpiPsu` を使った RPU 側アプリケーションの例です。`XIpiPsu` は、レジスタの操作ほぼそのままのインターフェイスを提供しているようです。`xparameters.h` には channel 7 に相当する `XPAR_XIPIPS_TARGET_PSU_CORTEXA53_0_CH0_MASK` のような定数がないので、コードのなかで定義しています。

```cpp
inline constexpr std::uint32_t IPI_TRIG_CH7_MASK = std::uint32_t{1} << 24;

XIpiPsu ipi{};
{
  auto cfg = XIpiPsu_LookupConfig(XPAR_PSU_IPI_1_DEVICE_ID);
  XIpiPsu_CfgInitialize(&ipi, cfg, cfg->BaseAddress);
}

XIpiPsu_InterruptEnable(&ipi, IPI_TRIG_CH7_MASK);       // IER
XIpiPsu_InterruptDisable(&ipi, IPI_TRIG_CH7_MASK);      // IDR
XIpiPsu_TriggerIpi(&ipi, IPI_TRIG_CH7_MASK);            // TRIG
XIpiPsu_ClearInterruptStatus(&ipi, IPI_TRIG_CH7_MASK);  // ISR write (clear)

XIpiPsu_GetInterruptStatus(ipi);  // ISR read
XIpiPsu_GetObsStatus(&ipi)        // OBS
```

続いて Linux 側です。IPI のレジスタを UIO で使えるように、カーネルは `CONFIG_UIO_PDRV_GENIRQ` を有効にしておきます。

```
Device Drivers  --->
    <*> Userspace I/O drivers  --->
        <M>   Userspace I/O platform driver with generic IRQ handling
```

そして Devicetree に UIO デバイスのノードを追加します。`compatible` や `uio_pdrv_genirq.of_id` に設定する文字列は、この界隈の慣習 (?) にならって `generic-uio` にしています。実際は何でもよいはずです。node-name も名前がかぶらなければ何でもよいと思います。一応 [Devicetree Specification](https://www.devicetree.org/specifications/) には Generic Names Recommendation というセクションがありますが、これに当てはまりそうなものはなさそうです。unit-address は対応するもののベースアドレスにしておくのが無難です。

```dts
/ {
  ipi-ctrl@ff340000 {
    compatible = "generic-uio";
    reg = <0x0 0xff340000 0x0 0x1000>;
    interrupt-parent = <&gic>;
    interrupts = <0 29 4>;
  };
};
```

これで IPI のレジスタなどに `/dev/uioN` でアクセスできます。実際に操作するコードは例えばこんな感じです。まぁ UIO で見えるようになったレジスタに対して値を読み書きするだけですね。

```cpp
inline constexpr std::size_t IPI_TRIG = 0; // Interrupt Trigger
inline constexpr std::size_t IPI_OBS = 1;  // Interrupt Observation
inline constexpr std::size_t IPI_ISR = 4;  // Interrupt Status and Clear
inline constexpr std::size_t IPI_IMR = 5;  // Interrupt Mask
inline constexpr std::size_t IPI_IER = 6;  // Interrupt Enable
inline constexpr std::size_t IPI_IDR = 7;  // Interrupt Disable

inline constexpr std::uint32_t IPI_TRIG_RPU0_MASK = std::uint32_t{1} << 8;

int fd = ::open("/dev/uioN", O_RDWR | O_CLOEXEC);

auto reg = static_cast<std::uint32_t*>(
    ::mmap(nullptr, mapsize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0));

reg[IPI_IER] = IPI_TRIG_RPU0_MASK;   // IER
reg[IPI_IDR] = IPI_TRIG_RPU0_MASK;   // IDR
reg[IPI_TRIG] = IPI_TRIG_RPU0_MASK;  // TRIG
reg[IPI_ISR] = IPI_TRIG_RPU0_MASK;   // ISR write (clear)

const auto isr = reg[IPI_ISR];  // ISR read
const auto obs = reg[IPI_OBS];  // OBS
```

UIO を使った場合の割り込みはちょっとおもしろいです。`open` したときの file descriptor に1 (non-zero value) を `write` すると、割り込みが来たタイミングで `read` が返ってくるというインターフェイスになっています。読み出した値は使っていませんが、カーネルの実装を見た感じでは割り込み毎に増えていくカウンタのようですね。

```cpp
for (;;) {
  std::uint32_t irq = 1;

  // 次の read() で割り込みを受け取る
  if (::write(fd &irq, sizeof irq) < 0) {
    std::perror("write");
    return -1;
  }

  // 割り込みを待つ
  if (::read(fd, &irq, sizeof irq) < 0) {
    std::perror("read");
    return -1;
  }

  // 割り込みクリア
  if (reg[IPI_ISR] & IPI_TRIG_RPU0_MASK) {
    reg[IPI_ISR] = IPI_TRIG_RPU0_MASK;
  }
}
```

さて、これで互いに IPI を飛ばせるようになりました。では IPI を飛ばしたタイミングで何かしらのデータをやりとりしたい場合はどうするかです。今回は [Technical Reference Manual (TRM, UG1085)](https://docs.xilinx.com/v/u/en-US/ug1085-zynq-ultrascale-trm) の IPI と同じ場所で言及されている Message Buffer を使いました。Message Buffer は、IPI の requester/responder の組み合わせ1つあたりに request/response それぞれ 32 byte が確保されたメモリ空間です。IPI を使うプロセッサなど (TRM の言葉だと Agent) は8つあるので、Agent 毎に 0x20 \* 2 \* 8 = 0x200 byte ですね。

この Message Buffer の厄介なところが、ある IPI の request/response でどこを使えばいいのかがわかりにくいところです。channel と buffer index がとてもまぎらわしいし、おまけに TRM に書いてあるアドレスと `xparameters.h` の値がなんか違う気がします。今回の構成における値を`xparameters.h` の値をもとに表にしてみました。環境・構成によっては変わってくるかもしれないことに注意です。

| Channel Number | Owner | Message Buffer Index | Address |
| --- | --- | --- | --- |
| Channel 0  | APU   | 2 | `0xff99'0400` |
| Channel 1  | RPU 0 | 0 | `0xff99'0000` |
| Channel 2  | RPU 1 | 1 | `0xff99'0200` |
| Channel 3  | PMU   | 7 | `0xff99'0e00` |
| Channel 4  | PMU   | 7 | |
| Channel 5  | PMU   | 7 | |
| Channel 6  | PMU   | 7 | |
| Channel 7  | PL 0  | 3 | `0xff99'0600` |
| Channel 8  | PL 1  | 4 | `0xff99'0800` |
| Channel 9  | PL 2  | 5 | `0xff99'0a00` |
| Channel 10 | PL 3  | 6 | `0xff99'0c00` |

0x200 byte の領域の区切られ方も buffer index 順です。ということで RPU 0 (ch 1, idx 0) -> APU (ch 7, idx 3) の IPI では `0xff99'00c0` と `0xff99'00e0`、APU -> RPU 0 の IPI では `0xff99'0600` と `0xff99'0620` を使えばいいことがわかります。Linux の場合は Devicetree にこんな感じの設定をし、IPI レジスタと同様 `mmap` した領域を介してアクセスできるようにしました。なお、実際に Message Buffer を使っているのは APU から RPU に IPI するときだけです。

```dts
/ {
  ipi-buffer@ff990000 {
    compatible = "generic-uio";
    reg = <0x0 0xff990600 0x0 0x20>, // APU -> RPU0 request
          <0x0 0xff990620 0x0 0x20>, // RPU0 -> APU response
          <0x0 0xff9900c0 0x0 0x20>, // RPU0 -> APU request
          <0x0 0xff9900e0 0x0 0x20>; // APU -> RPU0 response
  };
};
```

### L チカを支える TTC

RPU から使えるタイマー・カウンターとして、LPD にある4つの Triple-timer counter (TTC) があります。今回はこのうちの1つを 10 Hz で割り込みが飛ぶようにして L チカのタイミング制御に使っています。

TTC は名前の通り、3つのカウンターを持つユニットです。それが4つあるので合計12個のカウンターがあることになります。`xparameters.h` では、1つ目の TTC が持つカウンターから順に `XPAR_PSU_TTC_0_*`, `XPAR_PSU_TTC_1_*`, ..., `XPAR_PSU_TTC_12_*` と名前が付いています。ちょっとまぎらわしいので注意です。また XSCT で BSP を作ったときに出力されるメッセージや `xparameters.h` の記述にある通り、カウンターの1つは `sleep` などの実装に使われるようなので、実際に使えるカウンターは11個です。

    +generate-src | psu_ttc_3 will be used in sleep routines for delay generation

今回は `xparameters.h` の `XPAR_PSU_TTC_0`、つまり TTC0 の1つ目のカウンターを使いました。10 Hz の Interval Mode で割り込みを設定するならこんな感じです。ちなみに、デバッグなどで実行中のアプリケーションを何度もロードし直すことも想定した場合、`XTtcPs_CfgInitialize()` の前にレジスタを直接操作するなどで TTC を無理やり無効化するなどの処理を入れるのがいいと思います。もしこのタイミングで TTC が動いていた場合、[`XTtcPs_CfgInitialize()` がエラーを返してしまう](https://github.com/Xilinx/embeddedsw/blob/b3d8b420b421730ea505da55b42174dc90f885c1/XilinxProcessorIPLib/drivers/ttcps/src/xttcps.c#L121-L127)ためです。

```cpp
static void ttc_irq_handler(void* data) noexcept {
  auto ttc = static_cast<XTtcPs*>(data);
  const auto status = XTtcPs_GetInterruptStatus(ttc);
  if (status & XTTCPS_IXR_INTERVAL_MASK) {
    // ...

    XTtcPs_ClearInterruptStatus(ttc, XTTCPS_IXR_INTERVAL_MASK);
  }
}


XTtcPs ttc{};
{
  auto cfg = XTtcPs_LookupConfig(XPAR_PSU_TTC_0_DEVICE_ID);
  XTtcPs_CfgInitialize(&ttc, cfg, cfg->BaseAddress);

  XTtcPs_SetOptions(&ttc, XTTCPS_OPTION_INTERVAL_MODE | XTTCPS_OPTION_WAVE_DISABLE);

  XInterval interval;
  std::uint8_t prescaler;
  XTtcPs_CalcIntervalFromFreq(&ttc, 10, &interval, &prescaler); // 10 Hz
  XTtcPs_SetInterval(&ttc, interval);
  XTtcPs_SetPrescaler(&ttc, prescaler);

  XTtcPs_EnableInterrupts(&ttc, XTTCPS_IXR_INTERVAL_MASK);
  XTtcPs_ClearInterruptStatus(&ttc, XTTCPS_IXR_ALL_MASK);

  XScuGic_Connect(&gic, XPAR_PSU_TTC_0_INTR, ttc_irq_handler, &ttc);
  XScuGic_Enable(&gic, XPAR_PSU_TTC_0_INTR);
}
```

### PS GPIO の任意の複数ピンを同時に扱う

ほかに RPU から使っているのは GPIO です。Ultra96 の LED は `PS_MIO{17, ..., 20}` につながっているので `XGpioPs` を使います。

GPIO の操作というと、ピン単位かポートやバンクなどと呼ばれるまとまった単位で操作するのが一般的だと思います。`XGpioPs` も、`XGpioPs_Read()`, `XGpioPs_Write()` などバンク単位での操作と、`XGpioPs_ReadPin()`, `XGpioPs_WritePin()` などピン単位の操作が C の関数として定義されています。LED 4つを一度に操作するなら、ちょうどそれらが同じバンクにあるので、例えばこんな感じにかけそうです。

```cpp
inline constexpr std::uint32_t GPIO_BANK0_LED_MASK = std::uint32_t{0b1111} << 17;

inline void set_ultra96_leds(XGpioPs& gpio, std::uint8_t value) noexcept {
  const auto r = XGpioPs_Read(&gpio, 0);
  XGpioPs_Write(&gpio, 0, (r & ~GPIO_BANK0_LED_MASK) | ((value * 0b1111) << 17));
}
```

しかし、これだと一度 GPIO の値を読み出しているのがなんだかもにょっとします。また、`XGpioPs_Write()` がそのバンク全体に影響する操作なのもちょっとこわいです。特に APU で動いている Linux も GPIO を触れる状況にあるので、(実際に bank 0 を使うものはいないはずですが) 互いの処理の実行され方によっては整合性が取れなくなってしまうかもしれません。もちろん、そんな状況が想定される設計にしないに越したことはありませんが、いずれにせよ Zynq という同じメモリ空間を複数のプロセッサなどが共有している環境では注意しておくべきです[^resource-conflict]。

[^resource-conflict]: SoC 内のあらゆるリソースが同じメモリ空間にアクセスできるの、Zynq のおもしろく強力であり、同時にコワイところですよね。ちなみに XSCT が生成する `.dts` はデフォルトで何でも有効になっているので、RPU などからさわるリソースは `status` を `disabled` または `reserved` にしたり、PL 上のリソースは `/delete-node/` するのがよいです。デバイスドライバーによっては probe の段階でペリフェラルにリセットかけたりとかしちゃうので。

どうしたものかと TRM などを眺めていると、`MASK_DATA_{LSW,MSW}` というレジスタがあるのに気づきます。これは各バンクに属する下 16 bit・上 10 bit に対し、一度にビットマスクとデータを渡すことで特定のピンだけの出力を指定できるようです。まさに探していたものですね。`PS_MIO{17, ..., 20}` は bank 0 の上位10 bit の枠になるので、`MASK_DATA_0_MSW` に対してこんな感じにしてやればいいですね。

```cpp
inline constexpr std::uint32_t GPIO_BANK0_LED_MASK = std::uint32_t{0b1111} << 17;

inline void set_ultra96_leds(XGpioPs& gpio, std::uint8_t value) noexcept {
  XGpioPs_WriteReg(
    gpio.GpioConfig.BaseAddr, XGPIOPS_DATA_MSW_OFFSET,
    // MASK_DATA_0_MSW の上位 16 bit はマスク
    // `PS_MIO{17, ..., 20}` 以外に対応するものを 1 にする
    (~GPIO_BANK0_LED_MASK & 0xffff0000) |
    // `PS_MIO{17, ..., 20}` に設定する値
    ((value & 0b1111) << 1)
  );
}
```

### Vitis で作ったベアメタルアプリケーションを CMake でビルドする

上でちょろっと紹介したように、RPU 側アプリケーションの実装は Vitis で作った Appication Project からファイルを持ってきた上で CMake でビルドできるようにしたものです。`main.cc` 1つだけにわざわざ CMake を使わなくてよいですが、これをテンプレート的に別プロジェクトで使いまわすことを想定してのものです。

embeddedsw で提供されるいろいろを使うには、`libxil.a` などをリンクしなければいけません。`libxil.a` の検出とコンパイル・リンクのために、少々雑ではありますが `FindLibXil.cmake` を書きました。standalone 以外のライブラリも `find_package()` の `COMPONENTS` で指定できるようになっています。各ライブラリに対応するターゲットは、`add_library(LibXil::standalone INTERFACE IMPORTED)` のように `INTERFACE IMPORTED` で宣言しています。よくある `STATIC` や `UNKNOWN` でなく `INTERFACE` なのは、これらを単に `-l<ほげほげ>` でリンクできず、`--start-group,...,--end-group` でリンク順を明示してやらないといけないためです。続く `set_target_properties()` でそうしたリンクオプションを指定しています。

```cmake
if(LibXil_standalone_FOUND AND NOT TARGET LibXil::standalone)
  add_library(LibXil::standalone INTERFACE IMPORTED)
  set_target_properties(LibXil::standalone PROPERTIES
    INTERFACE_LINK_LIBRARIES "-Wl,--start-group,${standalone_lib},-lgcc,-lc,-lstdc++,--end-group"
    INTERFACE_INCLUDE_DIRECTORIES "${standalone_include}")
endif()
```

ちなみに、各ライブラリをどの順でリンクすればいいのかは、embeddedsw の `.mld` ファイルで `OPTION APP_LINKER_FLAGS` を見ればよいです。例えば xilffs なら[こんな行](https://github.com/Xilinx/embeddedsw/blob/b3d8b420b421730ea505da55b42174dc90f885c1/lib/sw_services/xilffs/data/xilffs.mld#L22)があるのを見つけられると思います。

```tcl
OPTION APP_LINKER_FLAGS = "-Wl,--start-group,-lxilffs,-lxil,-lgcc,-lc,--end-group";
```

### ISR で atomic 使うのって実際どうなの

割り込みハンドラーにたくさん実装を入れたくないので、「割り込みがあったかどうかのフラグ」を立てるなど最低限の処理だけにして、実際の処理はメインループの中でやる、という実装をしています。こうした「割り込みがあったかどうかのフラグ」などの割り込みハンドラーと共有する値は、コンパイラが意図しない最適化をしてしまわないように何かしらの対策をするのが一般的です。その値がコンパイラから見てどこか別のところから書き換えられることのない定数のように見えたとしても、実際には突発的に呼び出される割り込みハンドラーから書き換えられる可能性がるからコードの意味を変えないでね、と伝えてやるイメージです。

C/C++ の組み込みプログラミングでよく使われるのが `volatile` です。ただ `volatile` が何者なのか正直よくわからず、なんだか「とりあえず `volatile` 付けておけば安心！」に見えてしまうのでうーんです。その代替手段として [`<atomic>`](https://en.cppreference.com/w/cpp/header/atomic) を試してみています。

一番単純な例が TTC 割り込みの部分です。[`std::atomic_flag`](https://en.cppreference.com/w/cpp/atomic/atomic_flag) を使い、set を割り込み待ちの状態、clear を割り込みが起きた状態とします。メインループの中で [`test_and_set()`](https://en.cppreference.com/w/cpp/atomic/atomic_flag/test_and_set) を呼び出し、その時点での値が clear された状態 (`false`) だったら割り込みに対する処理、という感じです。

```cpp
static std::atomic_flag ttc_irq_kicked_n = ATOMIC_FLAG_INIT;

static void ttc_irq_handler(void* data) noexcept {
  auto ttc = static_cast<XTtcPs*>(data);
  const auto status = XTtcPs_GetInterruptStatus(ttc);
  if (status & XTTCPS_IXR_INTERVAL_MASK) {
    ttc_irq_kicked_n.clear(std::memory_order_relaxed);

    XTtcPs_ClearInterruptStatus(ttc, XTTCPS_IXR_INTERVAL_MASK);
  }
}

for (;;) {
  asm volatile("wfi");

  if (!ttc_irq_kicked_n.test_and_set(std::memory_order_relaxed)) {
    // TTC 割り込みがあったときの処理
  }
}
```

IPI 割り込みでは [`std::atomic<std::uint32_t>`](https://en.cppreference.com/w/cpp/atomic/atomic) を使って Message Buffer から読み込んだ値を渡す目的も兼ねています。最上位ビットを割り込みが起きた状態かどうかに、残りを Message Buffer から呼んだ値とします。メインループでは [`exchange()`](https://en.cppreference.com/w/cpp/atomic/atomic/exchange) を呼び出して値を 0 に置き換えつつ、その時点での値の最上位ビットが立っていたら割り込みに対する処理、という感じです。

```cpp
static std::atomic<std::uint32_t> ipi_req{0};

static void ipi_irq_handler(void* data) noexcept {
  auto ipi = static_cast<XIpiPsu*>(data);
  const auto status = XIpiPsu_GetInterruptStatus(ipi);
  if (status & IPI_TRIG_CH7_MASK) {
    const std::uint32_t req = Xil_In32(XPAR_PSU_MESSAGE_BUFFERS_S_AXI_BASEADDR + 0x600);
    ipi_req.store(req | 0x8000'0000, std::memory_order_relaxed);

    XIpiPsu_ClearInterruptStatus(ipi, IPI_TRIG_CH7_MASK);
  }
}

for (;;) {
  asm volatile("wfi");

  if (const auto req = ipi_req.exchange(0, std::memory_order_relaxed); req & 0x8000'0000) {
    // TTC 割り込みがあったときの処理
  }
}
```

これでどちらもそれっぽく動いているものの、正直 `volatile` と同様に `<atomic>` についても詳しいわけではないので、この使い方がアリなのかあまり自信がありません。Rust の[この資料](https://docs.rust-embedded.org/book/concurrency/#atomic-access)とかは一例として紹介されたりはしていますね。

### RPU の Lock-Step Mode と TCM

RPU は Tightly Coupled Memory (TCM) とよばれる特別なメモリ領域にプログラムを配置できます。TCM はキャッシュを介さない予測可能時間でのアクセスや ECC が付いていたりする、RPU らしいメモリです。しかしこの TCM、容量がコア毎に 64 KB x 2 なので、ちょっと大きなものを載せようとすると厳しいことがあります。実際、開発中に `.text` が 64 KB を超えて収まらなくなったことがありました。

この対策 (?) になりそうな方法の1つとして、RPU を Lock-Step で動かすというのがあります。TRM によれば

> During the lock-step operation, the TCMs that are associated with the redundant processor become available to the lock-step processor. The size of ATCM and BTCM become 128 KB each with BTCM supporting interleaved accesses from processor and AXI slave interface.

とあるためです。で、実際に linker script を変えてみたのですが…なんだかあやしいです。デバッガーでロードさせると問題ないのに、`boot.bin` に入れて FSBL で Linux と一緒にロードさせると途中で RPU 側のアプリケーションがお亡くなりになってしまうのです。デバッガーを使うと問題ないというのが厄介で、結局調査は諦めました。`.text` が 64 KB 超えた問題も、ちょっとコード変えただけで余裕で収まるようになりましたし。しかし謎…。

### Systemd Unit File を追加して Ubuntu のブート時にいろいろ動かす

Linux 側で動かすアプリケーションは、電源を投入したら何もせず勝手に動いてほしいです。今回は Ubuntu が動いているので、そこに Systemd の unit file を追加して実現しました。こんな感じです。

```ini
[Unit]
Description=Trigger IPI to flash LEDs
Wants=modprobe@uio_pdrv_genirq.service
After=modprobe@uio_pdrv_genirq.service

[Service]
Type=simple
ExecStart=/usr/bin/ipi-led
DevicePolicy=closed
DeviceAllow=char-uio

[Install]
WantedBy=multi-user.target
```

Systemd 世代なら見慣れた記述だと思います。カーネルモジュール `uio_pdrv_genirq` に依存しているので、それを `modprobe@uio_pdrv_genirq.service` と指定しています。`[Service]` で指定した処理は特に何もしなければ root で動いてしまうので、本格的に何かやろうとするなら別ユーザーで動かすなど権限を絞るべきです。今回は一発ネタなので手を抜いています。とはいえ何もしないのもおもしろくないので、お気持ち程度のリソース制限を付けました。`DevicePolicy=closed` と `DeviceAllow=char-uio` を設定して、`ipi-led` からは `/dev/null`, `/dev/zero` などの基本的なデバイスと `/dev/uio*` しか見えなくなっているはずです。

`ipi-led` 以外にもいくつかの unit file を追加しています。まずは [`maximize-root-partition.service`](https://github.com/Tosainu/earthly-zynqmp-example/blob/27538797d4663eb2637bf9e8570dc23e7465f126/linux/rootfs/etc/systemd/system/maximize-root-partition.service) です。`disk.img.zst` で作った Linux 側のパーティションは 256 MiB しかないので、最初にブートしたときに `parted` と `resize2fs` を呼び出してリサイズします。リサイズが済んだらもう役目はないので、unit file の中で `systemctl disable` しています。

もう1つが [`setup-usb-ether.service`](https://github.com/Tosainu/earthly-zynqmp-example/blob/27538797d4663eb2637bf9e8570dc23e7465f126/linux/rootfs/etc/systemd/system/setup-usb-ether.service) で、USB Gadget を使ったネットワーク接続を設定します。USB Gadget 経由のネットワークは想像していたより快適でした。Ultra96 実機上で複雑な作業をするのであればぜひオススメしたいです。ちなみに、これに関連して `system-top-append.dts` に PS-GTR の refclock の設定や USB 関連の pinctrl の設定を追加しています。設定しないとないと相手 PC 側で突然 disconnect 扱いになってしまうなど不安定でした。PS-GTR の refclock 情報は `.xsa` に入っていた気がするので、それだけでも やってくれるといいのになと思いました。

<blockquote class="twitter-tweet tw-align-center" data-dnt="true"><p lang="cs" dir="ltr">naruhodo <a href="https://t.co/iapfw9ABxP">pic.twitter.com/iapfw9ABxP</a></p>&mdash; ✧*。ヾ(｡ᐳ﹏ᐸ｡)ﾉﾞ。*✧ (@myon___) <a href="https://twitter.com/myon___/status/1518165469169332224?ref_src=twsrc%5Etfw">April 24, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

せっかくなので、USB で繋いだらすぐ SSH できるようにと Ubuntu 環境に `openssh-server` も入れようとしていました。ただ、Ubuntu の `openssh` パッケージはパッケージがインストールされるときに host key を生成しているようだったため見送りました[^deb-pkg]。こうしたファイルを配布も想定したディスクイメージに含めたくないし、かと言って何かしらの workaround を設定するのも面倒だったので。

[^deb-pkg]: これに限らず、Ubuntu とかのパッケージはインストール時の hook でいろいろやり過ぎな気がします。特にパッケージに含まれるサービスをその場で start してくるやつが本当に好きじゃないです。ソフトウェアの設定を確認する前に勝手に動き出しちゃうってこわくないですか。
