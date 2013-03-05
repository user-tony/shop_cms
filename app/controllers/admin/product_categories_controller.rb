#encoding: UTF-8
class Admin::ProductCategoriesController < Admin::BaseController

  #设置可选栏
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  before_filter :set_channels ,  :only => [:new_child , :edit]
  #
  #产品分类列表页#
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def index
    @product_categories = ProductCategory.order("id DESC").page(params[:page]).per(20)
  end

  #产品分类新建页
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def new_child
    @product_category = ProductCategory.new(:parent_id => params[:id])
    render :layout => false if request.headers["X-Requested-With"]
    
  end
 
  #编辑产品分类
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def edit
    @product_category = ProductCategory.find(params[:id])
    render :layout => false if request.headers["X-Requested-With"]
  end

  #更新产品分类
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def update
    @product_category = ProductCategory.find(params[:id])
    respond_to do |format|
      success =   @product_category.update_attributes(params[:product_category])
      format.js {
        if success
          render :js => "alert('产品更新成功')"
        else
          render :js => "alert('产品更新失败')"
        end
      }
      format.html{
        if success
          flash[:success] = "更新成功"
        else
          flash[:success] = "更新失败请稍后重试"
        end
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
    producte_category = ProductCategory.new params[:product_category]
     respond_to do |format|
      success =   producte_category.save
      format.js {
        if success
          render :js => "alert('产品添加成功')"
        else
          render :js => "alert('产品添加失败')"
        end
      }
      format.html{
        if success
          flash[:success] = "添加成功"
        else
          flash[:error] = Utils::Tools.get_errors_message(producte_category)
        end
        redirect_to admin_products_path
      }
    end
  end
  #删除页
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def destroy
    producte_category = ProductCategory.find(params[:id])
    producte_category.destroy ?  flash[:success] = "成功删除一条分类" : flash[:error] = Utils::Tools.get_errors_message(producte_category)
    redirect_to admin_products_path
  end
  
  
  #准备左侧树信息F
  def tree_info
    tree = []
    category_id = params[:id]
    if category_id
      category = ProductCategory.where("parent_id = ?" ,category_id)
    else
      category = ProductCategory.where("id = ?" ,1)
    end
    category.each do |cate|
      url = ""
      url = "/admin/products/#{cate.id}/channel_index" if cate.id

      tree << {:id => cate.id, :name => cate.name, :isParent => cate.parent_node, :path_customize => cate.path_customize, :loadURL => url }
    end
    render :json => tree
  end
  
  
  protected
  #设置当前模型可选栏目
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def set_channels
    model = InfoModel.where("model_name = ?", "Product").first
    @channels = model.channels.ct_desc if model.present?
  end

  
end
