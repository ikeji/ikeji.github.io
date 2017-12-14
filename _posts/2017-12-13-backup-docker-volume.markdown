---
layout: post
title: "DockerのVolumeをうまいことバックアップしたい。"
date: 2017-12-13 22:15:32 -0800
categories: Docker
---
今、[ostatus][ostatus]サーバーでは、Dockerを使って、PostgreSQLと[Pleroma][pleroma]を動かしているわけだけど、
これをうまくバックアップ取りたい。

探したら、tarで固めるのが簡単のようだ。[専用のコンテナ][volume-backup]をみつけた。

手順としては、```docker pause mycontainer```でコンテナを一時停止して、
```docker run -v myvolume:/volume -v `pwd`:/backup --rm loomchild/volume-backup backup mybackup```
って感じでバックアップをして、
```docker resume mycontainer```で再開してる。
一旦シャットダウンした方が確実にバックアップできるだろうけど、
それだと再開までの時間が長くなりそうだから、とりあえずpauseで。

全く止めない場合、そのプログラムがファイルをmvした時に、
どちらもバックアップされない可能があるはず。

本当は、zfsみたいなスナップショットを取れるファイルシステムを使えればいいんだけど、
dockerで実現する方法がわからなかった。


[ostatus]: http://ostatus.ikeji.ma
[pleroma]: https://git.pleroma.social/pleroma/pleroma
[volume-backup]: https://github.com/loomchild/volume-backup
