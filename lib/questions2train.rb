# encoding: utf-8

require './init'
require './bag_of_words'

def jsonfile_to_data(jsonfile)
  f = File.open(jsonfile, 'r')
  json = f.read
  f.close
  utf_json = json.force_encoding('utf-8')
  data = JSON.parse(utf_json)
end

class QuestionToDictionary
  def initialize(savefile, readfile)
    @savefile = savefile
    @readfile = readfile
  end
  
  def convert
    data = jsonfile_to_data(@readfile)
    parser = YahooParseApi::Parse.new
    words_array = []
    
    f = File.open(@savefile, 'w')
    data.each do |five_questions|
      five_questions.each do |question|
        result = parser.parse(question['question'], {
          results: 'ma,uniq',
          uniq_filter: UNIQ_FILTER
        })
        result['ResultSet']['uniq_result']['word_list']['word'].each do |word_hash|
          if !words_array.include?(word_hash['surface'])
            words_array.push(word_hash['surface'])
            f.puts(word_hash['surface'])
          end
        end
      end
    end
    f.close
  end
end

class QuestionToTrain
  def initialize(trainfile, questionfile, dictfile)
    @trainfile = trainfile
    @questionfile = questionfile
    @dictfile = dictfile
  end
  
  def convert
    dl = DictionaryLoader.new(@dictfile)
    dl.load

    data = jsonfile_to_data(@questionfile)
    t = File.open(@trainfile, 'w')

    bow = BoW.new(dl.dictionary)
	
    data.each do |five_questions|
      five_questions.each do |question|
        output_str = '' + ANSWER_TO_ID["#{question['answer']}"]

        features = bow.convert_to_feature(question['question'])
        features.each do |array|
          key, value = array[0], array[1]
          output_str << " #{key}:#{value}"
        end
        t.puts(output_str)
      end
    end
    t.close
  end
end

q = QuestionToDictionary.new(DICT_FILE, QUESTION_FILE)
q.convert
q = QuestionToTrain.new(TRAIN_FILE, QUESTION_FILE, DICT_FILE)
q.convert
