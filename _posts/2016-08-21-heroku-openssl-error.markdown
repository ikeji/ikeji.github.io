---
layout: post
title: "Herokuでデプロイ時にopenssl error"
date: 2016-08-21 22:43:28 -0700
categories: Heroku
---
今日の羊刈り。

自分の[ホームページ][1]をアップデートしようと思った。
2行の追加。

こいつはherokuで動いてるはずだから、単にindex.mdをいじって、
git pushするだけのはず。

ところが、ビルド中にRubyがOpenSSL対応していないというエラーで死ぬ。

    remote: Compressing source files... done.
    remote: Building source:
    remote: 
    remote: -----> Ruby app detected
    remote: -----> Compiling Ruby/Rack
    remote: -----> Using Ruby version: ruby-2.1.2
    remote: -----> Installing dependencies using Bundler version 1.3.2
    remote:        Running: bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin --deployment
    remote:        Could not load OpenSSL.
    remote:        You must recompile Ruby with OpenSSL support or change the sources in your
    remote:        Gemfile from 'https' to 'http'. Instructions for compiling with OpenSSL
    remote:        using RVM are available at rvm.io/packages/openssl.
    remote:        Bundler Output:
    remote:        Could not load OpenSSL.
    remote:        You must recompile Ruby with OpenSSL support or change the sources in your
    remote:        Gemfile from 'https' to 'http'. Instructions for compiling with OpenSSL
    remote:        using RVM are available at rvm.io/packages/openssl.
    remote:  !
    remote:  !     Failed to install gems via Bundler.
    remote:  !
    remote:  !     Push rejected, failed to compile Ruby app.
    remote: 
    remote:  !     Push failed
    remote: Verifying deploy....
    remote: 
    remote: !	Push rejected to ikejihome.
    remote: 


よくわからないが、Rubyのバージョンが古いから、このせいかもしれない。
.ruby-versionと、Gemfile内にあるRubyのバージョンを手元にあった、
2.2.3にして、Gemfile.lockを作りなおしてpush.

今度はインタプリタが入手できなかったらしい。

    remote: Compressing source files... done.
    remote: Building source:
    remote: 
    remote: -----> Ruby app detected
    remote: -----> Compiling Ruby/Rack
    remote:  !
    remote:  !     Command: 'set -o pipefail; curl --fail --retry 3 --retry-delay 1 --connect-timeout 3 --max-time 20 https://s3-external-1.amazonaws.com/heroku-buildpack-ruby/ruby-2.2.3.tgz -s -o - | tar zxf -' failed unexpectedly:
    remote:  !     
    remote:  !     gzip: stdin: unexpected end of file
    remote:  !     tar: Child returned status 1
    remote:  !     tar: Error is not recoverable: exiting now
    remote:  !
    remote:  !     Push rejected, failed to compile Ruby app.
    remote: 
    remote:  !     Push failed
    remote: Verifying deploy...
    remote: 
    remote: !	Push rejected to ikejihome.
    remote: 

サポートしているRubyのバージョンはどれだ。
[サポートページ][2]によると、Ruby 2.3.1が最新のようだ。

`rbenv install 2.3.1` をしたいがバージョン一覧にでてこない。
無理矢理実行したら、ruby-buildのバージョンが古いからだと指摘された。
ruby-buildの最新バージョンをgitから取ってきて、
それを使って2.3.1を入れた。やれやれ。

herokuプロジェクト側のバージョンをいじって、Gemfile.lockを作ってpush.
同じエラー。

Heroku側の問題に違いない、検索したり、Herokuのコンソールにログインすると、
buildpackのURLってのが指定されてた。

なるほど、このbuildpackが古いのか。
というか、buildpackもコード内で指定しておくようにしろよ。

jekyllのbuildpackの[オリジナル][4]は、何年もメンテされていなくて、
[誰かのフォーク][3]を使っていたが、それも古くなってしまったようだ。
オリジナルにプルリクを投げてる人を見つけたので、
[その人のフォーク][5]を使う事にした。

