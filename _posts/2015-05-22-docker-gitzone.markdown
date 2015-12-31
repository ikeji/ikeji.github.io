---
layout: post
title: "Dockerでgitzoneをパッケージしてみる"
date: 2015-05-22 02:11:22 -0700
categories: Docker
---
とりあえず、手始めに[gitzone][gitzone]をパッケージしてみる。

[前回調べた][base]通り、debianをベースに作る事にする。

とりあえず、FROMだけ設定したDockerfileを作って、それに入って作業する。

{% highlight bash %}
docker run -it foobar /bin/sh
{% endhighlight %}
という感じで起動するととりあえず、VMが起動するから、
まず、手作業でインストールしてみて、それをDockerfileに書く。

いろいろ頑張った結果、以下のようなDockerfileになった。
{% highlight text %}
FROM debian
ADD id_rsa.pub /
ADD gitzone.conf /etc/bind/repos/gitzone.conf
ADD etc.gitzone.conf /etc/gitzone.conf
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y zsh bind9 git make openssh-server && \
    apt-get clean && \
    git clone https://github.com/dyne/gitzone.git && \
    cd gitzone && \
    make install && \
    cd / && \
    rm -rf /gitzone && \
    mkdir /var/run/sshd && \
    useradd gitzone && \
    mkdir /home/gitzone && \
    chown gitzone /home/gitzone && \
    gitzone-install gitzone id_rsa.pub
EXPOSE 53/udp
EXPOSE 53
EXPOSE 22
CMD /usr/sbin/named -u bind && /usr/sbin/sshd -D
{% endhighlight %}

このexposeしてるやつは、現実世界からアクセスする事は(標準では)できない。
そのために-Pオプションと-pオプションがある。
{% highlight bash %}
docker run -P foobar
{% endhighlight %}
という感じで起動すると、
ランダムなポートに設定される。
どこに設定されているかは、
{% highlight bash %}
docker port foobar
{% endhighlight %}
というコマンドで知れる。
ランダムなポートでは困る場合
(ex, dnsサーバー立てるのにランダムなポートでは困る)
-pオプションで設定できる。-pオプションは複数設定できる。
{% highlight bash %}
docker run -p 1234:22 -p 53:53 foobar
{% endhighlight %}

うっかり、dockerデーモンが死んだりすると、
全ての動いてるdockerコンテナが死ぬ。
この場合でも、データが消えたわけでないので、普通は再起動できそう。
起動中のdockerコンテナはdocker psで知る事ができる。
-aオプションをつけて、docker ps -aとすると、停止中の物も含めて、
コンテナが一覧表示できる。
docker stopで実行中のコンテナを停止でき、
docker restartで、停止中のコンテナを再起動できる。
docker rmでコンテナが消せるけど、停止中の物だけ。

docker rmiでイメージを消せる。rmと混同しがちなので注意。

イメージは、ブロックデバイスではないので、ファイルサイズを減らすのが大事。
Dockerfileの中で、apt-get cleanとかするのが大事。

何度もイメージを作ったり消したりしてると、
レグレッションしてないか調べられるテストツールがほしくなるな。

[gitzone]: https://github.com/dyne/gitzone
[base]: {{site.baseurl}}{% post_url 2015-05-22-docker-baseimage %}
