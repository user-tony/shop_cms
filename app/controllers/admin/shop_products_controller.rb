#encoding: UTF-8
class Admin::ShopProductsController < Admin::BaseController
  #首页
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def index
    @shop_products = ShopProduct.ct_desc
    @shop_products = @shop_products.where(:shop_category_id => params[:category_id]) if params[:category_id]
    @shop_products = @shop_products.page(params[:page]).per(20)
    render :layout => false if request.headers["X-Requested-With"]
  end

  #创建页
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def new
    @root_categories = ShopCategory.parent_id(1)
    @categories = {}
    @shop_product = ShopProduct.new
    @shop_product.shop_product_type = 0
    @shop_product.product_status = 1     #默认为上架模式
    render :layout => "iframe"
  end

  #保存
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def create
    @shop_product = ShopProduct.new(params[:shop_product])
    if @shop_product.save
      flash[:success] = "创建成功"
      redirect_to :action => "edit" , :id => @shop_product.id, :anchor => "upload_img"
    else
      flash[:error] = @shop_product.errors.messages.map{|m| m[1]}.join(",")
      redirect_to :back
    end
  end

  #编辑页
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def edit
    @root_categories = ShopCategory.parent_id(1)
    @shop_product = ShopProduct.find(params[:id])
    @categories = @shop_product.shop_product_category_relations.map{|relation| relation.shop_category_id}
    #如果关联该商品的产品已经被删除 页面将不会再选择产品
    @not_product = true  unless @shop_product.product 
    #商品内容
    @product_content = @shop_product.product_content  || @shop_product.build_product_content
    @images = @shop_product.attached_pictures
    render :layout => "iframe"
  end

  #更新
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def update
    @shop_product = ShopProduct.find(params[:id])
    ShopProduct.transaction do 
     unless   @shop_product.update_attributes(params[:shop_product])
      flash[:error] = "更新失败"
      render :back and return 
     end
     old_categorids = @shop_product.shop_product_category_relations.map{|relation| relation.shop_category_id}
      new_categories = params[:categories] && params[:categories].class == Array ? params[:categories].map{|id| id.to_i} : Array.new
      #删掉取消选择的项
      @shop_product.shop_product_category_relations.where("shop_category_id in (?) AND shop_product_id = ?", old_categorids - new_categories, @shop_product.id).destroy_all
      #增加新选择的项
      (new_categories - old_categorids).each do |category_id|
        @shop_product.shop_product_category_relations.create(:shop_category_id => category_id) if category_id.to_i > 0
      end
      if @shop_product.product_content
          @shop_product.product_content.update_attributes(params[:product_content]) 
      else
          @shop_product.build_product_content(params[:product_content])
      end
      @shop_product.save
      flash[:success] = "商品内容更新成功"
    end
    redirect_to upload_admin_shop_product_path(@product,:iframe => params[:iframe])
  end

  #删除
  #
  #作者：赵晓龙
  #更新时间：2012-3-20
  def destroy
    @shop_product = ShopProduct.find(params[:id])
    succ =  @shop_product.destroy
    respond_to do |format|
      format.js{
        if succ
          render :js => "window.parent.load_content();"
        else
          render :js => "alert('删除有错误');"
        end
      }
      format.html{
        redirect_to :back
      }
    end
   
  end


  #上传附件图片页面  iframe 里的页面
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def frame_form
    @shop_product = ShopProduct.find  params[:id]
    @imageId =  AttachedPicture.find(params[:imageId])  if params[:imageId].present?
    @attachedpictrue =  AttachedPicture.new params[:attachedpictrue]
    render :layout => false
  end



  # iframe 里的页面
  #导步上传附件图片
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def frame_add_attachment
    @shop_product =  ShopProduct.find(params[:id])
    @shop_product.attached_pictures.build(params[:attached_picture])
    if @shop_product.save
      redirect_to frame_form_admin_shop_product_path(params[:id],:imageId => @shop_product.attached_pictures.last.id)
    else
      render :back
    end
  end

  #添加附件图片第二步
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def attachment
    @shop_product = ShopProduct.find params[:id]
    if params[:product_imgs].present? && params[:product_imgs].size > 0
      ProductAttachment.add_attachment_thumb(@shop_product,params[:product_imgs])
      flash[:success] =  "创建成功"
    end
    render :text => "<script>window.parent.$.jqmClose();window.parent.load_content();alert('保存成功');</script>" and return
  end

  #产品添加第三步，上传产品小图
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def upload
    @shop_product = ShopProduct.find params[:id]
    #是iframe里
    render :layout => "iframe"
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
end
