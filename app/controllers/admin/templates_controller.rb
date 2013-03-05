#encoding: UTF-8
class Admin::TemplatesController < Admin::BaseController

  cache_sweeper :template_sweeper,:only => [:update, :create, :destroy]

  # 首页
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-6
  def index
    @template_categories  = TemplateCategory.ct_desc
    @template_categories = @template_categories.where("group_id = ?" , params[:type].to_i) if params[:type ] && params[:type].to_i != 0
  end

  # 添加模板
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-6
  def new
    @template = Template.new
    @template.template_category_id = params[:id]  if params[:id]
  end

  # 修改模板
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-6
  def edit
    @template = Template.find params[:id]
  end

  # 修改模板
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-6
  def create
    template = Template.new params[:template]
    template.save ? flash[:success] = "模板添加成功。" : flash[:error] = "添加失败。"
    redirect_to admin_templates_path
  end

  # 更新模板
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-6
  def update
    template = Template.find params[:id]
    p params[:template_category]
    p params[:template]
    template.update_attributes(params[:template]) ? flash[:success] = "模板修改成功。" : flash[:error] = "修改失败。"
    redirect_to edit_admin_template_path(template)
  end

  # 删除
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-7
  def destroy
    template = Template.find params[:id]
    template.destroy ? flash[:success] = "模板删除成功。" : flash[:error] = "删除失败。"
    redirect_to admin_templates_path
  end

  # 设置默认模板
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-13
  def default_template
    template = Template.find params[:id]
    Template.transaction do
      if template.update_attribute(:template_status, true)
        flash[:success] = "（#{template.name}）设置为默认模板。"
      else
        flash[:error] = "模板设置默认失败。"
      end
      Template.update_all({:template_status => false}, ["template_type = ? and id <> ?", template.template_type, template.id])
    end
    redirect_to admin_templates_path
  end

  # 分类显示列表页
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-06-08
  def list
    @category = TemplateCategory.find_by_id(params[:id])
    @template_list = @category.templates.ct_desc.page(params[:page]).per(20)
  end

end
