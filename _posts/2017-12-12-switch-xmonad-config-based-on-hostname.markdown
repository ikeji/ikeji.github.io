---
layout: post
title: "xmonadの設定をホストごとに切り替える。"
date: 2017-12-12 01:56:27 -0800
categories: Linux xmonad
---
年末なので、設定ファイルの大掃除をしていた。

ここ数年、ウインドウマネージャには、[xmonad][xmonad]を使っているが、
ウィンドウマネージャの設定は使っているキーボード/ディスプレィによって変わる。
各マシンごとに設定ファイルを別にしていたが、これを何とか統一の設定ファイルがあちこちで動くようになってほしい。

まず、ホストネームを取得する。
これは標準ライブラリに関数があり、
{% highlight haskell %}
import System.Posix.Unistd (nodeName, getSystemID)

  host  <- fmap nodeName getSystemID
  let shortHost = takeWhile (/= '.') host
{% endhighlight %}
という感じで取得できた。

文字列定数を切り替えたい場合、
{% highlight haskell %}
myTerminal :: String -> String
myTerminal "foo" = "xterm"
myTerminal "bar" = "mrxvt"
{% endhighlight %}
という感じで分岐できる。

困ったのが、レイアウトを分岐するところ。
{% highlight haskell %}
myLayout "foo" = ThreeCol  1 (3/100) (1/3)
myLayout "foo" = Tall 1 (3/100) (1/2)
{% endhighlight %}
という風に定義すると、myLayout関数の返り値の型が定義によって違うためエラーになる。

仕方ないので、
{% highlight haskell %}
xmonadWithLayout :: String -> XConfig l -> IO ()
xmonadWithLayout "foo" conf = xmonad $ conf { layoutHook = ThreeCol  1 (3/100) (1/3) }
xmonadWithLayout "bar" conf = xmonad $ conf { layoutHook = Tall 1 (3/100) (1/2) }
{% endhighlight %}
という風に定義して使ってる。

もっといい方法がありそうだけど…とりあえずこれで今年は年をこせそうかな。

[xmonad]: http://xmonad.org/
