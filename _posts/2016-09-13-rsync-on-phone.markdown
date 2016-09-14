---
layout: post
title: "携帯のバックアップをrsyncで取る。"
date: 2016-09-13 22:27:59 -0700
categories: Android
---
[このサイト][1]を参考にした。

{% highlight text %}
# Android用のRsyncバイナリを持ってくる。
wget -O rsync.bin http://github.com/pts/rsyncbin/raw/master/rsync.rsync4android
# 携帯に置く
adb push rsync.bin /data/local/tmp/rsync
# 実行許可をつける。
adb shell chmod 755 /data/local/tmp/rsync
# 設定ファイルを用意
adb shell 'exec >/sdcard/rsyncd.conf && echo address = 127.0.0.1 && echo port = 1873 && echo "[root]" && echo path = / && echo use chroot = false'
# 携帯にサーバーを立てる。
adb shell /data/local/tmp/rsync --daemon --no-detach --config=/sdcard/rsyncd.conf --log-file=/proc/self/fd/2
# ポートフォワードをする。
adb forward tcp:6010 tcp:1873
# rsyncでいろいろ取り出す。
rsync -av --progress --stats rsync://localhost:6010/root .
{% endhighlight %}

[1]: http://ptspts.blogspot.com/2015/03/how-to-use-rsync-over-adb-on-android.html

