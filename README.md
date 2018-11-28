## About
 Accesslogにgraphvizをかけて経路間のアクセス状況を可視化する


![](https://raw.githubusercontent.com/tetuyoko/gvisruby/master/images/ruby.png)

## Install

~~~
gem install gviz --no-doc --no-ri
brew update
brew install gts
brew install graphviz
~~~

## Flow

* 1. Kibana Discoverで範囲を決定しクエリを取得
* 2. ElastiSearchからデータ取得

~~~
% curl -XGET  **/_search -d '
REQUEST_QUETY
' > hoge.json
~~~

* 前処理して グラフ描画して開く
~~~
% sh transdot.sh
~~~


## 目的
  * UXを改善する拠り所とする
  * 意図した導線になっているか
  * あまり使われていない機能はどれか

## 仕様
  * ElasticSearchから取得して実行する
  * 前処理: パスの数字部分は全て:idへ置換
  * 前処理: クエリパラメータを除外
  * 前処理: 遷移元、遷移先が空の場合は除外
  * 遷移率が高いほど矢印が太くなる
  * ラベルは `遷移率(カウント数)`
