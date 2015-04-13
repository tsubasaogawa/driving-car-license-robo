# encoding: utf-8

require 'json'
#require 'yahoo_parse_api'
require 'yahoo_keyphrase_api'

# temporary variable
TEMP_DIR = '../'

# API KEYの設定
if ENV['yahoo_app_id'] # on heroku
  YAHOO_ID = ENV['yahoo_app_id']
else # on local
  f = File.open(TEMP_DIR + 'app/controllers/data/api_key.txt')
  YAHOO_ID = f.read.chomp
  f.close
end
YahooKeyphraseApi::Config.app_id = YAHOO_ID

QUESTION_FILE = TEMP_DIR + 'app/controllers/data/questions.json'
DICT_FILE = TEMP_DIR + 'app/controllers/data/words_kp.dict'
TRAIN_FILE = TEMP_DIR + 'app/controllers/data/questions_kp.train'
MODEL_FILE = TRAIN_FILE + '.model'
ANSWER_TO_ID = {'○'=>'+1', '×'=>'-1'}
UNIQ_FILTER = '9'#'1|4|5|8|9|12'
KEYPHRASE_THRES = 70

class DictionaryLoader
  def initialize(dictfile)
    @dictfile = dictfile
  end
  
  def load
    @dictionary = []
    f = File.open(@dictfile, 'r:utf-8')
    f.each_line do |line|
      @dictionary.push(line.chomp)
    end
  end
  
  attr_reader :dictionary
end
