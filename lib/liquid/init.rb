module Cms
  QuotedString = /"[^"]*"|'[^']*'/
  QuotedFragment = /#{QuotedString}|(?:[^\s,\|'"]|#{QuotedString})+/
  TagAttributes  = /(\S+)\s*\:\s*(#{QuotedFragment})/
  VariableSignature  = /\(?[\w\-\.\[\]]\)?/
  
  # 添加模板标签
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-11
  #
  # ==== 参数
  # * <tt>model_class</tt> - 模型类
  # ==== 示例
  #   Cms::register_tag(Article)
  #
  def self.register_tag(model_class)
    Liquid::Template.register_tag("cms_#{model_class.to_s}", Cms::CmsEachTag)    
  end

end

ActiveRecord::Base.class_eval do

  # liquid_methods方法封装，默认暴漏所有字段和关联关系
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-11
  #
  # ==== 参数
  # * <tt>additional</tt> - 追加字段
  # ==== 示例
  #   my_to_liquid([])
  #
  def self.mango_liquid(additional = nil)    
    model_column_temp = self.column_names+self.reflections.keys
    cms_liquid_methods(model_column_temp, additional)
  rescue
    nil
  end

  # 增强liquid_methods
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-11
  #
  # ==== 参数
  # * <tt>allowed_methods</tt> - 注册字段，格式：数组
  # * <tt>additional</tt> - 追加字段
  # ==== 示例
  #   cms_liquid_methods([])
  #
  def self.cms_liquid_methods(allowed_methods, additional = nil)
    drop_class = eval "class #{self.to_s}::LiquidDropClass < Liquid::Drop; self; end"
    define_method :to_liquid do
      drop_class.new(self)
    end
    allowed_methods += additional if additional
    drop_class.class_eval do
      def initialize(object)
        @object = object
      end
      allowed_methods.each do |sym|
        define_method sym do
          @object.send sym
        end
      end
    end
  end
  
end


require "liquid/paginate.rb"
require 'liquid/liquid_filters.rb'

Dir[File.dirname(__FILE__) + '/tags/*.rb'].each { |f| require f }