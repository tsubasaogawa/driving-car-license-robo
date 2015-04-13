# encoding: utf-8
# ���json�t�@�C�����w�K�f�[�^�ɕϊ�����

require './init'
require './bag_of_words'

# �w�K�f�[�^�ɕϊ�
def jsonfile_to_data(jsonfile)
  f = File.open(jsonfile, 'r')
  json = f.read
  f.close
  utf_json = json.force_encoding('utf-8')
  data = JSON.parse(utf_json)
end

# ������x�����ɕϊ�
class QuestionToDictionary
  def initialize(savefile, readfile)
    @savefile = savefile
    @readfile = readfile
  end
  
  def convert
    data = jsonfile_to_data(@readfile)
    parser = YahooKeyphraseApi::KeyPhrase.new
    words_array = []
    
    f = File.open(@savefile, 'w')
    data.each do |five_questions|
      five_questions.each do |question|
        # Yahoo API�L�[�t���[�Y��̓C���X�^���X
        result = parser.extract(question['question'])
        result.each_pair do |key, value|
          if !words_array.include?(key) and value > KEYPHRASE_THRES
            words_array.push(key)
            f.puts(key)
          end
        end
      end
    end
    f.close
  end
end

# �����f�[�^�Z�b�g�ɕϊ�
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
