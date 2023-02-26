---
title: Boost.Asio の posix::stream_descriptor を使う
date: 2018-10-14 22:59:00+0900
tags:
  - Linux
  - C++
---

C++熱は冷めてしまったのですが、いつか書こうと思っていたことを書かないのもアレだなぁということで、久しぶりの C++ ネタです。

[Boost.Asio](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio.html) は、個人的に好きな C++ ライブラリの1つです。以前にもこのブログで、HTTP クライアント (Twitter API というか OAuth を叩くライブラリ) やシリアル通信をする例を紹介しました。

今回紹介するのは [`posix::stream_descriptor`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/posix__stream_descriptor.html) です。名前からなんとなく想像できるように、ファイルディスクリプタを渡してストリーム形式のデータをやり取りするためのものです。これを使って、`open(2)` したデバイスを Boost.Asio の API で操作してみたいと思います。

<!--more-->

## 環境

- Arch Linux (x86_64)
    - boost: 1.68.0
    - clang: 7.0.0-1
    - glibc: 2.28-4
    - linux-api-headers: 4.17.11-1
    - linux: 4.18.12.arch1-1
- Logicool Gamepad F310

## とりあえず使ってみる

身近なファイルディスクリプタといわれてまず挙がるのが標準入出力 (`STDIN_FILENO`, `STDOUT_FILENO`) でしょう。[`posix::stream_descriptor`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/posix__stream_descriptor.html) でこれらのファイルディスクリプタを操作して、入力されたものをそのまま出力する、引数なしで実行した [`cat(1)`](https://linux.die.net/man/1/cat) コマンドのような動作をするプログラムを書いてみるとこんな感じです。

```cpp
#include <iostream>
#include <boost/asio.hpp>

extern "C" {
#include <unistd.h>
}

auto main() -> int {
  boost::asio::io_context ctx{};

  boost::asio::posix::stream_descriptor stream_in{ctx, ::dup(STDIN_FILENO)};
  boost::asio::posix::stream_descriptor stream_out{ctx, ::dup(STDOUT_FILENO)};

  boost::asio::streambuf buffer{};
  boost::system::error_code error{};

  while (boost::asio::read(stream_in, buffer, boost::asio::transfer_at_least(1), error)) {
    boost::asio::write(stream_out, buffer);
  }

  if (error != boost::asio::error::eof) {
    std::cerr << error.message() << std::endl;
    return 1;
  }
}
```

`posix::stream_descriptor` は、コンストラクタに [`io_context`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/io_context.html) と操作したいファイルディスクリプタを渡してやるだけで準備完了です。あとはいつものように、[`read`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/read.html) や [`write`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/write.html)、`async_xxx` などの操作ができるようになります。簡単ですね。

<p style="text-align: center;"><object data="mycat.svg" style="max-width: 100%"></object></p>

## Linux の Joystick API

もう少し複雑な `posix::stream_descriptor` の使用例として、Linux の Joystick API を使ったものを紹介しようと思います。なぜ Joystick なのかというと、[ドキュメント](https://www.kernel.org/doc/html/v4.18/input/joydev/joystick-api.html)にあるようにとても単純で、なにか対象をそれっぽく動かしたいときにシュッと使えていいなーと思っているからです[^1]。

[^1]: ただ、この API はいつの間にか legacy 扱いされており、これからは evdev を使うようにとありますね...

Linux マシンに Joystick を接続すると、`/dev/input/jsX` が出現します。これを [`open(2)`](https://linux.die.net/man/2/open) して [`read(2)`](https://linux.die.net/man/2/read) すると、Joystick の状態の変化を `struct js_event` の形式で取得することができます。

```c
struct js_event {
        __u32 time;     /* event timestamp in milliseconds */
        __s16 value;    /* value */
        __u8 type;      /* event type */
        __u8 number;    /* axis/button number */
};
```

[`js_event.type`](https://www.kernel.org/doc/html/v4.18/input/joydev/joystick-api.html#js-event-type) はイベントの種類を表すもので、ボタンが押された/離されたを示す `JS_EVENT_BUTTON`、スティックが動かされたかを示す `JS_EVENT_AXIS` があります。また、`open(2)` して最初に `read(2)` したときに Joystick が持つ全てのボタンやスティックの初期値が送られてくるのですが、その時の値は `JS_EVENT_INIT` との or をとった値になっています。

```c
#define JS_EVENT_BUTTON         0x01    /* button pressed/released */
#define JS_EVENT_AXIS           0x02    /* joystick moved */
#define JS_EVENT_INIT           0x80    /* initial state of device */
```

[`js_event.number`](https://www.kernel.org/doc/html/v4.18/input/joydev/joystick-api.html#js-event-number) はボタンやスティックのインデックス、[`js_event.value`](https://www.kernel.org/doc/html/v4.18/input/joydev/joystick-api.html#js-event-value) は変化後の値です。

接続された Joystick に関する情報は [`ioctl(2)`](https://linux.die.net/man/2/ioctl) で取得できます。取得できる情報には以下のようなものがあり、

```c
                        /* function                     3rd arg  */
#define JSIOCGAXES      /* get number of axes           char     */
#define JSIOCGBUTTONS   /* get number of buttons        char     */
#define JSIOCGVERSION   /* get driver version           int      */
#define JSIOCGNAME(len) /* get identifier string        char     */
#define JSIOCSCORR      /* set correction values        &js_corr */
#define JSIOCGCORR      /* get correction values        &js_corr */
```

例えばスティックの数は次のようなコードで取得できます。

```c
char number_of_axes;
ioctl(fd, JSIOCGAXES, &number_of_axes);
```

## 任意のタイミングで Joystick の状態を取得したい

Linux の Joystick API は状態が変化したときにイベントが送られてくるというものなので、任意のタイミングで Joystick の状態を取得したいときにはイベントを監視して内部状態を更新するようなプログラムを実装する必要があります。

例えば 1/60 [s] 毎に Joystick の状態をコンソールに出力するプログラムを実装したいとします[^2]。[`jstest(1)` コマンド](https://linux.die.net/man/1/jstest)のようなイメージです。

[^2]: 状態の逐次表示はイベントを取得した時に表示を更新するだけで実現できるのでこんなことをする必要はないですが、あくまで例なので...

雑な実装としては nonblocking mode (`open` の第2引数に `O_NONBLOCK` を指定する) やスレッドを用いる方法、もう少し複雑な例としては [`select(2)`](https://linux.die.net/man/2/select) を使う方法でしょうか。タイマーに [`timerfd_create(2)`](https://linux.die.net/man/2/timerfd_create) を使い、ファイルディスクリプタの監視に `select(2)` を使って C で実装してみたのがこんな感じです。

```c
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include <fcntl.h>
#include <linux/joystick.h>
#include <sys/ioctl.h>
#include <sys/select.h>
#include <sys/time.h>
#include <sys/timerfd.h>
#include <sys/types.h>
#include <unistd.h>

struct joystick_state {
  uint8_t num_axes;
  uint8_t num_buttons;
  int16_t* axes;
  int16_t* buttons;
};

static void perror_exit(const char* msg) {
  perror(msg);
  exit(EXIT_FAILURE);
}

static void update_joystick_state(struct joystick_state* state, struct js_event* jse) {
  switch (jse->type & ~JS_EVENT_INIT) {
    case JS_EVENT_AXIS:
      if (jse->number < state->num_axes) {
        state->axes[jse->number] = jse->value;
      }
      break;
    case JS_EVENT_BUTTON:
      if (jse->number < state->num_buttons) {
        state->buttons[jse->number] = jse->value;
      }
      break;
  }
}

static void print_joystick_state(struct joystick_state* state) {
  printf("\r");
  printf("axes: ");
  for (uint16_t i = 0; i < (uint16_t)state->num_axes; ++i) {
    printf("%6" PRId16 " ", state->axes[i]);
  }
  printf("buttons: ");
  for (uint16_t i = 0; i < (uint16_t)state->num_buttons; ++i) {
    printf("%" PRId16 " ", state->buttons[i]);
  }
  fflush(stdout);
}

int main(int argc, char** argv) {
  if (argc != 2) {
    fprintf(stderr, "usage: %s <device>\n", argv[0]);
    exit(1);
  }

  int joy_fd = open(argv[1], O_RDONLY);
  if (joy_fd < 0) {
    perror_exit(argv[1]);
  }

  struct joystick_state state;
  {
    ioctl(joy_fd, JSIOCGAXES, &state.num_axes);
    ioctl(joy_fd, JSIOCGBUTTONS, &state.num_buttons);
    state.axes    = (int16_t*)calloc(state.num_axes, sizeof(int16_t));
    state.buttons = (int16_t*)calloc(state.num_buttons, sizeof(int16_t));
  }

  int timer_fd = timerfd_create(CLOCK_REALTIME, 0);
  if (timer_fd < 0) {
    perror_exit("timerfd_create");
  }

  struct itimerspec nexttime;
  {
    struct timespec now;
    if (clock_gettime(CLOCK_REALTIME, &now) != 0) {
      perror_exit("clock_gettime");
    }
    // 1/60 [sec] = 16,666,666 [ns]
    nexttime.it_interval.tv_sec  = 0;
    nexttime.it_interval.tv_nsec = 16666666;
    nexttime.it_value.tv_sec     = nexttime.it_interval.tv_sec + now.tv_sec;
    nexttime.it_value.tv_nsec    = nexttime.it_interval.tv_nsec + now.tv_nsec;
  }

  if (timerfd_settime(timer_fd, TFD_TIMER_ABSTIME, &nexttime, NULL) != 0) {
    perror_exit("timerfd_settime");
  }

  print_joystick_state(&state);

  while (1) {
    fd_set rfds;
    FD_ZERO(&rfds);
    FD_SET(joy_fd, &rfds);
    FD_SET(timer_fd, &rfds);

    int maxfd = joy_fd > timer_fd ? joy_fd : timer_fd;

    int ret = select(maxfd + 1, &rfds, NULL, NULL, NULL);
    if (ret > 0) {
      if (FD_ISSET(joy_fd, &rfds)) {
        struct js_event jse;
        ssize_t s = read(joy_fd, &jse, sizeof jse);
        if (s != sizeof jse) {
          perror_exit("read(joy_fd)");
        }

        update_joystick_state(&state, &jse);
      }

      if (FD_ISSET(timer_fd, &rfds)) {
        uint64_t t;
        ssize_t s = read(timer_fd, &t, sizeof t);
        if (s != sizeof t) {
          perror_exit("read(timer_fd)");
        }

        print_joystick_state(&state);
      }
    } else {
      perror_exit("select");
    }
  }
}
```

<p style="text-align: center;"><object data="joy_c.svg" style="max-width: 100%"></object></p>

## `posix::stream_descriptor` で Joystick API

先程の例ではタイマーや非同期 IO などが登場していました。そう、Boost.Asio の得意分野です。ということで、同様のプログラムを Boost.Asio で実装してみましょう。

`include` するヘッダは以下の通り。今回は [stackful coroutine](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/overview/core/spawn.html) を使いたいので、`<boost/asio/spawn.hpp>` も `include` します。Boost.Asio の coroutine には boost 1.62.0 で deplicated になった Boost.Coroutine が使われていて警告メッセージが出るので、静かにしてもらうために `BOOST_COROUTINES_NO_DEPRECATION_WARNING` を `define` しています。C のヘッダは `extern "C"` で囲んでやりましょう。

```cpp
#include <chrono>
#include <cinttypes>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <vector>

#define BOOST_COROUTINES_NO_DEPRECATION_WARNING
#include <boost/asio.hpp>
#include <boost/asio/spawn.hpp>

extern "C" {
#include <fcntl.h>
#include <linux/joystick.h>
#include <sys/ioctl.h>
#include <unistd.h>
}
```

Joystick と `posix::stream_descriptor` の初期化周りのコードがこんな感じ。最初に示したコードでは、`posix::stream_descriptor` のコンストラクタにファイルディスクリプタを渡していましたが、`io_context` のみを渡して初期化した後、メンバ関数 [`posix::stream_descriptor::assign`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/posix__stream_descriptor/assign.html) でファイルディスクリプタを割り当てることもできます。

```cpp
struct joystick_state {
  std::uint8_t num_axes;
  std::uint8_t num_buttons;
  std::vector<std::int16_t> axes;
  std::vector<std::int16_t> buttons;
};

// ...

boost::asio::io_context ctx{};

boost::asio::posix::stream_descriptor joystick{ctx};
joystick_state state{};
{
  const int fd = ::open(argv[1], O_RDONLY);
  if (fd < 0) {
    std::cerr << argv[1] << ": " << std::strerror(errno) << std::endl;
    std::exit(1);
  }

  ::ioctl(fd, JSIOCGAXES, &state.num_axes);
  state.axes.resize(state.num_axes);

  ::ioctl(fd, JSIOCGBUTTONS, &state.num_buttons);
  state.buttons.resize(state.num_buttons);

  joystick.assign(fd);
}
```

上に書いたように、今回は stackful coroutine を使って非同期処理を書いていきます。[`spawn`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/spawn.html) を使って、一定時間毎 (1/60 [s]) に状態を表示するものと、Joystick のイベント監視 & 内部状態更新をするものの2つの coroutine を起動します。`spawn` の第1引数には `io_context` を直接渡すこともできますが、[`io_context::strand`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/io_context__strand.html) を渡しています。今回のように `io_context` をシングルスレッドで利用している場合はあまり意味がありませんが、`io_context::strand` は登録されたハンドラを直列に (同時に実行されることなく) 実行するためのものです。

```cpp
boost::asio::io_context::strand strand{ctx};

boost::asio::steady_timer timer{ctx};
boost::asio::spawn(strand, [&state, &timer](auto&& yield) {
  // 一定時間毎 (1/60 [s]) に状態を表示する
});

boost::asio::spawn(strand, [&joystick, &state](auto&& yield) {
  // Joystick のイベント監視 & 内部状態更新をする
});

ctx.run();
```

一定時間毎 (1/60 [s]) に状態を表示する処理をしている coroutine の実装がこんな感じです。タイマーには [`steady_timer`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/steady_timer.html) を用いました。`timer` にあらかじめ次の発火時刻をセットしてから状態を表示し、その後次の発火まで待つ、を繰り返しているイメージです。

```cpp
using namespace std::chrono_literals;

// ...

boost::asio::steady_timer timer{ctx};
boost::asio::spawn(strand, [&state, &timer](auto&& yield) {
  for (;;) {
    timer.expires_after(16'666'666ns);

    std::printf("\r");
    std::printf("axes: ");
    for (auto&& v : state.axes) {
      std::printf("%6" PRId16 " ", v);
    }
    std::printf("buttons: ");
    for (auto&& v : state.buttons) {
      std::printf("%" PRId16 " ", v);
    }
    std::fflush(stdout);

    timer.async_wait(yield);
  }
});
```

続いて Joystick のイベント監視 & 内部状態更新をするほうの coroutine の実装がこんな感じです。`joystick` からの読み込みを [`async_read`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/async_read/overload1.html) で行います。今回は読み込む量が決まっているので、[`streambuf`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/streambuf.html) は使わず、[`buffer`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/buffer/overload5.html) を使って `js_event` に直接読み込みます。`async_read` で読み込む量の指定は第3引数に [`CompletionCondition`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/async_read.html) を取る overload に [`transfer_exactly`](https://www.boost.org/doc/libs/1_68_0/doc/html/boost_asio/reference/transfer_exactly.html) を渡すなどでも可能ですが、以下の実装で `async_read` の処理が完了する条件はドキュメントにあるとおり与えたバッファが一杯になる、またはエラーが発生したときとあるので、これで問題ないでしょう。

```cpp
boost::asio::spawn(strand, [&joystick, &state](auto&& yield) {
  for (;;) {
    ::js_event jse{};
    boost::system::error_code error{};

    boost::asio::async_read(joystick, boost::asio::buffer(&jse, sizeof jse), yield[error]);

    if (error == boost::asio::error::eof) {
      joystick.get_io_service().stop();
      break;
    } else if (error) {
      std::cerr << "\nerror: " << error.message() << std::endl;
      std::exit(1);
    }

    switch (jse.type & ~JS_EVENT_INIT) {
      case JS_EVENT_AXIS:
        if (jse.number < state.num_axes) {
          state.axes.at(jse.number) = jse.value;
        }
        break;
      case JS_EVENT_BUTTON:
        if (jse.number < state.num_buttons) {
          state.buttons.at(jse.number) = jse.value;
        }
        break;
    }
  }
});
```

これで必要な実装は完了です。ソースコード全体がこんな感じになります。

```cpp
#include <chrono>
#include <cinttypes>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <vector>

#define BOOST_COROUTINES_NO_DEPRECATION_WARNING
#include <boost/asio.hpp>
#include <boost/asio/spawn.hpp>

extern "C" {
#include <fcntl.h>
#include <linux/joystick.h>
#include <sys/ioctl.h>
#include <unistd.h>
}

using namespace std::chrono_literals;

struct joystick_state {
  std::uint8_t num_axes;
  std::uint8_t num_buttons;
  std::vector<std::int16_t> axes;
  std::vector<std::int16_t> buttons;
};

auto main(int argc, char** argv) -> int {
  if (argc != 2) {
    std::cerr << "usage: " << argv[0] << " <device>" << std::endl;
    std::exit(1);
  }

  boost::asio::io_context ctx{};
  boost::asio::io_context::strand strand{ctx};

  boost::asio::posix::stream_descriptor joystick{ctx};
  joystick_state state{};
  {
    const int fd = ::open(argv[1], O_RDONLY);
    if (fd < 0) {
      std::cerr << argv[1] << ": " << std::strerror(errno) << std::endl;
      std::exit(1);
    }

    ::ioctl(fd, JSIOCGAXES, &state.num_axes);
    state.axes.resize(state.num_axes);

    ::ioctl(fd, JSIOCGBUTTONS, &state.num_buttons);
    state.buttons.resize(state.num_buttons);

    joystick.assign(fd);
  }

  boost::asio::steady_timer timer{ctx};
  boost::asio::spawn(strand, [&state, &timer](auto&& yield) {
    for (;;) {
      timer.expires_after(16'666'666ns);

      std::printf("\r");
      std::printf("axes: ");
      for (auto&& v : state.axes) {
        std::printf("%6" PRId16 " ", v);
      }
      std::printf("buttons: ");
      for (auto&& v : state.buttons) {
        std::printf("%" PRId16 " ", v);
      }
      std::fflush(stdout);

      timer.async_wait(yield);
    }
  });

  boost::asio::spawn(strand, [&joystick, &state](auto&& yield) {
    for (;;) {
      ::js_event jse{};
      boost::system::error_code error{};

      boost::asio::async_read(joystick, boost::asio::buffer(&jse, sizeof jse), yield[error]);

      if (error == boost::asio::error::eof) {
        joystick.get_io_service().stop();
        break;
      } else if (error) {
        std::cerr << "\nerror: " << error.message() << std::endl;
        std::exit(1);
      }

      switch (jse.type & ~JS_EVENT_INIT) {
        case JS_EVENT_AXIS:
          if (jse.number < state.num_axes) {
            state.axes.at(jse.number) = jse.value;
          }
          break;
        case JS_EVENT_BUTTON:
          if (jse.number < state.num_buttons) {
            state.buttons.at(jse.number) = jse.value;
          }
          break;
      }
    }
  });

  ctx.run();
}
```

実行してみるとこんな感じ。`boost_coroutine` や `boost_system`、`pthread` ライブラリをリンクする必要があります。

<p style="text-align: center;"><object data="joy.svg" style="max-width: 100%"></object></p>

## まとめ

Boost.Asio の `posix::stream_descriptor` を使って、Linux マシンに接続したデバイスを非同期に扱う方法を紹介しました。小規模なプログラムではわざわざ C++ で Boost.Asio を使って書く必要は無いかもしれませんが、扱うデバイスが増えたり、ネットワークやシリアル通信など Boost.Asio で扱える他の要素と組み合わせるような場合には、かなり便利なんじゃないかなぁと思います。
