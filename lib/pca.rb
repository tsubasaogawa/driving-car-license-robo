# encoding: utf-8

require 'statsample'
require 'matrix'
MAX_ID = 1589 # IDの最大値
RP_ROWS = 20 # random projection のヨコの長さ

class Pca
  def initialize(file='')
    @file = file
  end
  
  # データを読み込む
  # ファイル指定でない場合は引数にデータ（改行ごとに分けられた配列）  
  def read(data='')
    @data = []
    if @file == ''
      @data = data
    else
      File.open(@file, 'r').each_line do |line|
        @data.push(line.chomp)
      end
    end
  end
  
  # svm形式の学習データ（答え付き）を答えなしのヴェクトルデータに変換
  def convert_to_vector
    @vector_array = []
    vec_num = 0
    @data.each do |line|
      elements = line.split(/\s+/)
      elements.delete_at(0) # delete class
      vector = []
      vec_num = 0
      last_id = 0
      elements.each do |element|
        id, val = element.split(/:/)
        id = id.to_i
        # 飛び飛びのIDだったら埋める
        if last_id + 1 != id
          vec_num += set_sparse(vector, last_id+1, id-1)
        end
        vector.push(val.to_f)
        vec_num += 1
        last_id = id
      end
      if last_id != MAX_ID
        vec_num += set_sparse(vector, last_id+1, MAX_ID)
      end
      while vector.length > MAX_ID
        vector.delete_at(-1)
        vec_num -= 1
      end
      @vector_array.push(vector)
    end
    # puts "vector_array.x = #{vec_num}, vector_array.y = #{@vector_array.length}"
  end
  
  # PCAを実行
  def dimension_reduction
    vector_hash = {}
    count = 1
    @vector_array.each do |vector|
      set_sparse(vector, vector.length+1, MAX_ID)
      vector_hash["#{count}"] = vector.to_scale
      count += 1
    end
    ds = vector_hash.to_dataset
    cor_matrix = Statsample::Bivariate.correlation_matrix(ds)
    pca = Statsample::Factor::PCA.new(cor_matrix)
    pca.component_matrix
  end
  
  private
  def set_sparse(vector, start_pos, end_pos)
    count = 0
    for i in start_pos .. end_pos
      vector.push(0.0)
      count += 1
    end
    count
  end
end

class RandomProjection < Pca
  def dimension_reduction
    map_matrix_x = RP_ROWS
    map_matrix_y = @vector_array.size
    data_matrix = Matrix.columns(@vector_array)
    map_matrix = make_mapping_matrix(map_matrix_x, map_matrix_y)
    puts "#{data_matrix.row_size}x#{data_matrix.column_size} vs #{map_matrix.row_size}x#{map_matrix.column_size}"
    p data_matrix * map_matrix
  end
  
  def make_mapping_matrix(x, y)
    temp_matrix_array = []
    y.times do
      temp = Array.new(x, 0.0)
      temp_matrix_array.push(temp)
    end
    Matrix.rows(temp_matrix_array)
  end
end

puts "read data"
rp = RandomProjection.new('c:/users/ayu/dropbox/programming/driving/robo/app/controllers/data/questions.train')
rp.read()

puts "convert to vector"
rp.convert_to_vector

puts "do dimension reduction"
pca_array = rp.dimension_reduction
# p pca_array
