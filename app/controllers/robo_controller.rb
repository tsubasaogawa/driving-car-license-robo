# encoding: utf-8

RESULT = {'1.0' => '○', '-1.0' => '×'}

class RoboController < ApplicationController
  def index

  end
  
  def analyze
    if params['input'] == nil
	  @system_output = '文字が入力されていないよ'
	  @morpho_result = nil
	else
      @text = params['input']['user']
      analyser = MorphologicalAnalyzer.new(@text)
      @morpho_result = analyser.analyze
      @morpho_result.each do |e|
        puts "word = #{e['word']}, id = #{e['id']}, count = #{e['count']}"
      end

      svmline = SvmFeatureCreator.new(analyser.features)
      svmline.create

      pred = SvmPredictor.new(svmline.svm_line)
      result = pred.predict
      @system_output = RESULT["#{result}"]
    end
    puts @system_output
  end
end
