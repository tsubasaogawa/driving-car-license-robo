# encoding: utf-8

class BoW
  def initialize(dict_array)
    @dict_array = dict_array
    @parser = YahooKeyphraseApi::KeyPhrase.new
  end
  
  # 文を形態素解析し、ソート済の配列の配列: [[ID, count], [ID, count], ...]で返す
  def convert_to_feature(sentence)
    output_hash = {}
    @words = []
    result = @parser.extract(sentence)
    if result == nil
      output_hash[0] = nil
      @words = nil
    else
      result.each_pair do |key, value|
        if id = @dict_array.index(key)
          output_hash["#{id}"] = 1 # 便宜的にカウントは1に固定
          @words.push({'word' => key, 'count' => 1, 'id' => id})
        else
          @words.push({'word' => key, 'count' => 1, 'id' => -1})
        end	 
      end
    end
    return output_hash.sort{|a, b| a[0].to_i <=> b[0].to_i}
  end
  
  attr_reader :words
end
