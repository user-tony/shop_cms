#encoding: UTF-8
class BaseController < ApplicationController
  protect_from_forgery

  
  skip_before_filter :verify_authenticity_token
  # protect_from_forgery
  

  protected
  # 模板引擎渲染
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-8
  #
  # ==== 参数
  # * <tt>template</tt> - 模板字符串或模板id
  # * <tt>options</tt> - 配置（哈希），和render的参数一样。其中 :liquid => { 给模板暴漏的hash }
  #
  # ==== 示例
  #   liquid_render(1, :liquid => {"name" => "hello tom"} ,:layout => false)
  #
  # ==== 返回
  #   render
  #
  def liquid_render(template, options = {})
    return render :text => "错误：模板为nil。" unless template
    #如果是数字则查询数据库模板
    if template.class == Fixnum        
      unless (template = Template.find_by_id(template))
        return render :text => "没有找到对应模板。"
      end
      template = template.content
    end
    hash = {
      "cms" => $cms_global_variable ||= {},
      "session" => session,                                                            #用户信息
      "cookies" => ShopCart.get_cart(cookies[:shop_cart]),                             #购物车
      "flash_error" => flash[:error],                                                    #提示信息
      "params"  => params,
      "page" => params[:page]                                        
    }
    hash["hot_search_keys"] = $cms_global_variable["shop_hot_search_keys"].split(",") if  hash["hot_search_keys"]   #商城热门搜索
    content =  hash
    render(
      :inline => "<%=raw Liquid::Template.parse(template).render(content)%>",
      :locals => { :template => template , :content => content.merge(options[:liquid]||{})},
      :layout => options[:layout] || false 
    )
  end

  # render,404错误提示
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-22
  #
  # ==== 参数
  # * <tt>msg</tt> - 提示信息
  #
  # ==== 示例
  #   render_404("您浏览的页面不存在")
  #
  # ==== 返回
  #   render
  #
  def render_404(msg = nil)
    render :text => msg || "您访问的页面不存在。", :status => 404
  end
  

end
