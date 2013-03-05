class CreateKeyWordFilters < ActiveRecord::Migration
  def self.up
    create_table :key_word_filters , :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column  :content,           :string                    # 过滤内容
      t.column  :replace,           :string                    # 替换字符
      t.timestamps
    end
    say "init key_word_datas"
    # 初始化关键字数据信息
    path = "#{Rails.root}/config/words/key_word_filter.dic"
    File.open(path) do |file|
      file.each_line{|line| KeyWordFilter.create(:content => line.strip, :replace => "**") }  #添加数据
    end  
  end

  def self.down
    drop_table :key_word_filters
  end
end
