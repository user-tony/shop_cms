#encoding:UTF-8
module Cms
  class CmsList < Liquid::Block
    Syntax = /(#{VariableSignature}+)\s+in\s+([^\s]*)\s+(.*)/o

    def initialize(tag_name, markup, tokens)
      @nodelist = []
      if markup =~ Syntax
        @var_name, @class_name, @attributes = $1, $2, {}
        markup.scan(TagAttributes) { |key, value|  @attributes[key] = value }
        @page_size = @attributes["page_size"] || 20
       @url = @attributes["url"] || ''
       @param_name = @attributes["param_name"] || "page"
      else
        raise SyntaxError.new("格式错误！")
      end
      super
    end

    def render(context)
      @context = context
      context.stack do
       @attributes.each do |key, value|
         if value =~ /\'(.+)\'/
           @attributes[key] = $1
         else
           @attributes[key] = context[value]
         end
       end
        collection = @class_name.constantize.cms_liquid_each(@attributes,{})
        current_page = context[@param_name] || 1
        collection = collection.page(current_page) 
        collection = collection.per(@attributes["page_size"] || @page_size )
        page_count = collection.num_pages
        paginate_html = ''
        helpers.content_tag :div, :class => "pagination" do
          if page_count > 1
              paginate_html += helpers.content_tag :span, :class => "prev" do
                          helpers.link_to("‹ 上一页","#{@url}?#{@param_name}=#{current_page-1}")
              end if current_page > 1
          end
          if page_count > 8
            1.upto(3) { |i| paginate_html << page_link(i, current_page) }
            if current_page > 1 and current_page < page_count
              paginate_html << "..." if current_page > 5
              min = current_page > 4 ? current_page-1 : 4
              max = current_page < page_count-4 ? current_page+2 : page_count-2
              (min..max-1).each { |i| paginate_html << page_link(i, current_page) } if max >= min+1
              paginate_html << "..." if current_page < page_count-4
            else
              paginate_html << "..."
            end
            (page_count-2..page_count).each{ |i| paginate_html << page_link(i, current_page) }
          else
            (1..page_count).each{ |i| paginate_html << page_link(i, current_page) }
          end
          paginate_html += helpers.content_tag :span, :class => "next" do
                      helpers.link_to("下一页 ›", "#{@url}?#{@param_name}=#{current_page+1}")
                    end if current_page < page_count
          paginate_html.html_safe
        end
        context['page_count'] = page_count
        context['paginate_html'] = paginate_html
        context[@var_name] = collection
        render_all(@nodelist, context)
      end
       
    end

    private
    def page_link(page, current_page)
      current_page == page ? helpers.content_tag(:span, page, :class => "page current") : helpers.content_tag(:span, helpers.link_to("#{page}", "#{@url}?#{@param_name}=#{page}"), :class => "page")
    end
    #rails提供helper的代理类
    def helpers
      ActionController::Base.helpers
    end
  end

  Liquid::Template.register_tag('cms_list', CmsList)
end
