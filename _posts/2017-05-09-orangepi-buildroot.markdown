---
layout: post
title: "OrangePi ZeroでBuildrootを使う"
date: 2017-05-09 00:46:56 -0700
categories: Linux RaspberryPi
---
Aliexpressで[OrangePi Zero][1]というものを買った。
値段は送料込みで10ドルぐらい。

名前の通り、RaspberryPi ZeroやZeroWの競合にあたると思われる製品で、
RaspberryPi ZeroWと比べると、HDMIとカメラコネクが無いかわりに、
RJ45の有線LANがついてる。

PCとして利用するのを目的としたオリジナルのRaspberryPiと違い、
このフォームファクタの物は、他の機器の中に組み込んでアレコレすると思うので、
HDMIは余計だと思うので、この選択は正しいと思う。

値段的に半額な上に、
ほとんど入手不可能(2017年05月時点)なRaspberryPi Zeroと違い、
潤沢に在庫があるのが良い。

これを何に使おうかと買ってから考えた結果、
Webラジオクライアントにしてみる事にした。

電源を入れると、適当なWebラジオに接続しに行き、勝手に再生がはじまるというもの。

これを実現するなら、なるべく起動が早い方がいいだろう、という事で、
[Buildroot][2]を使って環境を構築する事にした。

1つ先に注意しておくと、OrangePiZeroの内蔵サウンドデバイスを動かす事には成功していない。
Linuxカーネルソースの[変更履歴][3]を見ると、
OrangePiZeroのSOCであるH2+のサウンドデバイスは絶賛開発中のようだ。


[1]: http://www.orangepi.org/orangepizero/
[2]: https://buildroot.org/
[3]: https://github.com/torvalds/linux/commits/master/sound/soc/sunxi


# Buildrootの準備

buildroot自体でもOrangePiファミリーはサポートしてるんだけど、
OrangePi Zero自体はまだ入ってないみたい。

Wifiが使いたいのだが、最新リリースでは使えない。

探した所、[Buildrootへのパッチ][4]を発見した。
見た所、OrangePi ZeroのWifiと有線LANポートのドライバを入れてくれるパッチらしい、
これを使う事にした。

[4]: https://groups.google.com/forum/#!msg/alt.sources/thi51Py7-6g/7rC2nI2oAgAJ


# OrangePi Zeroの準備

RaspberryPi Zeroと違って、画面がないので、シリアルデバッグをする事になる。

[シリアルピン][5]が準備されていて、
buildrootでビルドしたイメージは、
デフォルトでここにデバッグメッセージを出したりログインできるようになっている。

[5]: http://linux-sunxi.org/Xunlong_Orange_Pi_Zero#Locating_the_UART

# SDカードへの書き込み

ビルドしたbuildrootは、output/images/sdcard.imgにイメージを吐くので、
これをddでSDカードに書き込む。

今の自分の環境では28MB程度のイメージになっている。

なぜか、cpioイメージとext4のイメージの両方が入っているので、
本当はもう17MBぐらい減る気がする。

# Buildrootのカスタマイズ
Webラジオに必要な変更を加える。

## Wifi
ドライバはあっても、設定しないと繋らない。

まず、modprobeしてドライバを読んでやる必要がある。
overlayディレクトリが(パッチによって)../overlayに指定されているので、
こに、overlay/etc/init.d/S10modprobeという名前で、

{% highlight bash %}
#!/bin/sh

modprobe xradio_wlan
{% endhighlight %}

というファイルを置いた。

これでドライバが読めた。

WPA経由の無線LANで接続するためには、wpa_supplicantがいる。
この設定がいろいろいる。

まず、これをコンパイルしないとはじまらない、
buildrootのmake menuconfigから、wpa_supplicantをインストール設定をする。

次に、Wifi接続のパスフレーズをファイルに書いておく、これはwpa_passphraseコマンドで生成できる。
これをoverlay/etc/wpa_supplicant.confというファイル名で置いた。

最後に/etc/network/interfacesの設定が必要だ。
これは、overlayではなくパッケージのコンパイルによって生成されるので、
board/orangepi/post-build.sh経由で生成する。
次の行を足した。

{% highlight bash %}
echo >> ${TARGET_DIR}/etc/network/interfaces
echo >> ${TARGET_DIR}/etc/network/interfaces
echo auto wlan0 >> ${TARGET_DIR}/etc/network/interfaces
echo iface wlan0 inet dhcp >> ${TARGET_DIR}/etc/network/interfaces
echo pre-up /usr/sbin/wpa_supplicant -B w -D wext -i wlan0 -c /etc/wpa_supplicant.conf -dd >> ${TARGET_DIR}/etc/network/interfaces
{% endhighlight %}

## サウンドデバイスの設定
内蔵サウンドが動いてくれないので、USBサウンドアダプタを使う事にした。
たまたま手元にあったので、SoundBlaster Play!を使ってみる。

Linuxカーネルの設定で、alsaサウンド、USBサウンドを有効にする。

何故かdmixに関してのエラーがでるため、alsaの設定をした。
overlay/etc/asound.confに
{% highlight text %}
pcm.!default {
  type plug
  slave.pcm hw
}
{% endhighlight %}
と書いておいたら解決した。
また今度、alsaに関しては勉強したい。

なんかめっちゃうるさいので、
init.dの中で、amixer set PCM 5%とか書いてボリュームをしぼっておいている。

## mpg123
なつかしのmpg123がWebラジオに対応していたので、これを使う事にした。
buildrootのパッケージあったので有効にするだけだった。

最後にinit.dに乱数で選択した局を再生するスクリプトをしこんで完成。

# まとめ

以上の構成で電源を入れてから8秒ぐらいでラジオ再生がはじまる。

ubootの起動待ちで2秒待っていたり、乱数の初期化などの時間もかかっているので、
まだ改善の余地がありそう。

こう書くと簡単だが1週間以上試行錯誤した。
しかし、まあbuildrootに詳しくなったのでよしとしよう。

