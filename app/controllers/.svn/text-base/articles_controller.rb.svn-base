#encoding: UTF-8
class ArticlesController < BaseController
  
  # 内容页
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-15
  def show    
    #获得栏目模型信息
    render_404 and return unless article = Article.find_by_id(params[:id])
    render_404("栏目不存在。") and return unless channel = article.channel
    #栏目的顶层结构
    top_node = Channel.top_node(channel).reverse

    template_id = channel.template_id_detail
    #更新点击数
     article.increment(:view_count)
     article.save_without_timestamping  #更新记录 不更新时间

    liquid_render template_id, :liquid => { "vo" => article, "channel" => channel, "top_node" => top_node, "model" => Article}
  end


  def  index
    render :text => "主页"
  end

end
