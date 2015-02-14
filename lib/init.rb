# encoding: utf-8

require 'json'
require 'yahoo_parse_api'

# API KEYの設定
if ENV['yahoo_app_id'] # on heroku
  id = ENV['yahoo_app_id']
else # on local
  f = File.open('app/controllers/data/api_key.txt')
  id = f.read.
  id = 'dj0zaiZpPU1hZ00wMTNIQnQyQyZzPWNvbnN1bWVyc2VjcmV0Jng9YTA-'
end
YahooParseApi::Config.app_id = id

QUESTION_FILE = 'app/controllers/data/questions.json'
DICT_FILE = 'app/controllers/data/words.dict'
TRAIN_FILE = 'app/controllers/data/questions.train'
MODEL_FILE = TRAIN_FILE + '.model'
ANSWER_TO_ID = {'○'=>'+1', '×'=>'-1'}
UNIQ_FILTER = '1|4|5|8|9|10|12'

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
