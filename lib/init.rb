# encoding: utf-8

require 'json'
require 'yahoo_parse_api'

# API KEYの設定
if ENV['yahoo_app_id'] # on heroku
  YAHOO_ID = ENV['yahoo_app_id']
  FILE_DIR = 'app/controllers/data'
else # on local
  f = File.open('/dropbox/driving/robo/app/controllers/data/api_key.txt')
  YAHOO_ID = f.read.chomp
  f.close
  FILE_DIR = '/dropbox/driving/robo/app/controllers/data'
end
YahooParseApi::Config.app_id = YAHOO_ID
QUESTION_FILE = "#{FILE_DIR}/questions.json"
DICT_FILE = "#{FILE_DIR}/words.dict"
TRAIN_FILE = "#{FILE_DIR}/questions.opt5.important_marked.bl.train"
MODEL_FILE = TRAIN_FILE + '.model'
ANSWER_TO_ID = {'○'=>'1', '×'=>'-1'}
UNIQ_FILTER = '1|9|10|12'
IMPORTANT_IDS = %w(3 16 35 73 81 139)

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
