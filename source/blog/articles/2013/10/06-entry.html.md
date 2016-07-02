---
title: Linux環境でAssemblyLangプログラミングしたメモ
date: 2013-10-06 21:11:08 JST
tags: Arduino,Linux
---
<p>どもどもー</p><p><img src="https://lh3.googleusercontent.com/-fFh3rCgGq9g/UlFSJC09C-I/AAAAAAAACpw/rmMps_jgNy4/s640/IMG_1127.JPG" /></p>
<p>ここ3日、ずっとAVRマイコンをAssemblyでプログラミングしていました。<span class="fontsize1">（きっと）</span></p>
<p>何となくわかってきたのでとりあえずメモ。</p>
<p>&nbsp;</p>
READMORE
<p>&nbsp;</p>
<h2>使用しているマイコンと回路図</h2>
<p>調べてみたところ、Arduinoに任意のHEXが書き込めるようだったので、書き込み器付きマイコンボードとしてArduino Unoを使いました。</p>
<p>プログラマを持っていなかったので助かりました・・・</p>
<p>ちなみに載っているマイコンはATmega328Pです。</p>
<p>&nbsp;</p>
<p>図のようにパーツを接続しました。</p>
<p><img src="https://lh3.googleusercontent.com/-Ho2irIwLDKM/UlFRzc2ArII/AAAAAAAACpo/i4w3oCKcjnU/s640/IMG_1125.JPG" /></p>
<p><img src="https://lh3.googleusercontent.com/-urAHq4AQKEM/UlFRc4ZG1cI/AAAAAAAACpg/n5tVlJuu6h0/s640/IMG_1141.JPG" /></p>
<p>&nbsp;</p>
<h2>追加するパッケージ</h2>
<h3>avra</h3>
<p>AVRマイコン（等）のアセンブラです。これを使って書いたコードをビルドします。</p>
<p>&nbsp;</p>
<h3>avrdude</h3>
<p>AVRマイコンのプログラマソフトです。これでビルドしたプログラムの書き込みを行います。</p>
<p>&nbsp;</p>
<p><span class="fontsize6"><span style="color:red;">2013/10/6 (Sun) 21:42:56追記</span></span></p>
<p>また、各マイコンのIncludeFileを<a href="http://members.ziggo.nl/electro1/avr/definitions.htm">このサイト</a>からダウンロードし、使うマイコンのファイルをソースと同じフォルダに配置します。</p>
<p>&nbsp;</p>
<h2>プログラム</h2>
<p>この3日で書いていたプログラムを2つ上げておきます。</p>
<p>1.PB0に接続されたスイッチを押す(内部プルアップなので入力はLOW)とLEDが消える、離すと（入力はHIGH）再び点灯</p>

```
.include "m328pdef.inc"

; Interrupt Vectors
.ORG    0x0000
  RJMP  RESET

; Reset Pin and Timer
RESET:
  CLI                         ; Disable All Interruputs
  ; Port Config
  LDI   R25,    0b11111110    ; PB0 is Input, Others are Output
  OUT   DDRB,   R25
  LDI   R25,    0b00000001    ; Output HIGH to PORTB
  OUT   PORTB,  R25
  RJMP  MAIN

; Main Loop
MAIN:
  SBIS  PINB,   0             ; If PB0 is Low,
  RJMP  RESET                 ; LED Turn Off
  LDI   R25,    0xFF          ; Else, Led Turn On
  OUT   PORTB,  R25
  RJMP  MAIN
```

<p>&nbsp;</p>
<p>2.LED点滅（タイマ1使用）</p>

