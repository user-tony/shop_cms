class Admin::ArticlesController < Admin::BaseController


  #设置可选栏目
  before_filter :set_channels ,  :oinly => [:new , :edit]

  def channel_index
    @channel = Channel.find_by_id(params[:id])
    article = Article.new params[:article]
    @articles = Article.article_where(article, @channel, params[:start_time], params[:end_time], params[:page])
    render :layout => false if request.headers["X-Requested-With"]
  end

  def search
    @channel = Channel.find_by_id params[:channel_id]
    @admin_article = Article.new params[:admin_article]
    @articles = Article.article_where(@admin_article, @channel, params[:start_time], params[:end_time], params[:page])
  end

  def new_article
    @article = Article.new
    @article.channel_id = params[:id].to_i if params[:id].present?
    @article.article_status = 1  #文章默认为审核
    render :layout => "iframe"
  end

  def edit
    @article = Article.find_by_id(params[:id])
    @article_content = @article.article_content  || ArticleContent.new
    @images = @article.attached_pictures
    render :layout => "iframe"
  end

  def create
    @article = Article.new params[:article]
    @article.tag_list = params[:tag].present? ? TagTools.get_split_tags(params[:tag]) : TagTools.get_tags(@article.title)
    if  @article.save
      flash[:success] = "基本信息保存成功！"
      redirect_to edit_admin_article_path(@article.id)
    else
      flash[:error] = Utils::Tools.get_errors_message(@article)
      redirect_to :back
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    respond_to do |format|
      format.js{
        render :js => "$('.article_tr_#{@article.id}').remove();alert('该数据已被删除');"
      }
    end 

  end



  #上传附件图片页面  iframe 里的页面
  def frame_form
    @article = Article.find_by_id  params[:id]
    @imageId =  AttachedPicture.find_by_id(params[:imageId])  if params[:imageId].present?
    @attachedpictrue =  AttachedPicture.new params[:attachedpictrue]
    render :layout => false
  end

  # iframe 里的页面
  #导步上传附件图片
  def frame_add_attachment
    @article =  Article.find_by_id(params[:id])
    @article.attached_pictures.build(params[:attached_picture])
    if @article.save
      redirect_to frame_form_admin_article_path(params[:id],:imageId => @article.attached_pictures.last.id)
    else
      redirect_to :back
    end
  end


  #删除图片
  def delete_product_image
    image = AttachedPicture.find_by_id params[:id]
    if  image.destroy
      render :js => "alert('删除成功');"
    else
      render :js => "alert('删除失败');"
    end
  end


  #删除图片
  def delete_article_image
     article = Article.find_by_id params[:id]
     article.thumb = nil
     if  article.save
     render :js => "alert('图片删除成功！');$('#article-image').remove();"
		 else
			 render :js => "alert('图片无法删除，请联系管理员')"
		 end
  end


  protected
  #设置当前模型可选栏目
  def set_channels
    model = InfoModel.where("model_name = ?", "Article").first
    @channels = model.channels.final_page.ct_desc if model.present?
  end
  
end
