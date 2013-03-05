#encoding: UTF-8
class Admin::ProductsController < Admin::BaseController


  #设置可选栏目
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  before_filter :set_channels, :only => [:new, :edit, :product_content, :upload]

  # 栏目下在的产品列表页#
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def channel_index
    @product = Product.new params[:product]
    @products = Product.ct_desc
    @products = @products.where(:product_category_id => params[:id]) if params[:id]
    @products = @products.page(params[:page]).per(20)
    render :layout => false if request.headers["X-Requested-With"]
  end


  # 产品主页#
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-05-18
  #
  def index

    @product = Product.new params[:product]
    product_list = Product.ct_desc
    @products = Product.product_where(@product, product_list, params[:page], 20, params[:start_time], params[:end_time])
    render :action => "channel_index" 
  end


  #产品搜索列表页# 异步搜索返回RJS
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def search
    @channel = Channel.find_by_id params[:channel_id] if params[:channel_id]
    product_categorys = @channel.product_categorys.inject([]) { |a, v| a << v.id; a } if @channel.present?
    @products = Product.ct_desc
    @product = Product.new params[:product]
    @products = Product.product_where(@product, @products, params[:page], 20, params[:start_time], params[:end_time])
    render :layout => false if request.headers["X-Requested-With"]
  end

  #产品添加第一步添加产品基本信息
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def new
    @product = Product.new
    @categgories = ProductCategory.find_by_id(params[:category_id]) if params[:category_id].present?
    #是iframe里
    render :layout => "iframe" if params[:iframe]
  end


  #产品添加第二步 添加产品内容
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def product_content
    @product = Product.find_by_id params[:id]
    @product_content =  @product.product_content || ProductContent.new(:content => "")  
    @images = @product.attached_pictures
    #是iframe里
    render :layout => "iframe" if params[:iframe]
  end


  #产品添加第三步，上传产品小图
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def upload
    @product = Product.find_by_id params[:id]
    #是iframe里
    render :layout => "iframe" if params[:iframe]
  end


  #编辑产品
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def edit
    @product = Product.find(params[:id])
    #是iframe里
    render :layout => "iframe" if params[:iframe]
  end


  #更新产品
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def update
    @product = Product.find(params[:id])
    success = false
    Product.transaction  do 
        @product.update_attributes(params[:product])
        success = @product.save
      flash[:success] = "更新基本信息成功"
    end
      redirect_to product_content_admin_product_path(@product, :iframe => params[:iframe])  and return    if success 
      flash[:errors] = "基本信息保存失败"
      redirect_to :back
     

  end

  #内容内页提交action
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def content_create
    @product = Product.find_by_id(params[:id])
    
    @product_content = @product.build_product_content(params[:product_content])
    if  @product_content.save
      flash[:success] = "更新产品描述信息成功"
      redirect_to upload_admin_product_path(@product.id, :iframe => params[:iframe])
    else
      flash[:error] = "更新产品错误"
      redirect_to :back
    end

  end


  #保存基本信息
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def create
    @product = Product.new params[:product]
    if @product.save
      flash[:success] = "基本信息保存成功"
    else
      flash[:error] = "保存错误"
      redirect_to :back and return
    end

    #第二步跳到产品内容添加页
    redirect_to product_content_admin_product_path(@product, :iframe => params[:iframe])
  end


  #上传附件图片页面  iframe 里的页面
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def frame_form
    @product = Product.find params[:id]
    @imageId = AttachedPicture.find(params[:imageId]) if params[:imageId].present?
    @attachedpictrue = AttachedPicture.new params[:attachedpictrue]
    render :layout => false
  end


  # iframe 里的页面
  #导步上传附件图片
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def frame_add_attachment
    @product = Product.find(params[:id])
    @product.attached_pictures.build(params[:attached_picture])
    if @product.save
      redirect_to frame_form_admin_product_path(params[:id], :imageId => @product.attached_pictures.last.id)
    else
      render :back
    end
  end

  #添加附件图片第三步
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def attachment
    @product = Product.find params[:id]
    if params[:product_imgs].present? && params[:product_imgs].size > 0
      ProductAttachment.add_attachment_thumb(@product, params[:product_imgs])
      flash[:success] = "创建成功"
    end
    render :text => "<script>window.parent.$.jqmClose();window.parent.load_content();alert('保存成功');</script>"
  end


  #删除页
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def destroy
    @product = Product.find(params[:id])
    @product.destroy ? flash[:success] = "成功删除一个产品信息" : flash[:error] = "删除出错"
    respond_to do |format|
      format.js {
        render :js => "$('.product_tr_#{@product.id}').remove();alert('该数据已经被删除');"
      }
    end
  end


  # 删除图片
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def delete_attachment
    attachment = ProductAttachment.find params[:id]
    attachment.destroy
    render :text => 1
  rescue
    render :text => 0
  end


  #删除产品图片
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def delete_product_image
    image = AttachedPicture.find_by_id params[:id]
    if  image.destroy
      render :js => "alert('删除成功');"
    else
      render :js => "alert('删除失败');", :status => 404
    end
  end


  protected
  #设置当前模型可选栏目
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def set_channels
    model = InfoModel.where("model_name = ?", "Product").first
    @channels = model.channels.final_page.ct_desc if model.present?
  end


end
