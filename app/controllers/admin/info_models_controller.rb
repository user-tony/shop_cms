#encoding: UTF-8
class Admin::InfoModelsController < Admin::BaseController
  
  cache_sweeper :info_model_sweeper,:only => [:update, :create, :destroy]

  # 首页
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-7
  def index
    @list = InfoModel.cache_all
  end

  # 添加系统模型
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-7
  def new
    @info_model = InfoModel.new
  end

  # 修改系统模型
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-7
  def edit
    @info_model = InfoModel.cache_by_id(params[:id])
  end

  # 修改系统模型
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-7
  def create
    params[:info_model][:model_name] = params[:info_model][:model_name].strip
    if InfoModel.where(:model_name => params[:info_model][:model_name]).count(1)>0
      flash[:notice] = "rails模型名重复。"
      redirect_to :back and return
    end
    unless Cms::class_const(params[:info_model][:model_name])
      flash[:error] = "模型不存在。"
      redirect_to :back and return 
    end
    info_model = InfoModel.new params[:info_model]
    info_model.save ? flash[:success] = "系统模型添加成功。" : flash[:error] = "添加失败。"
    redirect_to admin_info_models_path
  end

  # 更新系统模型
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-7
  def update
    params[:info_model][:model_name] = params[:info_model][:model_name].strip
    if InfoModel.where(["id <> ? AND model_name = ?", params[:id], params[:info_model][:model_name]]).count(1)>0
      flash[:notice] = "rails模型名重复。"
      redirect_to :back and return
    end
    unless Cms::class_const(params[:info_model][:model_name])
      flash[:error] = "模型不存在。"
      redirect_to :back and return
    end
    info_model = InfoModel.cache_by_id(params[:id])
    info_model.update_attributes(params[:info_model]) ? flash[:success] = "系统模型修改成功。" : flash[:error] = "修改失败。"
    redirect_to admin_info_models_path
  end

  # 删除
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-7
  def destroy
    info_model = InfoModel.cache_by_id(params[:id])
    info_model.destroy ? flash[:success] = "系统模型删除成功。" : flash[:error] = "删除失败。"
    redirect_to admin_info_models_path
  end
  
end