```
.include "m328pdef.inc"

; Named General Purpose Register
.DEF    TMP1  = R25
.DEF    TMP2  = R24
.DEF    STACK = R23

; Interrupt Vectors
.ORG    0x0000                ; RESET
  RJMP  RESET
.ORG    0x001A                ; TIMER1 OVF
  RJMP  INT

; Interrupt Routine
INT:
  IN    STACK,  SREG          ; Backup Status Register
  LDI   TMP1,   0x00          ; Stop Timer1
  STS   TCCR1B, TMP1

  IN    TMP1,   PORTB         ; Invert the Value of PORTB
  LDI   TMP2,   0b11111110
  EOR   TMP1,   TMP2
  OUT   PORTB,  TMP1

  LDI   TMP1,   0x0000        ; Set Timer1 Counter and Restart
  STS   TCCR1A, TMP1
  LDI   TMP1,   0x05
  STS   TCCR1B, TMP1
  LDI   TMP1,   0xC2
  STS   TCNT1H, TMP1
  LDI   TMP1,   0xF7
  STS   TCNT1L, TMP1
  OUT   SREG,   STACK         ; Restore Status Register
  RETI                        ; Interrupt End

; Reset Pin and Timer
RESET:
  CLI                         ; Disable All Interruputs

  ; Port Config
  LDI   TMP1,   0b11111110    ; PB0 is Input, Others are Output
  OUT   DDRB,   TMP1
  LDI   TMP2,   0xFF          ; Output HIGH to PORTB
  OUT   PORTB,  TMP2

  ; Timer1 Config
  LDI   TMP1,   0x00          ; Nomal Mode
  STS   TCCR1A, TMP1
  LDI   TMP1,   0x05          ; Prescaler:1024
  STS   TCCR1B, TMP1
  LDI   TMP1,   0xC2          ; Interrupt Time:1sec
  STS   TCNT1H, TMP1
  LDI   TMP1,   0xF7
  STS   TCNT1L, TMP1
  LDS   TMP1,   TIMSK1        ; Enable Timer1 Overflow Interrupt
  SBR   TMP1,   (1&lt;&lt;TOIE1)
  STS   TIMSK1, TMP1
  SEI                         ; Enable All Interruputs
  RJMP  MAIN

; Main Loop
MAIN:
  RJMP  MAIN
```

<p>&nbsp;</p>
<h2>ビルド及び書き込み</h2>

```
// ビルド
$ avra FileName.asm
// ArduinoにHEXを書き込み（Arduinoの接続先が/dev/ttyACM0とする）
$ avrdude -c arduino -P /dev/ttyACM0 -p m328p -b 115200 -u -e -U flash:w:"FileName.hex":a
```

<p>これで書き込めます。</p>
<p>&nbsp;</p>
<p>実際にLED点滅プログラムを動かしてみたところです。<span class="fontsize1">（何気にFullHD）</span></p>
<iframe width="560" height="315" src="https://www.youtube.com/embed/WMPZiEUmVdc?rel=0" frameborder="0" allowfullscreen></iframe>
<p>&nbsp;</p>
<h2>Arch LinuxでArduinoが認識されない時</h2>
<p>僕の環境でもそうでしたが、一般ユーザーで/dev/ttyACM0にアクセスができませんでした。</p>
<p>しかし、次の方法で解決出来ました。</p>

```
$ sudo gpasswd -a YourUserName uucp
$ sudo stty -F /dev/ttyACM0 cs8 9600 ignbrk -brkint -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts
$ sudo chown root:wheel /run/lock
$ sudo chmod 775 /run/lock
```

<p>参考</p>
<p><a href="https://wiki.archlinux.org/index.php/Arduino">Arduino - ArchWiki</a></p>
<p><a href="http://code.synchroverge.com/?p=99">Greyed Serial Port Menu in Arduino IDE on Arch Linux | Stray Bytes</a></p>
<p>&nbsp;</p>
<p>いやぁ〜、AVR-Assemblyヤバイです。</p>
<p>わかりやすいし美しい。PICとかいうクソマイコンとは大違いです。</p>
<p>&nbsp;</p>
<p>これから書く予定のステッピングモータ制御プログラム、全部Assemblyで書こうかな・・・</p>
<p>&nbsp;</p>
<p>ではでは〜</p>
