# coding: utf-8

# menkyo-web.com から問題を取得するスクリプト
# 保存はjson形式

require 'open-uri'
require 'nokogiri'
require 'json'

URLBODY = 'http://menkyo-web.com/mogi-mondai'
MATCH_TEXT = '【(.+)】(.*)'
NUMBER_PATTERN = [* 1 .. 220]
SAVE_FILENAME = 'questions.json'

# menkyo-webから問題を取得
class GetQuestions
  def initialize(url)
    @url = url
  end
  
  def parse(element)
	@result = [] # 問題文、答え、解説の順で格納される
	
	doc = Nokogiri::HTML.parse(open(@url), nil, 'cp932')
	doc.xpath(element).each do |node|
	  temp = {} # 1問題分のハッシュ
	  temp['question'] = node.xpath('tr/th[@class="left"]').text
	  desc = node.xpath('tr/td/span[@class="font-futozi01"]').text
	  m = /#{MATCH_TEXT}/u.match(desc)
	  temp['answer'] = m[1]
	  temp['description'] = m[2] # nilにはならない
	  @result.push(temp)
	end
   end
   
  attr_reader :result
end

# 問題をJson形式で保存するクラス
class SaveQuestions
  def initialize(array)
    @array = array
  end

  def save(filename)
    open(filename, 'w') do |f|
      f.puts(JSON.pretty_generate(@array)) # 整形して保存
	end
  end
end

# 得られた配列を保存するクラス
class Queue
  def initialize
    @array = []
  end
  
  def push(data)
    @array.push(data)
  end
  
  attr_reader :array
end

# 進捗状況を表示 (10%ごとに「*」）
def show_progress(i)
  one_tenth = (i / 10).to_i
  if one_tenth == 0
    one_tenth = 1
  end
  printf("\r")
  printf('*' * (i / one_tenth))
end

# main
if __FILE__ == $0
  # 保存用インスタンスの生成
  queue = Queue.new

  # おのおのの問題htmlについて処理
  NUMBER_PATTERN.each do |i|
    url = sprintf("%s%02d.html", URLBODY, i) # url生成
    get_obj = GetQuestions.new(url)
    get_obj.parse('//table[@class="quiz01"]') # DOM操作
    queue.push(get_obj.result) # 得られた結果をスタックにプッシュ
    show_progress(i)
  end
  print '\ncompleted\n'

  save_obj = SaveQuestions.new(queue.array)
  save_obj.save(SAVE_FILENAME)
end
