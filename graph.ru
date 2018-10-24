require 'csv'

class KVUrler
  KV_URL = Struct.new(:id, :url)

  @@kv_urls = []

  # 全nodeを作成
  def self.create(urls=[])
    @@kv_urls = []
    urls.each_with_index do |url, i|
      node_id = "node#{i+1}".to_sym
      @@kv_urls << KV_URL.new(node_id, url)
    end

    @@kv_urls
  end

  def self.to_node(name="")
    raise ArgumentError, "kv_urls empty" if @@kv_urls.empty?
    self.find_by(name).id
  end

  def self.find_by(url="")
    ifnone = proc { raise ArgumentError, "item not found" }
    @@kv_urls.find(ifnone){|item| item.url == url}
  end

  def self.get_by_slashes(count=0)
    @@kv_urls.select do |item|
      (item.url != "/") &&
        (item.url.count("/") == count)
    end
  end
end

class Pather
  Path = Struct.new(:from_url, :to_url, :count, :percentage)

  # 全passを作成
  def self.create(paths_from_ex=[])
    pathes = []

    paths_from_ex.each do |ex|
      pathes << Path.new(ex[0], ex[1], ex[2].to_i, ex[3].to_i)
    end

    pathes
  end
end

def main
  paths_from_ex = []
  # unique and claculated.
  CSV.foreach("hoge.csv", headers: :first_row) do |row|
    paths_from_ex << [row["from_url"], row["to_url"], row["count"], row["percentage"]]
  end

  # create unique  id, url key-value list
  urls = (paths_from_ex.map{|item| item[0]} + paths_from_ex.map {|item| item[1]}).uniq
  kv_urls = KVUrler.create(urls)
  pathes = Pather.create(paths_from_ex)
  #puts pathes
  #
  ## create node.
  #
  kv_urls.each do |url|
    node url.id, label: url.url
  end

  #
  ## create route and edge.
  #
  edge_default_options = { fontsize: '9' }

  pathes.each do |path|
     a_node = KVUrler.to_node(path.from_url)
     b_node = KVUrler.to_node(path.to_url)

     route a_node => b_node

     edge "#{a_node}_#{b_node}".to_sym,
         edge_default_options.merge(label: "#{path.percentage}%(#{path.count})",
                                    penwidth: (path.percentage/30.0).ceil)
  end

  #
  ## create rank.
  #
  # root path.
  if root_node = KVUrler.to_node("/")
    rank :min, root_node
  end


  # single slash.
  s_1s = KVUrler.get_by_slashes(2)
  unless s_1s.empty?
    rank :same, s_1s.map(&:id)
  end

  # double slash.
  s_2s = KVUrler.get_by_slashes(3)
  unless s_2s.empty?
    rank :same, s_2s.map(&:id)
  end

  save :ruby
end

main
