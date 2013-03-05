#encoding:UTF-8
module Cms

  Syntax = /(#{QuotedFragment}+)(\s+(?:with|for)\s+(#{QuotedFragment}+))?/
  # 引入其它模板
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-9
  class Render < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax
        @template_name = $1
        @variable_name = $3
        @attributes = {}
        markup.scan(TagAttributes) do |key, value|
          @attributes[key] = value
        end

      else
        raise SyntaxError.new("Error in tag 'render' - Valid syntax: render '[template]' (with|for) [object|collection]")
      end

      super
    end

    def parse(tokens)
    end

    def render(context)
      @template_name = context[@template_name]
      #按模板ID查询
      if @template_name.class == Fixnum
        template = Template.find_by_id(@template_name, true)
      elsif @template_name.class == String
        template = Template.get_template_name(@template_name).first
      end
      return  Template::NOT_TEMP0LATE_MESSAGE unless template
      return "{%render #{@template_name}%}存在自身引用" if template.content =~ /\{%\s*render\s+#{@template_name}\s*%\}/
      @template_name = template.content
      partial = Liquid::Template.parse(@template_name)
      context.stack do
        @attributes.each do |key, value|
          context[key] = context[value]
        end
        partial.render(context)
      end
    end

  end
  Liquid::Template.register_tag('render', Render)
end
