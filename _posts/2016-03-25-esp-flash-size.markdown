---
layout: post
title: "ESP8266のフラッシュメモリのサイズを調べる."
date: 2016-03-25 20:55:33 -0700
categories: Make ESP8266
---
ESP8266(ESP-12)にプログラムを書き込んでいる時、
シリアルケーブルを使って書き込んでいるが、
ケーブルを用意するのが面倒だったり、
環境によっては速度が遅いので、
WifiごしにOTAでのアップデートをしたい。

とりあえず、[BasicOTAのサンプル][1]を書き込み、試してみると、
IDE側では、```No response from device```。
ESP側では、```Error[1]: Begin Failed```というエラーが見える。

[調べた結果][2]、これはフラッシュメモリの量が足りないとおこるようだ。
OTAは、受信したプログラムをフラッシュメモリの空き領域に置き、
そこからブートする仕組みのようだ。
そのため、OTAするファームウエア分の空き領域が必要のようだ。

ESP12は4MBのフラッシュメモリを搭載しているはずで、
書き込もうといているファームウエアは220kb程度なので、
OTAできそうだが、うまくいかない。

ESP8266+ArduinoIDEの環境では、[マニュアルによると][3]、
```ESP.getFlashChipSize()```という関数でフラッシュメモリのサイズがわかるはずだが、
これが512kbを返す。
どうも、これはリンカスクリプトで指定されたフラッシュメモリのサイズを返すだけのようだ。
実はドキュメントされていない```ESP.getFlashChipSizeByChipId()```という関数がある。
これによると、このチップは4MBのメモリを積んでいるようだ。

ArduinoIDEのメニューから4MBのメモリを選ぶとOTAに成功した。
1つ注意としては、新しい方と古い方、双方のフラッシュメモリサイズが4MBになっていないといけない。
新しいファームウエアだけ4MBにしても、古い方は512kbしかないと思っていると成功しないわけだ。

[1]: https://github.com/esp8266/Arduino/blob/master/libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino
[2]: https://github.com/esp8266/Arduino/issues/1042
[3]: https://github.com/esp8266/Arduino/blob/master/doc/libraries.md#esp-specific-apis
