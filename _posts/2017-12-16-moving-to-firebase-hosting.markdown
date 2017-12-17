---
layout: post
title: "Blogとホームページをfirebaseに移転した。"
date: 2017-12-16 23:05:10 -0800
categories: Blog Web
---
[最初の記事][start]にも書いたが、元々blogをVPSとWordpressで動かしていた。
2半前にVPSが死んだ時に、github pagesに移転したが、そのまま放置したままになっていた。

この度、統合して、自前ドメインの下に置く事にした。

ついでに、いろいろホスティング先も変えようと思った。
www.ikejima.orgは静的なページなのに、何故か[heroku][heroku]でホストされており、
heroku有料化の流れで、アクセスできない時間が発生する可能性がある。

いろいろ考えた結果、[firebase][firebase]のhostingにする事にした。

決め手は:

- 元がjekyllだから移行の手間が少ない。
- CLIでアップロードできる。
- レイテンシが低い。

レイテンシは自宅のネットからだと、

- Heroku 80ms
- github pages 60ms
- firebase hosting 15ms

だった。

アップロードはjekyllを実行した上で、
```firebase deploy```で一発だった。

しばらくはこれで運用する予定。

[start]: {{site.baseurl}}{% post_url 2015-05-18-start %}
[heroku]: https://www.heroku.com/home
[firebase]: https://firebase.google.com/docs/hosting/?hl=ja
