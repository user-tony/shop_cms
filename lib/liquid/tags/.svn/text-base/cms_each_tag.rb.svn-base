#encoding:UTF-8
module Cms
  # 自动生成系统模型循环标签
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-9
  class CmsEachTag < Liquid::Block

    Syntax = /(\w+)\s+in\s+(#{QuotedFragment}+)\s*(c)?/
    
    def initialize(tag_name, markup, tokens)
      @markup = markup
      if markup =~ Syntax
        @variable_name = $1
        @nested = $3
        @attributes = {}
        markup.scan(TagAttributes) do |key, value|
          @attributes[key] = value
        end
      else
        raise SyntaxError.new("#{tag_name} 标签出错，不符合格式。")
      end

      @nodelist = @for_block = []
      super
    end

    def render(context)
      return "标签名格式不正确" unless @tag_name =~ /cms_(\w+)/
      return "标签对应的rails模型类不存在" unless class_quote = Cms::class_const($1)
      return "rails模型中不存在标签对应的方法" unless class_quote.respond_to?("cms_liquid_each")
     
      #渲染参数变量值
      attr = {}
      @attributes.each { |k,v| attr[k] = context[v] }

      options = {}
      page = class_quote.send "cms_liquid_each", attr, options

      #错误提示
      return page if page.class == String
      
      length = page.length
      result = ''
      context.stack do
        page.each_with_index do |item, index|
        context[@variable_name] = item
        context['forloop'] = {
          'url' => Cms::cms_url(options[:url], item),
          'length' => length,
          'index' => index + 1,
          'index0' => index,
          'rindex' => length - index,
          'rindex0' => length - index -1,
          'first' => (index == 0),
          'last' => (index == length - 1) }
          result << render_all(@for_block, context)
        end
      end
      result
    end

    def unknown_tag(tag, markup, tokens)
      return super unless tag == 'else'
      @nodelist = @else_block = []
    end

  end  
  
end
