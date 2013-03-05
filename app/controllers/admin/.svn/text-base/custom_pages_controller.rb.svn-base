#encoding: UTF-8
class Admin::CustomPagesController < Admin::BaseController

  #栏目自定义列表页#
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def channel_index
    channel = Channel.find_by_id(params[:id])
    @custom_pages = channel.custom_pages.ct_desc
    @custom_pages = @custom_pages.page(params[:page]).per(20)
  end

  
  #自定义列表页#
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def index
    @custom_pages = CustomPage.ct_desc
    @custom_pages = @custom_pages.page(params[:page]).per(20)
  end

  #自定义新建页
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def new
    @custom_page = CustomPage.new
    @custom_page.custom_page_content = CustomPageContent.new 
  end

  #编辑自定义
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def edit
    @custom_page = CustomPage.find(params[:id])
    @custom_page.custom_page_content  = CustomPageContent.new unless @custom_page.custom_page_content.present?
    @images = @custom_page.attached_pictures
    render :layout => false if request.headers["X-Requested-With"]
  end

  #更新自定义
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def update
    @custom_page = CustomPage.find(params[:id])
    respond_to do |format|
      @custom_page.update_attributes(params[:custom_page])
      format.js{
        render :js => "alert('保存成功')"
      }
      format.html{
        flash[:notice] = "保存成功"
        redirect_to :action => "index"
      }

    end
  end

  #添加页
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def create
    @custom_page = CustomPage.new params[:custom_page]
    @custom_page.save 
    respond_to do |format|
      format.js{
        render :js => "alert('保存成功')"
      }
      format.html{
        flash[:notice] = "保存成功"
        redirect_to :action => "index"
      }
    end
    
  end

  #栏目相关的新建
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def link_channel
    @custom_page = CustomPage.new(:channel_id=>params[:id])
    @custom_page.custom_page_contents.build
  end
end
