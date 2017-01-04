---
layout: post
title: "MacVimで色がおかしい。"
date: 2017-01-04 00:56:34 -0800
categories: Vim MacOSX
---
ひさびさにMacを使おうとしたら色々はまったのでメモその1

とりあえず、いつもの.vimrcを持ち込んで、
[MacVim][mvim]を使おうとしたら色がおかしい。

いろいろ調べた結果、
MacVimに付属のgvimrcが悪い事がわかった。

gvimrcは、vimrcよりも後で読まれるため、
vimrcでの色設定を上書きできる。

まず、MacVim付属のgvimrcは、独自のmacvimと名付けられたカラースキームを勝手に読む。
これはg:macvim_skip_colorschemeに1を入れておけば回避できるようだ。

gvimrc_example.vimという設定ファイルを追加で読む。
この挙動は、g:no_gvimrc_exampleという変数に0以外を入れておけば、回避できるらしい。

最終的に.vimrcに次の行を追加した。


{% highlight vim %}
if has('gui_macvim')
  let g:macvim_skip_colorscheme=1
  let g:no_gvimrc_example=1
endif
{% endhighlight %}

[mvim]: https://github.com/splhack/macvim-kaoriya
