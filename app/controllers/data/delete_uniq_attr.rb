# coding: utf-8

# ユニークな属性を削除する
# ユニークでなくても可

# 2016.06.25: しきい値10でも片方に100%予測されてしまった。
# クラスのバランス化がいるかも。

# 削除対象とする属性のカウントしきい値
THRESHOLD = 15

# 属性ごとのカウント値
attributes_count = Hash.new

begin
  File.open(ARGV[0]) do |file|
    file.each_line do |line|
      elements = line.split(/ /)
      elements.delete_at(0)
      elements.each do |element|
        (id, val) = element.split(/:/)
        if !attributes_count.has_key?(id)
          attributes_count[id] = 0
        end
        attributes_count[id] += 1
      end
    end
  end

  # カウントごとのヒストグラムを算出
  histgram = Hash.new
  attributes_count.each_value do |val|
    if !histgram.has_key?(val)
      histgram[val] = 0
    end
    histgram[val] += 1
  end

  # しきい値にもとづいて属性を削除する
  # 削除用の正規表現パターンを作成
  replace_ids = []
  attributes_count.each_pair do |id, val|
    if val <= THRESHOLD
      replace_ids.push(id)
    end
  end

  # 削除して print
  File.open(ARGV[0]) do |file|
    file.each_line do |line|
      line.gsub!(/ (?:#{replace_ids.join('|')})\:1/, '')
        puts line
    end
  end
  
rescue SystemCallError => e
  puts "error"
rescue IOError => e
  puts "IOError"
end

# ヒストグラムを知りたいときはコメントを外す
# p histgram.sort { |(a1,v1), (a2,v2)| v1 <=> v2 }
