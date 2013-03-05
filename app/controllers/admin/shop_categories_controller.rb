#encoding: UTF-8
class Admin::ShopCategoriesController < Admin::BaseController


  #首页 异步
  #
  #作者：佟立家
  #更新时间：2012-04-19
  def index
    @shop_categories = ShopCategory.page(params[:page]).per(20)
  end

  #添加分类页面 异步
  #
  #作者：佟立家
  #更新时间：2012-04-19
  def new_category
    @shop_category = ShopCategory.new
    @shop_category.parent_id  = params[:id] if params[:id]
    render  :layout => nil
  end

  #商品分类显示页 异步
  #
  #作者：佟立家
  #更新时间：2012-04-19
  def show
    render  :layout => "iframe"
  end

  #商品分类编辑页 异步
  #
  #作者：佟立家
  #更新时间：2012-04-19
  def edit
    @shop_category = ShopCategory.find params[:id]
    render  :layout => nil
  end



  #商品分类新建页 异步
  #
  #作者：佟立家
  #更新时间：2012-04-19
  def create
    @shop_category  = ShopCategory.new params[:shop_category]
    if @shop_category.save
      flash[:success] = "商品分类保存成功"
     redirect_to admin_shop_products_path
    else
      flash[:errors] = "商品分类保存失败"
      redirect_to :back
    end
  end


  #商品分类更新页 异步
  #
  #作者：佟立家
  #更新时间：2012-04-19
  def update
    @shop_category = ShopCategory.find params[:id]
    if  @shop_category.update_attributes(params[:shop_category])
      flash[:success] = "商品分类更新成功"
      redirect_to admin_shop_products_path
    else
      flash[:errors] = "商品分类更新失败"
      redirect_to :back
    end
  end


  #商品分类删除页 异步
  #
  #作者：佟立家
  #更新时间：2012-04-19
  def destroy
    @shop_category = ShopCategory.find params[:id]
      if  @shop_category.destroy
          flash[:success] = "商品分类删除成功"
          redirect_to admin_shop_products_path
      else
         flash[:errors] = "商品分类删除失败"
         redirect_to :back
      end
       
  end



  #准备左侧树信息
  #
  #作者：佟立家
  #更新时间：2012-04-19
  def tree_info
    tree = []
    if category_id  = params[:id]
      category = ShopCategory.where("parent_id = ?" ,category_id)
    else
      category = ShopCategory.where("id = ?" ,1)
    end
    category.each do |cate|
      url = ""
      url = "/admin/shop_products?category_id=#{cate.id}" if cate.id
      tree << {:id => cate.id, :name => cate.name, :isParent => cate.parent_node, :path_customize => cate.path_customize, :loadURL => url }
    end
    render :json => tree
  end

 
  
end
