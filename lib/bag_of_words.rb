# encoding: utf-8

class BoW
  def initialize(dict_array)
    @dict_array = dict_array
    @parser = YahooParseApi::Parse.new
  end
  
  # 文を形態素解析し、ソート済の配列の配列: [[ID, count], [ID, count], ...]で返す
  def convert_to_feature(sentence)
    output_hash = {}
    @words = []
    result = @parser.parse(sentence, {
      results: 'ma,uniq',
      uniq_filter: UNIQ_FILTER
    })
    if result['ResultSet']['uniq_result']['word_list'] == nil
      output_hash[0] = nil
      @words = nil
    else
      result['ResultSet']['uniq_result']['word_list']['word'].each do |word_hash|
        # 辞書内に単語があれば機械学習に食べさせる
        if id = @dict_array.index(word_hash['surface'])
          output_hash["#{id}"] = word_hash['count'] 
          @words.push({'word' => word_hash['surface'], 'count' => word_hash['count'].to_i + get_weight_of_word_id(id), 'id' => id})
	# 辞書になければ、その単語は無視する (id=-1)
        else
          @words.push({'word' => word_hash['surface'], 'count' => word_hash['count'], 'id' => -1})
        end	 
      end
    end
    return output_hash.sort{|a, b| a[0].to_i <=> b[0].to_i}
  end
  
  def get_weight_of_word_id(id)
    IMPORTANT_IDS.each do |important_id|
      if id == important_id
        return 1
      end
    end
    0
  end
  attr_reader :words
end
