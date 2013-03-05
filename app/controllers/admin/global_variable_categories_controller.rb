#encoding: UTF-8
class Admin::GlobalVariableCategoriesController < Admin::BaseController
  # 首页
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-28
  def index
    #分类列表
    @categories = GlobalVariableCategory.get_list
  end

  # 新建页
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-28
  def new
    @category = GlobalVariableCategory.new
  end

  # 创建分类
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-28
  def create
    @category = GlobalVariableCategory.new(params[:global_variable_category])
    @category.level = GlobalVariableCategory::LEVEL_LOWER
    @category.depth = @category.parent.present? ? @category.parent.depth + 1 : 0
    if @category.save
      flash[:success] = "添加成功！"
      redirect_to admin_global_variable_categories_path
    else
      flash.now[:error] = "添加失败，修改后请重新提交！"
      render :action => :new
    end
  end

  # 编辑页
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-28
  def edit
    begin
      @category = GlobalVariableCategory.find(params[:id])
      render :new
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "对象不存在！"
      redirect_to admin_global_variable_categories_path
    end
  end

  # 更新
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-28
  def update
    begin
      category = GlobalVariableCategory.find(params[:id])
      if category.update_attributes(params[:global_variable_category])
        category.update_attribute(:depth, category.parent.present? ? category.parent.depth + 1 : 0)
        flash[:success] = "保存成功！"
        redirect_to admin_global_variable_categories_path
      else
        flash.now[:error] = "保存失败，修改后请重新提交！"
        render :action => :new
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "对象不存在！"
      redirect_to admin_global_variable_categories_path
    end
  end

  # 删除变量
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-28
  def destroy
    begin
      @category = GlobalVariableCategory.by_level(GlobalVariableCategory::LEVEL_LOWER).find(params[:id])
      if @category.global_variables.blank?
        if @category.destroy
          flash[:success] = "变量删除成功！"
        else
          flash[:error] = "变量删除失败！"
        end
      else
        flash[:error] = "还有设置信息，分类不可删除！"
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "对象不存在！"
    rescue RuntimeError => error
      flash[:error] = error.message
    end
    redirect_to admin_global_variable_categories_path
  end

  # 排序
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-29
  def sort
    @categories = GlobalVariableCategory.by_level(GlobalVariableCategory::LEVEL_LOWER).all
    @categories.each do |category|
      category.position = params['obj'].index(category.id.to_s) + 1
      category.save
    end
    render :nothing => true
  end
end
