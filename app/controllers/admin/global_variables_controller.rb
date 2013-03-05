#encoding: UTF-8
class Admin::GlobalVariablesController < Admin::BaseController 
  before_filter :prepare_data, :only => [:edit, :show,:update, :delete_var]
  
  # 全局变量首页
  #
  # 作者：李季
  # 更新时间：2012-3-9
  def index
    #分类列表
    @categories = GlobalVariableCategory.by_parent_id(0).where("level >= ?", GlobalVariableCategory::LEVEL_NORMAL)
  end
  
  # 新建变量页面
  #
  # 作者：李季
  # 更新时间：2012-3-9
  def new
    @variable = GlobalVariable.new(:global_variable_category_id => params[:global_variable_category_id])
  end
  
  # 创建变量
  #
  # 作者：李季
  # 更新时间：2012-3-7
  def create
    @variable = GlobalVariable.new(params[:global_variable])
    if @variable.save
      GlobalVariable.global_var
      flash[:success] = "变量添加成功！"
      redirect_to admin_global_variables_path
    else
      flash.now[:error] = "变量添加失败，修改后请重新提交！"
      render :action => :new
    end
  end
  
  # 添加图片
  #
  # 作者：李季
  # 更新时间： 2012-3-14
  def new_image
    variable = GlobalVariable.find(params[:id])
    @attrachment = variable.build_global_variable_attrachment
    render :layout => "iframe"
  end
  
  # 上传图片
  # 
  # 作者：李季
  # 更新时间： 2012-3-14
  def create_image
    variable = GlobalVariable.find(params[:id])
    @attrachment = variable.build_global_variable_attrachment(params[:attrachment])
    if @attrachment.save
      flash[:success] = "附件添加成功！"
      redirect_to edit_image_admin_global_variable_path(params[:id])
    else
      flash.now[:error] = "附件添加失败，修改后请重新提交！"
      render :action => :new_image, :layout => nil
    end
  end
  
  # 修改图片
  #
  # 作者：李季
  # 更新时间：2012-3-14
  def edit_image
    variable = GlobalVariable.find(params[:id])
    @attrachment = variable.global_variable_attrachment
    render :layout => "iframe"
  end
  
  # 更新图片
  #
  # 作者：李季
  # 更新时间：2012-3-14
  def update_image
    variable = GlobalVariable.find(params[:id])
    @attrachment = variable.global_variable_attrachment
    
    if @attrachment.update_attributes(params[:attrachment])
      flash.now[:success] = "图片修改成功！"
    else
      flash.now[:error] = "图片修改失败，修改后请重新提交！"
    end
    render :action => "edit_image" , :layout => nil
  end

  # 更新变量
  #
  # 作者：李季
  # 更新时间：2012-3-9
  def update_all
    GlobalVariable.transaction do
      params[:variable].each do |var|
        variable = GlobalVariable.find_by_id(var[1][:id])
        content = var[1][:content].to_s.strip
        unless variable.update_attributes(
            :id => var[1][:id],
            :content => content)
          redirect_to admin_global_variables_path and return
        end
      end
      flash[:success] = "所有变量更新成功！"
    end
    $cms_global_variable = GlobalVariable.global_var
    redirect_to admin_global_variables_path
  end
  
  # 删除变量
  #
  # 作者：李季
  # 更新时间：2012-3-9
  def delete_var
    if @variable.destroy
      $cms_global_variable = GlobalVariable.global_var
      flash[:success] = "变量删除成功！"
      redirect_to admin_global_variables_path
    else
      flash[:error] = "变量删除失败！"
      redirect_to admin_global_variables_path
    end
  end
  
  # 键名验证
  #
  # 作者：李季
  # 最后更新时间：2012-3-16
  def exists_attach
    result = GlobalVariable.where(:key_name => params[:variable][:key_name]) unless params[:variable][:key_name].blank?
    if result.present?
      render :text => "false"
    else
      render :text => "true"
    end
  end

  # 编辑页
  #
  # 作者：赵晓龙
  # 更新时间：2012-5-11
  def edit
    redirect_to admin_global_variables_path and return  if @variable.global_variable_category.level = GlobalVariableCategory::LEVEL_NORMAL
    render :new
  end

  # 更新
  #
  # 作者：赵晓龙
  # 更新时间：2012-5-11
  def update
    if @variable.update_attributes(params[:global_variable])
      $cms_global_variable = GlobalVariable.global_var
      flash[:success] = "保存成功！"
      redirect_to admin_global_variables_path
    else
      flash.now[:error] = "变量保存失败，修改后请重新提交！"
      render :action => :new
    end
  end
  
  protected
  # 准备数据
  def prepare_data
    @variable = GlobalVariable.find_by_id(params[:id])
  end
  
end
