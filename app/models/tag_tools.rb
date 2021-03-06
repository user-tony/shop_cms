#encoding: UTF-8
class TagTools


  #  生成标签
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-01-16
  #
  # ==== 参数
  # * <tt>title</tt> - 标题
  # * <tt>content</tt> - 内容
  # * <tt>limit</tt> - 标签数
  #
  # ==== 示例
  #   TagTools.get_tags("a", "b", 5)
  #
  # ==== 返回
  #   ["a", "b"]
  #
  def self.get_tags(title,content = "",limit = 5)
    result = []
    algor = RMMSeg::Algorithm.new( "#{title * 4}#{content}")
    while tok = algor.next_token
      if new_text = result.assoc(tok.text)
        new_text.replace([tok.text,new_text[1]+1])
      else
        result << [tok.text,1]
      end
    end
    garbage = "`-=\\;',./~!@#$\%^&*()_+{}|:\"<>?·－＝【】÷；‘’，。、～！◎#¥％…※×（）—＋『』§：“”《》？abcdefghijklmnopqrstuvwxyz0123456789你我他她它是的".split("")
    result.delete_if {|x| (x[0].size <= 3 || (garbage & x[0].split("")).size > 0) ? true : false }.sort {|x,y| x[0].size > y[0].size ? -1 : 1}.sort {|x,y| x[1] > y[1] ? -1 : 1}.take(limit).map{|a| a[0]}
  # rescue
  #   []
  end


  # 获取当前标签的的数组
  # 过滤关健字里面不对的符号（可扩展）
  # 作者: 佟立家
  # 最后更新时间: 2011-03-29
  #
  # ==== 参数
  # * <tt>tag</tt> -  标签
  #
  # ==== 示例
  #  类方法
  #   TagTools.get_split_tags("你好 仔仔通， 窝窝家 , 宝宝树")
  #
  # ==== 返回
  #   ['你好','仔仔通','窝窝家','宝宝树']
  #
  def self.get_split_tags(tag)
     tag.gsub(/[_ ，。&#]/,',').split(',')
  end
end