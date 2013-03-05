#encoding: UTF-8
class KeyWordFilter < ActiveRecord::Base


  # 字过滤
  #   夫换关键字方法
  # 作者: 佟立家
  # 最后更新时间: 2011-12-31
  #
  # ==== 参数
  # * <tt>content</tt> -  过滤内容
  #
  # ==== 示例
  #
  #   KeyWordFilter.replace_content(content)
  #
  # ==== 返回
  #   true/false
  #
  def self.replace_content(content)
    return handle_word(content)
  end


  # 查询关键字升成数据, 多维数据伸平
  #
  #
  # 作者: 佟立家
  # 最后更新时间: 2011-12-31
  #
  #
  # ==== 返回
  #   ['1','1']
  #
  def self.replacement_hash
    Hash[*all.collect{|re| [re.content,re.replace] }.flatten]
  end


  #
  ##
  # 作者: 佟立家
  # 最后更新时间: 2011-12-31
  #
  # ==== 参数
  # * <tt>object</tt> -
  #
  # ==== 示例
  #
  #
  # ==== 返回
  #
  def self.filter_word_tree(object = nil)
    word_tree = Array.new(256) << 0
    object = replacement_hash if object.nil?
    object.each do |word,replace|
      temp  = word_tree
      bytes = word.bytes.to_a
      len   = bytes.size

      bytes.each_with_index do |asicc_code,arr_index|
        if arr_index < len - 1
          if temp[asicc_code].nil?
            node = [Array.new(256),0]
            temp[asicc_code] = node
          elsif temp[asicc_code] == 1
            node = [Array.new(256),1]
            temp[asicc_code] = node
          else
          end
          temp = temp[asicc_code][0]
        else
          temp[asicc_code] = 1
        end
      end
    end
    [word_tree,0]

  end


  # 关健字过滤
  # 关健字过滤方法
  # 替换明感 字符
  #
  # 作者: 佟立家
  # 最后更新时间: 2011-12-31
  #
  # ==== 参数
  # * <tt>do_words</tt> -
  # * <tt>replace</tt> -
  # * <tt>word_tree</tt> -
  # * <tt>word_hash</tt> -
  #
  # ==== 示例
  #
  #   KeyWordFilter.replace_content(content)
  #
  # ==== 返回
  #   true/false
  #
  def self.handle_word(do_words,replace = true,word_tree = nil,word_hash = nil)
    word_tree = filter_word_tree if word_tree.nil?
    word_hash = replacement_hash if word_hash.nil?
    temp      = word_tree
    nodeTree  = word_tree
    words     = []
    word      = []
    to_replace= []
    a         = 0
    byte_words = do_words.bytes.to_a
    while a < byte_words.size
      index = byte_words[a]
      temp = temp[0][index]
      if temp.nil?
        temp = nodeTree
        a = a - word.size
        word = []
        to_replace = []
      elsif temp == 1 or temp[1] == 1
        word << index
        to_replace << a
        words << word

        if replace
          replace_word = word_hash[word.pack("C*").force_encoding("UTF-8")].bytes.to_a
          byte_words[(a-to_replace.size + 1),to_replace.size] = replace_word
          a = (a - to_replace.size + 1) + (replace_word.size - 1)
        else
          a = a - word.size + 1
        end
        word = []
        to_replace = []
        temp = nodeTree
      else
        word << index
        to_replace << a
      end
      a += 1
    end
    return byte_words.pack("C*").force_encoding("UTF-8") if replace
    words.collect{|e| e.collect{|ch|ch.chr}.join }
  end
end