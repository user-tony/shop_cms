#encoding: UTF-8
class Admin::ShopPackagesController < Admin::BaseController
  #首页
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def index
    @shop_packages = ShopPackage.ct_desc
    @shop_packages = @shop_packages.page(params[:page]).per(20)
  end

  #创建页
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def new
    @shop_package = ShopPackage.new
    @shop_package.product_contents.build
    @images = []
  end

  #保存
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def create
    shop_product_ids = params[:shop_product_ids].split(',')
    if shop_product_ids.blank?
      flash[:error] = "请选择商品"
      redirect_to :action => "new" and return
    end
    shop_package = ShopPackage.new(params[:shop_package])
    if shop_package.save
      ShopPackage.transaction do
        shop_package.update_products(shop_product_ids)
      end
      flash[:success] = "创建成功"
      redirect_to :action => "index"
    else
      flash[:error] = shop_package.errors.messages.map{|m| m[1]}.join(",")
      redirect_to :back
    end
  end

  #编辑页
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def edit
    @shop_package = ShopPackage.find(params[:id])
    @images = @shop_package.attached_pictures
  end

  #更新
  #
  #作者：赵晓龙
  #更新时间：2012-3-13
  def update
    @shop_package = ShopPackage.find(params[:id])
    if @shop_package.update_attributes(params[:shop_package])
      flash[:success] = "编辑成功"
      redirect_to :action => "index"
    else
      flash[:error] = @shop_package.errors.messages.map{|m| m[1]}.join(",")
      redirect_to :back
    end
  end

  #删除
  #
  #作者：赵晓龙
  #更新时间：2012-3-20
  def destroy
    @shop_package = ShopPackage.find(params[:id])
    @shop_package.destroy ?  flash[:success] = "删除成功" : flash[:error] =  @shop_package.errors.messages.map{|m| m[1]}.join(",")
    redirect_to :back
  end
  
  
  #上传附件图片页面  iframe 里的页面
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def frame_form
    @shop_package = ShopPackage.find  params[:id]
    @imageId =  AttachedPicture.find_by_id(params[:imageId])  if params[:imageId].present?
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
    @shop_package =  ShopPackage.find(params[:id])
    @shop_package.attached_pictures.build(params[:attached_picture])
    if @shop_package.save
      redirect_to frame_form_admin_shop_package_path(params[:id],:imageId => @shop_package.attached_pictures.last.id)
    else
      render :back
    end
  end



end
