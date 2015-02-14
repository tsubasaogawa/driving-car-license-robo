# encoding: utf-8

# 自動車学校の試験問題を解く

#require './init'
#require './bag_of_words'
require 'svm'

class MorphologicalAnalyzer
  def initialize(text)
    @text = text
  end
  
  # 文を形態素解析
  def analyze
    dl = DictionaryLoader.new(DICT_FILE)
    dl.load
    bow = BoW.new(dl.dictionary)
    @features = bow.convert_to_feature(@text)
    return bow.words
  end
  
  attr_reader :features
end

class SvmFeatureCreator
  def initialize(features)
    @features = features
  end
  
  def create
    @svm_line = {}
    @features.each do |array|
      id, value = array[0], array[1]
      @svm_line[id.to_i] = value.to_f
    end
  end
  
  attr_reader :svm_line
end

# 素性からSVMで予測
class SvmPredictor
  def initialize(svm_line)
    @svm_line = svm_line
  end
  
  def predict
    model = Model.new(MODEL_FILE)
    result = model.predict(@svm_line)
  end
end
