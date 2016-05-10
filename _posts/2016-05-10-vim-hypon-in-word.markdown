---
layout: post
title: "vimでハイフンを単語の境界にしない。"
date: 2016-05-10 01:27:58 -0700
categories: Vim
---
Lisp系言語とかCSSを書いている場合、
関数名やマクロ名やクラス名にハイフン"-"を含む事がある。

デフォルトだとVimは-を単語の分割にしてしまい、
移動や補完に支障がでる。
なぜ、schemeモードで-を単語の境界とみなすのかは理解に苦しむ所だ。

[調べた所][2]、Vimの[iskeyword][1]に文字を足すと、その文字は単語の境界とは見なさなくなるようだ。

```
set isk+=-
```

でいけた。

[2]: http://qiita.com/Kta-M/items/9a386c01db150dc90fc2
[1]: http://vim-jp.org/vimdoc-ja/options.html#'iskeyword'
