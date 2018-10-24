## jyunbi
gem install gviz --no-doc --no-ri
brew update
brew install gts
brew install graphviz



## フロー(仮)

* Kibana Discoverで範囲を決定しクエリを取得
* ElastiSearchからデータ取得
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
  * ローカルでElasticSearchから取得して実行する
  * パスの数字部分は全て:idへ置換
  * クエリパラメータは除外されている
  * 矢印の先が遷移先
  * 遷移率が高いほど矢印が太くなる
  * 遷移元、遷移先が空の場合は除外
  * ラベルは `遷移率(カウント数)`

## その他
  * データが欲しいときは横山まで
  * クエリを変えたい
  *特定のテナントで実行したい、時系列を変更したい場合、特定のuserのみにしたい場合等はESで変更できる
  * KibanaのDiscoverと同じ仕様
