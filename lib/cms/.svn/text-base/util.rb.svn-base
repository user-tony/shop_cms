module Cms

  #rails提供helper的代理类
  def self.helpers
    ActionController::Base.helpers
  end

  # 根据字符获得类的引用
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-9
  #
  # ==== 参数
  # * <tt>class_name</tt> - 类名称
  #
  # ==== 示例
  #   class_const("Template")
  #
  # ==== 返回
  #   类的引用
  #
  def self.class_const(class_name)    
    class_name.constantize unless class_name.blank?
  rescue
    nil
  end
  
  # 生成url
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-16
  #
  # ==== 参数
  # * <tt>url</tt> - url
  # * <tt>item</tt> - 对象
  #
  # ==== 示例
  #   Cms::cms_url("/articles/${id}", article.new)
  #
  # ==== 返回
  #   字符 "/articles/1"
  #
  def self.cms_url(url, item)
    return nil if url.blank?    
    url.scan(/\$\{(\w+)\}/).each do |u|
      temp = u.first
      next unless item.respond_to?(temp)
      url = url.gsub("${#{temp}}", item.send(temp).to_s)
    end
    url
  end
  
end
