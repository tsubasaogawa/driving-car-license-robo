# encoding: utf-8

RESULT = {'1.0' => '○', '-1.0' => '×'}
RESULT_PN = {'1.0' => '_positive', '-1.0' => '_negative'}

class RoboController < ApplicationController
  def index

  end

  def analyze
    @result_pn = ''
    if params['input']['user'] == ''
      @system_output = '文字が入力されていないよ'
      @morpho_result = nil
    else
      @text = params['input']['user']
      analyser = MorphologicalAnalyzer.new(@text)
      @morpho_result = analyser.analyze
      if @morpho_result == nil
        @system_output = '形態素解析に失敗したよ'
      else
        @morpho_result.each do |e|
          puts "word = #{e['word']}, id = #{e['id']}, count = #{e['count']}"
        end

        svmline = SvmFeatureCreator.new(analyser.features)
        svmline.create

        pred = SvmPredictor.new(svmline.svm_line)
        result = pred.predict
        @system_output = RESULT["#{result}"]
        @result_pn = RESULT_PN["#{result}"]
      end
    end
    puts "#{result} / #{@system_output}"
  end
end
