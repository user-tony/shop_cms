#encoding: UTF-8
class MainController < BaseController

  caches_page :index

  # 首页
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-8
  def index
    render_404("首页模板不存在。") and return unless template = Template.template_list(Template::TEMPLATE_TYPE[:index_type]).first
    liquid_render template.content and return

  end

  # 栏目页和列表页
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-15
  def list
    render_404 and return unless channel = Channel.find_by_id(params[:channel_id])
    #跳转栏目
    redirect_to channel.return_url and return if channel.channel_type == 2
    #栏目的顶层结构
    top_node = Channel.top_node(channel).reverse
    
    #    单页栏目处理
    if channel.single_page
      # 按类型栏目单页模板
      # 所属所属模型
      if current_member and channel.info_model.model_name == "Member"
        redirect_to "/" and return
      end
      model = channel.info_model
      render_404("单页模板不存在。") and return unless template = Template.find_by_id(channel.template_single)   #查找单页模版
      content = { "cms" => $cms_global_variable ||= {}, "session" => session, "channel" => channel }
      message = flash[:error] if flash[:error]
      if channel.custom_page &&  channel.custom_page.custom_page_content
        vo = Liquid::Template.parse(channel.custom_page.custom_page_content.content).render(content)
      end
      hash = { "vo" => vo, "channel" => channel, "top_node" => top_node, "message" => message, "go_url" => params[:go_url]}
      liquid_render(template.content, :liquid => hash) and return
    end

    #取模型，默认文章系统
    infor_model = Article
    if infor_model_temp = channel.info_model
      infor_model = Cms::class_const(infor_model_temp.model_name)
    end
    
    
    template_id = channel.template_id_list
    #判断栏目下是否存在子栏目和是否存在栏目页
    if Channel.where(:parent_id => channel.id).count > 0 and channel.template_id_index!=0 and !channel.template_id_index.nil?
      template_id = channel.template_id_index
    end
    #查询内容列表
    channel_ids = Channel.next_node(channel)
    if channel_ids.size == 0
      channel_ids = channel.id
    end
    
    list = infor_model.where(:channel_id => channel_ids).order("updated_at DESC")
    list = list.where("article_status = 1")  if Article == infor_model         #如果是文章栏目查询审核后的文章
    list = list.page(params[:page]).per(10)
    liquid_render template_id, :liquid => { "list" => list, "channel" => channel, "top_node" => top_node}
  end

  # 通用内容页
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-15
  def show
    render_404 and return unless channel = Channel.find_by_id(params[:channel_id], true)
    #栏目的顶层结构
    top_node = Channel.top_node(channel).reverse
    #取模型，默认文章系统
    infor_model = Article
    if infor_model_temp = channel.info_model
      infor_model = Cms::class_const(infor_model_temp.model_name)
    end
    #查询内容
    render_404 and return unless vo = infor_model.find_by_id(params[:id])
    
    liquid_render channel.template_id_detail, :liquid => { "vo" => vo, "channel" => channel, "top_node" => top_node, "model" => infor_model}
  end
  
end
