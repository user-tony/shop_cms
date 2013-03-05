#encoding: UTF-8
class Admin::ServiceCategoriesController < Admin::BaseController
  #序列号管理首页
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def index
    @service_category = ServiceCategory.new

    @categories = ServiceCategory.order("id asc")
    @categories = @categories.page(params[:page]).per(20)
  end

  #新建
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def new
    @service_category = ServiceCategory.new
  end

  #编辑
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def edit
    @service_category = ServiceCategory.find_by_id(params[:id])
    render :new
  end

  #添加
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def create
    @service_category = ServiceCategory.new params[:service_category]
    if  @service_category.save
      flash[:success] = "添加成功！"
      redirect_to admin_service_categories_path
    else
      flash[:error] = @service_category.errors.messages.map{|m| m[1]}.join(",")
      redirect_to :back
    end
  end

  #更新
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def update
    service_category = ServiceCategory.find_by_id(params[:id])
    service_category.update_attributes(params[:service_category])
    flash[:success] = "修改成功！"
    redirect_to admin_service_categories_path
  end

  #删除
  #
  #作者：赵晓龙
  #更新时间：2012-05-23
  def destroy
    service_category = ServiceCategory.find(params[:id])
    if service_category.service_verifies.size == 0
      service_category.destroy
      flash[:success] = "删除成功！"
    else
      flash[:error] = "还有序列号，分类不可删除！"
    end
    redirect_to admin_service_categories_path
  end
end