再度push。
またエラー

    remote: Compressing source files... done.
    remote: Building source:
    remote: 
    remote: -----> Ruby app detected
    remote: -----> Compiling Ruby/Rack
    remote: -----> Using Ruby version: ruby-2.3.1
    remote: -----> Installing dependencies using bundler 1.9.7
    remote:        Purging Cache. Changing stack from cedar to cedar-14
    remote:        Running: bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin -j4 --deployment
    remote:        Fetching gem metadata from http://rubygems.org/..........
    remote:        Fetching version metadata from http://rubygems.org/...
    remote:        Fetching dependency metadata from http://rubygems.org/..
    remote:        Installing colorator 1.1.0
    remote:        Installing daemons 1.2.4
    remote:        Installing RedCloth 4.3.2
    remote:        Installing forwardable-extended 2.6.0
    remote:        Installing sass 3.4.22
    remote:        Installing rb-fsevent 0.9.7
    remote:        Installing kramdown 1.12.0
    remote:        Installing liquid 3.0.6
    remote:        Installing mercenary 0.3.6
    remote:        Installing rouge 1.11.1
    remote:        Installing safe_yaml 1.0.4
    remote:        Installing rack 1.6.4
    remote:        Installing tilt 2.0.5
    remote:        Using bundler 1.9.7
    remote:        Installing pathutil 0.14.0
    remote:        Installing jekyll-sass-converter 1.4.0
    remote:        Installing rack-protection 1.5.3
    remote:        Installing sinatra 1.4.7
    remote:        Installing ffi 1.9.14
    remote:        Installing rb-inotify 0.9.7
    remote:        Installing listen 3.0.8
    remote:        Installing eventmachine 1.2.0.1
    remote:        Installing jekyll-watch 1.5.0
    remote:        Installing jekyll 3.2.1
    remote:        Installing thin 1.7.0
    remote:        Bundle complete! 4 Gemfile dependencies, 25 gems now installed.
    remote:        Gems in the groups development and test were not installed.
    remote:        Bundled gems are installed into ./vendor/bundle.
    remote:        Bundle completed (32.34s)
    remote:        Cleaning up the bundler cache.
    remote:        Building jekyll site
    remote:        Configuration file: /tmp/build_320afce2a916d4af1801bfe0efd03b95/_config.yml
    remote:        Source: /tmp/build_320afce2a916d4af1801bfe0efd03b95
    remote:        Destination: /tmp/build_320afce2a916d4af1801bfe0efd03b95/_site
    remote:        Incremental build: disabled. Enable with --incremental
    remote:        Generating...
    remote:        jekyll 3.2.1 | Error:  No such file or directory @ utime_internal - /tmp/build_320afce2a916d4af1801bfe0efd03b95/_site/bin/erb
    remote:  !
    remote:  !     Failed to generate site with jekyll.
    remote:  !
    remote:  !     Push rejected, failed to compile Ruby app.
    remote: 
    remote:  !     Push failed
    remote: Verifying deploy...
    remote: 
    remote: !	Push rejected to ikejihome.
    remote: 

やれやれ。

検索してみると、[同じエラーの人][6]と[issue][7]が見つかった。
issueの方で古い版のjekyllに戻してる人がいたので、習って、
Gemfileで古い版のjekyllを設定しておいた。

    gem 'jekyll', '~> 3.1.6'

やれやれ。

[1]: http://ikejima.org
[2]: https://devcenter.heroku.com/articles/ruby-support#supported-runtimes
[4]: https://github.com/mattmanning/heroku-buildpack-ruby-jekyll
[3]: https://github.com/jeremyvdw/heroku-buildpack-ruby-jekyll
[5]: https://github.com/burkemw3/heroku-buildpack-ruby-jekyll
[6]: https://www.hsbt.org/diary/20160805.html
[7]: https://github.com/jekyll/jekyll/issues/5144
