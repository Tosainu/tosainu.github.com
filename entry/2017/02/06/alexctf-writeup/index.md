---
title: AlexCTF writeup
date: 2017-02-06 20:16:00+0900
tags: CTF
---

[AlexCTF](https://ctf.oddcoder.com/) にも一人チーム [poepoe](https://ctf.oddcoder.com/team/568) でこっそり参加. 590 points で 385 位でした.

<!--more-->

## Cryptography

### CR1: Ultracoded <small>(50pt)</small>

こんな感じのテキストファイルが与えられる.

    $ cat zero_one
    ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ZERO ZERO ZERO ONE ZERO ONE ONE ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ONE ZERO ONE ZERO ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ONE ZERO ONE ZERO ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ZERO ZERO ONE ONE ZERO ZERO ONE ONE ONE ZERO ONE ZERO ZERO ONE ONE ZERO ZERO ZERO ONE ZERO ONE ZERO ZERO ZERO ONE ZERO ZERO ONE ONE ONE ONE ZERO ONE ZERO ZERO ONE ONE ONE ONE ZERO ONE

`01` になおして ascii にすると Base64 ぽいのが出てきて, それを decode すると `.` と `-` の羅列が出てきた.

```cpp
#include <bitset>
#include <fstream>
#include <iostream>
#include <boost/algorithm/string.hpp>

auto main() -> int {
  auto str = [] {
    std::ifstream ifs("./zero_one");
    return std::string{std::istreambuf_iterator<char>(ifs), std::istreambuf_iterator<char>()};
  }();

  boost::algorithm::replace_all(str, "ZERO", "0");
  boost::algorithm::replace_all(str, "ONE", "1");
  boost::algorithm::erase_all(str, " ");
  boost::algorithm::erase_all(str, "\n");

  for (auto i = 0u; i < str.size(); i += 8) {
    std::bitset<8> b(str, i, 8);
    std::cout << static_cast<char>(b.to_ulong());
  }
}
```

    $ clang++ -Wall -Wextra -pedantic -std=c++14 toascii.cc -o toascii
    
    $ ./toascii 
    Li0gLi0uLiAuIC0uLi0gLS4tLiAtIC4uLS4gLSAuLi4uIC4tLS0tIC4uLi4uIC0tLSAuLS0tLSAuLi4gLS0tIC4uLi4uIC4uLSAuLS0uIC4uLi0tIC4tLiAtLS0gLi4uLi4gLiAtLi0uIC4tLiAuLi4tLSAtIC0tLSAtIC0uLi0gLQ==

    $ ./toascii | base64 -d
    .- .-.. . -..- -.-. - ..-. - .... .---- ..... --- .---- ... --- ..... ..- .--. ...-- .-. --- ..... . -.-. .-. ...-- - --- - -..- -

[Morse Code Translator](http://morsecode.scphillips.com/translator.html) に投げたらそれっぽいのが出てきたので, 少し修正したら通った.

    ALEXCTFTH15O1SO5UP3RO5ECR3TOTXT -> ALEXCTF{TH15_1S_5UP3R_5ECR3T_TXT}

## Forensics

### Fore1: Hit the core <small>(50pt)</small>

core dump ファイル? が与えられる.  
最初は gdb とか使えばいいのかなーと思ったけど, 実行ファイルは置かれてないのでうーん...

諦めて `strings` してみると, こんな文字列が見つかった.

    $ strings fore1.core
    (...)
    cvqAeqacLtqazEigwiXobxrCrtuiTzahfFreqc{bnjrKwgk83kgd43j85ePgb_e_rwqr7fvbmHjklo3tews_hmkogooyf0vbnk0ii87Drfgh_n kiwutfb0ghk9ro987k5tfb_hjiouo087ptfcv}
    (...)

4文字ずつ消していくと Flag が出てきた.

    ALEXCTF{K33P_7H3_g00D_w0rk_up}

### Fore3: USB probing <small>(150pt)</small>

USB の通信を読んだっぽい pcap ファイルが与えられる.  
Wireshark で一番大きな Frame を見たら png 画像が入ってて, そこに Flag が書かれてた.

    ALEXCTF{SN1FF_TH3_FL4G_0V3R_U58}

## Reverse Engineering

### RE1: Gifted <small>(50pt)</small>

32bit の ELF.

    $ file gifted 
    gifted: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=50f578e89c55c2bde7f6c02b9f083fe7656d9d4d, stripped

`scanf("%s", str)` で読んだ文字列を `strcmp(flag, str)` してるだけなので, 比較してる文字列を読むだけ.

    $ r2 -A gifted
    [x] Analyze all flags starting with sym. and entry0 (aa)
    [x] Analyze len bytes of instructions for references (aar)
    [x] Analyze function calls (aac)
    [ ] [*] Use -AA or aaaa to perform additional experimental analysis.
    [x] Constructing a function name for fcn.* and sym.func.* functions (aan))
     -- Of course r2 runs FreeBSD
    [0x08048430]> e asm.comments = false
    [0x08048430]> e asm.nbytes = 0
    [0x08048430]> pdf @ main
    / (fcn) main 146
    |   main ();
    |           ; var int local_ch @ ebp-0xc
    |           ; var int local_4h @ esp+0x4
    |           0x0804852b      lea ecx, dword [esp + local_4h]
    |           0x0804852f      and esp, 0xfffffff0
    |           0x08048532      push dword [ecx - 4]
    |           0x08048535      push ebp
    |           0x08048536      mov ebp, esp
    |           0x08048538      push ecx
    |           0x08048539      sub esp, 0x14
    |           0x0804853c      sub esp, 0xc
    |           0x0804853f      push str.Enter_the_flag: ; str.Enter_the_flag:
    |           0x08048544      call sym.imp.printf
    |           0x08048549      add esp, 0x10
    |           0x0804854c      sub esp, 0xc
    |           0x0804854f      push 0x3e8
    |           0x08048554      call sym.imp.malloc
    |           0x08048559      add esp, 0x10
    |           0x0804855c      mov dword [ebp - local_ch], eax
    |           0x0804855f      sub esp, 8
    |           0x08048562      push dword [ebp - local_ch]
    |           0x08048565      push 0x8048655
    |           0x0804856a      call sym.imp.__isoc99_scanf
    |           0x0804856f      add esp, 0x10
    |           0x08048572      sub esp, 8
    |           0x08048575      push dword [ebp - local_ch]
    |           0x08048578      push str.AlexCTF_Y0u_h4v3_45t0n15h1ng_futur3_1n_r3v3r5ing_ ; str.AlexCTF_Y0u_h4v3_45t0n15h1ng_futur3_1n_r3v3r5ing_
    |           0x0804857d      call sym.imp.strcmp
    |           0x08048582      add esp, 0x10
    |           0x08048585      test eax, eax
    |       ,=< 0x08048587      jne 0x80485a3
    |       |   0x08048589      sub esp, 0xc
    |       |   0x0804858c      push str.You_got_it_right_dude_ ; str.You_got_it_right_dude_
    |       |   0x08048591      call sym.imp.puts
    |       |   0x08048596      add esp, 0x10
    |       |   0x08048599      sub esp, 0xc
    |       |   0x0804859c      push 0
    |       |   0x0804859e      call sym.imp.exit
    |       `-> 0x080485a3      sub esp, 0xc
    |           0x080485a6      push str.Try_harder_ ; str.Try_harder_
    |           0x080485ab      call sym.imp.puts
    |           0x080485b0      add esp, 0x10
    |           0x080485b3      sub esp, 0xc
    |           0x080485b6      push 0
    \           0x080485b8      call sym.imp.exit
    [0x08048430]> ps @ str.AlexCTF_Y0u_h4v3_45t0n15h1ng_futur3_1n_r3v3r5ing_
    AlexCTF{Y0u_h4v3_45t0n15h1ng_futur3_1n_r3v3r5ing}

### RE2: C++ is awesome <small>(100pt)</small>

64bit の ELF. タイトルの通り C++ で書かれたっぽい.

    $ file re2 
    re2: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=08fba98083e7c1f7171fd17c82befdfe1dcbcc82, stripped

調べていくと

1. `argv[1]` を `std::string` にする
2. (1) の文字列を何らかの規則で内部の文字列と比較
  - (文字数足りなくても) OK だったら `"You should have the flag by now"`
  - NG だったら `"Better luck next time"`

という感じだったので, `"You should have the flag by now"` になる入力を `/ALEXCTF{[A-Za-z0-9_]*}/` にマッチするまで増やしていけばok. 昔似たようなスクリプトを書いたのが残ってたのでそれを流用した.

```ruby
chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz{}_'

c = 0
i = 0
flag = chars[c]

while true do
  print "[*] '#{flag}' - "

  case `./re2 #{flag}`
  when /Better luck next time/ then
    puts 'failed'
    c = c.next
    flag[i] = chars[c]
  when /You should have the flag by now/ then
    if /ALEXCTF{[A-Za-z0-9_]*}/ =~ flag then
      puts 'done!'
      break
    else
      puts 'failed'
      c = 0
      i = i.next
      flag << chars[c]
    end
  end
end
```

    $ ruby solve.rb
    [*] '0' - failed
    [*] '1' - failed
    [*] '2' - failed
    (...)
    [*] 'ALEXCTF{W3_L0v3_C_W1th_CL45535z' - failed
    [*] 'ALEXCTF{W3_L0v3_C_W1th_CL45535{' - failed
    [*] 'ALEXCTF{W3_L0v3_C_W1th_CL45535}' - done!

"内部で比較に使っている文字列" ってのもちゃんと Leet になってておもしろかった.

    $ r2 -A re2
    (...)
    [0x00400a60]> pd 3 @ 0x00400c57
              0x00400c57      movzx edx, byte [rax]
              0x00400c5a      mov rcx, qword [str.L3t_ME_T3ll_Y0u_S0m3th1ng_1mp0rtant_A__FL4G__W0nt_b3_3X4ctly_th4t_345y_t0_c4ptur3_H0wev3r_1T_w1ll_b3_C00l_1F_Y0u_g0t_1t]
              0x00400c61      mov eax, dword [rbp - local_14h]

## Scripting

### SC1: Math bot <small>(100pt)</small>

指定されたサーバにつなぐと, ランダムな2数の和差積商剰余を求める問題が出題される. 桁は多いし500問もあるし, そしてたぶん時間制限もあるので自動化したいねというやつ.  
そういえばセキュキャンでやった CTF に似たのがあった気がする. (他のメンバーにお願いしたので解いてないけど)

こういった数式の処理は得意そうだし, 大きな数も `Integer` 使えば問題なさそうなので Haskell で書いた. やっぱり Pattern matching 強い.

```haskell
module Main where

import           Network.Socket
import           System.IO

calcStr :: (Read a) => (a -> a -> a) -> String -> String -> a
calcStr f x y = f (read x) (read y)

calc :: [String] -> Maybe Integer
calc (x:"+":y:"=":[]) = Just $ calcStr (+)  x y
calc (x:"-":y:"=":[]) = Just $ calcStr (-)  x y
calc (x:"*":y:"=":[]) = Just $ calcStr (*)  x y
calc (x:"/":y:"=":[]) = Just $ calcStr quot x y
calc (x:"%":y:"=":[]) = Just $ calcStr mod  x y
calc _                = Nothing

solver :: Handle -> IO ()
solver h = hGetContents h >>= mapM_ solver' . lines
  where solver' l = putStrLn l >>
                    case calc $ words l of
                         Just x  -> print x >> hPrint h x
                         Nothing -> return ()

main :: IO ()
main = withSocketsDo $ do
  addr:_ <- getAddrInfo Nothing (Just "195.154.53.62") (Just "1337")
  s <- socket (addrFamily addr) Stream defaultProtocol
  connect s (addrAddress addr)

  socketToHandle s ReadWriteMode >>= solver
```

    $ stack runhaskell Main.hs
                    __________
             ______/ ________ \______
           _/      ____________      \_
         _/____________    ____________\_
        /  ___________ \  / ___________  \
       /  /XXXXXXXXXXX\ \/ /XXXXXXXXXXX\  \
      /  /############/    \############\  \
      |  \XXXXXXXXXXX/ _  _ \XXXXXXXXXXX/  |
    __|\_____   ___   //  \\   ___   _____/|__
    [_       \     \  X    X  /     /       _]
    __|     \ \                    / /     |__
    [____  \ \ \   ____________   / / /  ____]
         \  \ \ \/||.||.||.||.||\/ / /  /
          \_ \ \  ||.||.||.||.||  / / _/
            \ \   ||.||.||.||.||   / /
             \_   ||_||_||_||_||   _/
               \     ........     /
                \________________/

    Our system system has detected human traffic from your IP!
    Please prove you are a bot
    Question  1 :
    16009571334449958557044155891623 * 161008553970745969749861890538566 =
    2577677930251293728519863026246993767635808048267100809397832618
    Question  2 :
    37464153342495496305488535664548 - 257757927187169247290210372595388 =
    -220293773844673750984721836930840
    (...)
    Question  499 :
    64300502597679021169438215557183 + 93542697917022220746961898347602 =
    157843200514701241916400113904785
    Question  500 :
    76749452529358543077576919396189 % 319214220891644749269280458687889 =
    76749452529358543077576919396189
    Well no human got time to solve 500 ridiculous math challenges
    Congrats MR bot!
    Tell your human operator flag is: ALEXCTF{1_4M_l33t_b0t}

## Trivia

### TR1: Hello there <small>(10pt)</small>

IRC: #alexctf @freenode の Topic に書いてあった.

    ALEXCTF{W3_w15h_y0u_g00d_luck}

### TR2: SSL 0day <small>(20pt)</small>

有名なので答えはすぐわかったけど, `ALEXCTF{}` で囲まなくていいのに気づかなくてあれーってなってた.  
どーでもいいけどこれすき. [xkcd: Heartbleed Explanation](https://xkcd.com/1354/)

    heartbleed

### TR3: CA <small>(20pt)</small>

TR2と同じ理由で時間かかった... ヾ(｡>﹏<｡)ﾉﾞ

    letsencrypt

### TR4: Doesn't our logo look cool ? <small>(40pt)</small>

トップページの AA をよく見ると, `A...L..E...X...` という文字が混ざっているのに気づく. Vim で `:%j` (全行結合) -> `:%s/\v[^0-1A-Za-z{}_]//g` (Flag format にない文字を削除) すると出てきた.

    ALEXCTF{0UR_L0G0_R0CKS}

## おわり

プログラム書くのは好きなので, SC1 が一番楽しかった.  
でも参加した理由は BITSCTF と同じく pwn の力試しなので, ちょっと残念だった.
