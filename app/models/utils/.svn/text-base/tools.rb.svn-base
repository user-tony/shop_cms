#encoding: UTF-8
class Utils::Tools
  
 
  # 返回错误信息详细内容
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-07-19
  #
  # ==== 参数
  # * <tt>object</tt> - object
  # 
  # ==== 返回
  #    String
  #
 def self.get_errors_message(object)
  messages = ""
  object.errors.messages.map { |key,value|  messages  << "#{value.join(',')}" }  if object.errors && object.errors.messages
  messages
 end
 

end