---
layout: post
title: "Checking negative group permissions"
date: 2016-03-16 20:25:41 -0700
categories: FreeBSD
---
いつものようにCharlie Rootさんからのお手紙を読んでいたら、
Checking negative group permissionsというリストがダーっと来た。
どうも、Groupへのパーミッションがotherより制限されていると来るみたい。

[ここらへん][1]を参考に、/etc/defaults/periodic.conf を書き変えて完了。

[1]: http://www.masashi.org/blog/2013/08/18/checking-negative-group-permissions/
