#encoding: UTF-8
module ApplicationHelper


  # 格式化时间
  #
  # 作者: 佟立家
  # 最后更新时间: 2011-12-28
  #
  # ==== 参数
  # * <tt>time</tt> -  时间
  #
  # ==== 示例
  #   current_time_format(self.created_at)
  #
  # ==== 返回
  #   	2011-12-21 11:49:30
  #
  def current_time_format(time,type = false)
    type.present? ? time.strftime("%Y-%m-%d %H:%M:%S") : time.strftime("%Y-%m-%d")  if time
  end

  # 按字符剪切字符串（一个字母算半个字）
  #
  # 作者: 佟立家
  # 最后更新时间: 2011-12-28
  #
  # ==== 参数
  # * <tt>text</tt> -  内容
  # * <tt>length</tt> -  长度
  # * <tt>truncate_string</tt> - 后缀结束符
  #
  # ==== 示例
  #   current_time_format(self.created_at)
  #
  # ==== 返回
  #   	2011-12-21 11:49:30
  #
  def truncate_u(text, length = 30, truncate_string = "...")
     return "" unless text
     return text if text.length < length
    l=0
    char_array=text.unpack("U*")
    char_array.each_with_index do |c,i|
      l = l+ (c<127 ? 0.5 : 1)
      if l>=length
        return char_array[0..i].pack("U*")+(i<char_array.length-1 ? truncate_string : "")
      end
    end
    return text
  end

  
  # 格式货币显示
  #
  # 作者: 佟立家
  # 最后更新时间: 2011-12-22
  #
  # ==== 参数
  # * <tt>price</tt> -  价格
  #
  # ==== 示例
  #   currency_price(price)
  #
  # ==== 返回
  #   ￥564.00
  #
  def currency_price(price)
    number_to_currency(price,{:unit => "￥",:separator => "." , :delimiter => ""})
  end
  
  # 错误信息存入数组并返回
  # 
  # 作者：李季
  # 最后更新时间：2012-3-15
  # 
  # ==== 参数
  # * <tt>var</tt> -
  #  
  # ==== 示例
  # error_messages(@member) 
  # 
  # ==== 返回
  #   ["用户名不能为空！","用户名长度应介于6-18！"]  
  #
  def error_messages(var)
    var.errors.messages.inject([]){|arr, (key, value)| arr << value; arr}.flatten
  end


end
