# encoding: utf-8

require './robo.rb'
RESULT = {'1.0' => '○', '-1.0' => '×'}

text = '交差点の5メートル以内に駐車できない。'
analyser = MorphologicalAnalyzer.new(text)
puts text
morpho_result = analyser.analyze
morpho_result.each do |e|
  puts "word = #{e['word']}, id = #{e['id']}, count = #{e['count']}"
end

svmline = SvmFeatureCreator.new(analyser.features)
svmline.create

pred = SvmPredictor.new(svmline.svm_line)
result = pred.predict

puts RESULT["#{result}"]