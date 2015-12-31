---
layout: post
title: "dockerのベースイメージはどれがいいのか？"
date: 2015-05-22 01:47:49 -0700
categories: Docker
---
さて、dockerイメージを作りはじめたい訳だが、どのイメージを作るのがよいのだろうか？

ランダムなイメージを使うのもどうかと思うので、
公式のイメージを使うか、1から作るか、になると思う。

1から作るのもダルいので、公式のを使わせてもらおうと思うが、
どれがいいんだろうか？

やっぱり、サイズ重視がいいよね、と思い、一通りダウンロードして比べてみた。
公式のイメージのリストは[github上のディレクトリ][lib]にあるようだ。

{% highlight text %}
REPOSITORY               IMAGE ID            CREATED             VIRTUAL SIZE
centos                   fd44297e2ddb        4 weeks ago         215.7 MB
debian                   df2a0347c9d0        2 days ago          125.2 MB
fedora                   e26efd418c48        6 days ago          241.3 MB
opensuse                 17c0c561fd07        3 weeks ago         256.2 MB
oraclelinux              919c8b6d612d        4 weeks ago         199 MB
sameersbn/bind           5d69f09b392f        2 weeks ago         313.3 MB
ubuntu                   07f8e8c5e660        3 weeks ago         188.3 MB
ubuntu-debootstrap       c5c659229e15        33 hours ago        87.04 MB
ubuntu-upstart           987e962d061d        3 weeks ago         253 MB
{% endhighlight %}

ubuntu-debootstrapが一番小さい。次がdebian。

他のメトリックとしては、良く使われているというのがある。
既存のイメージで良く使われているのはどれか、という観点がある。
いくつか調べたところ、例えば、[公式のPHPイメージ][php]や[nginx][nginx]のようにdebianがおおいようだ。
直接debianを指定している物もあるし、[buildpack-deps][deps]というのを通しているのもある。
ただ、一つ注意すべき所としては、debian内でも別々のバージョンが使われている事がある。
まあ、最新版を使っておけば、そのうち同じになるだろう。

というわけで、debianにしとこ。

[lib]: https://github.com/docker-library/official-images/tree/master/library
[php]: https://github.com/docker-library/nginx
[nginx]: https://github.com/docker-library/nginx
[deps]: https://github.com/docker-library/buildpack-deps
