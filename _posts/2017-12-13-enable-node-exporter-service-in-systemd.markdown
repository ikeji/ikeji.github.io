---
layout: post
title: "Node-exporterサービスをマシン起動時に起動する。"
date: 2017-12-13 23:43:21 -0800
categories: Linux Debian Ansible
---
自分の持ってるサーバー群の監視には、[Prometheus][prometheus]を使っているが、
このサーバー群の監視には、各サーバーで[node-exporter][ne]を動作させる必要がある。

Debianベースのマシンでは、既にパッケージが入っているが、
何故かインストールしただけでは、マシン起動時に起動するようにならない。

```sudo systemctl enable prometheus-node-exporter.service``` というコマンドで自動起動を有効にできる。

もしくは、[Ansible][ansible]を使ってセットアップしているなら、
{% highlight yaml %}
      - name: node-exporter-install
        apt:
          name: prometheus-node-exporter
          update_cache: yes
      - name: node-exporter-start
        service:
          name: prometheus-node-exporter
          state: started
          enabled: yes
{% endhighlight %}
こういう感じで設定すればいけるようだ。

[prometheus]: https://prometheus.io/
[ne]: https://github.com/prometheus/node_exporter
[ansible]: https://www.ansible.com/
