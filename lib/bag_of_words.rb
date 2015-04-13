# encoding: utf-8

class BoW
  def initialize(dict_array)
    @dict_array = dict_array
    @parser = YahooKeyphraseApi::KeyPhrase.new
  end
  
  # �����`�ԑf��͂��A�\�[�g�ς̔z��̔z��: [[ID, count], [ID, count], ...]�ŕԂ�
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
          output_hash["#{id}"] = 1 # �֋X�I�ɃJ�E���g��1�ɌŒ�
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
