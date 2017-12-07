---
layout: post
title: "GNU Guixをインストールしようとしたら失敗した話。"
date: 2017-12-07 00:16:40 -0800
categories: Linux Mini10
---
ひさしぶりのブログなのでリハビリをかねて短めに。

実験用にもう1台Linuxマシンが必要になったので、
Mini10というネットブックを引っ張り出してきた。
折角なので、使った事がない[GNU Guix][guix]というのを試す事にした。

GuixSD(ディストリはこう呼ばれる)はベータ版ってことで、
とりあえずインストーラはなく、手でパーティションを作る。
```guix system init```で、とりあえずインストールはできたが、
その後の```guix pull```が完了しなかった。

[GuixのML][ml]を見ると、
どうもguile2.2にアップデートした所、
パッケージ定義コンパイルにすげぇメモリを食うらしい。
何でパッケージ定義にコンパイルがいるのか理解に苦しむけど、
とりあえず、どうしようもない事はわかった。
[この問題][bug]は半年ほど解決されてないみたい。

解決策としては、メモリが沢山あるマシンでコンパイルして、
```guix copy```でコンパイル済みバイナリをコピーすることらしい。
とりあえず、[報告されてる問題][bug]によると、3Gあれば何とかなるらしいので、
4Gのマシンでコンパイルしてる。

[guix]: https://www.gnu.org/software/guix/
[ml]: http://lists.gnu.org/archive/html/guix-devel/2017-06/msg00333.html
[bug]: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=27284
