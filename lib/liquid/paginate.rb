#encoding:UTF-8
module Cms
  class Paginate
    
    def initialize(scope, options = {})
      @scope, @options = scope, options
    end

    def to_s
      current_page, num_pages = @scope.current_page, @scope.num_pages

      #是否始终显示
      return "" if (@options["always"].blank? && @scope.num_pages <= 1) || (@options["always"] != "true" && @scope.num_pages <= 1)

      #分页参数名
      param_name = @options["param_name"] || "page"

      #url
      url = @options["url"] || ""
      
      helpers.content_tag :div, :class => "pagination" do
        result = ''
        result += helpers.content_tag :span, :class => "prev" do
                    helpers.link_to("‹ 上一页","#{url}?#{param_name}=#{current_page-1}")
                  end if current_page > 1
        if num_pages > 8
          1.upto(3) { |i| result << page_link(i, current_page) }
          if current_page > 1 and current_page < num_pages
            result << "..." if current_page > 5
            min = current_page > 4 ? current_page-1 : 4
            max = current_page < num_pages-4 ? current_page+2 : num_pages-2
            (min..max-1).each { |i| result << page_link(i, current_page) } if max >= min+1
            result << "..." if current_page < num_pages-4
          else
            result << "..."
          end
          (num_pages-2..num_pages).each{ |i| result << page_link(i, current_page) }
        else
          (1..num_pages).each{ |i| result << page_link(i, current_page) }
        end
        result += helpers.content_tag :span, :class => "next" do
                    helpers.link_to("下一页 ›", "#{url}?#{param_name}=#{current_page+1}")
                  end if current_page < num_pages
        result.html_safe
      end
     
    end

    private
    def page_link(page, current_page)
      #分页参数名
      param_name = @options["param_name"] || "page"
      #url
      url = @options["url"] || ""

      current_page == page ? helpers.content_tag(:span, page, :class => "page current") : helpers.content_tag(:span, helpers.link_to("#{page}", "#{url}?#{param_name}=#{page}"), :class => "page")
    end

    #rails提供helper的代理类
    def helpers
      ActionController::Base.helpers
    end   
    
  end
end
