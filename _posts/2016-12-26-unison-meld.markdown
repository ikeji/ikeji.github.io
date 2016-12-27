---
layout: post
title: "unisonでマージにmeldを使う"
date: 2016-12-26 20:50:40 -0800
categories: Unix
---
unisonでファイル更新が衝突した時にマージが面倒。
GUIがある端末だと、meldが使えた。
{% highlight bash %}
unison /dir/a /dir/b -merge 'Regex .* -> meld CURRENT1 CURRENT2 && cp CURRENT1 NEW1 && cp CURRENT2 NEW2'
{% endhighlight %}
って感じで実行した。
