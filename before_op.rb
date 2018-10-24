#!/usr/bin/env ruby 

require 'json'
require 'csv'

def int2id(str='')
  str ||= ''
  str = "/" if (str == "/users/home")
  str.gsub(/[0-9]+/, ':id')
end

hoges = JSON.parse File.read('hoge.json')
rows = []
hoges["hits"]["hits"].each do |hit|
  rows << [int2id(hit["_source"]["referer"]), int2id(hit["_source"]["url"])]
end

p rows.count
uniq_rows  = []
uniq_rows = rows.uniq
p uniq_rows.count

new_rows = []

uniq_rows.each do |t|
  # 空要素を除去
  next if t.include?("")
  new_rows << (t.clone << rows.count(t))
end


new_rows.sort!
# 出現率計算
nodes = new_rows.map(&:first).uniq

node_totals = {}

nodes.each do |node|
  # 同一のform_urlを持つscoreを集める
  scores = new_rows.inject([]) do |arr, from_arr|
     arr << from_arr[2] if from_arr[0] == node
     arr
  end

  # score合計
  node_totals.merge!({ node => scores.inject(:+) })
end


CSV.open("hoge.csv", "wb") do |csv|
  csv << ["from_url", "to_url", "count", "percentage"]

  new_rows.each do |item|
    _item = item.clone
    per = ((_item[2].to_f / node_totals[_item[0]].to_f) * 100).round
    csv << (_item << per)
  end
end

