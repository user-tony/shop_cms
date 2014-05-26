#encoding: UTF-8
class Admin::ChannelsController < Admin::BaseController

  cache_sweeper :channel_sweeper, :only => [:update, :create, :destroy]

  # 方法作用描述:
  # 后台栏目列表页
  def index
    @channels = Channel.page(params[:page]).per(20)
  end

  # 方法作用描述:
  # 后台栏目创建页
  def new_child
    @channel = Channel.new(:parent_id => params[:id])
    render :layout => false if request.headers["X-Requested-With"]
  end

  # 方法作用描述:
  def create
    channel = Channel.new(params[:channel])
    respond_to do |format|
      CustomPage.transaction do
        channel.template_id_index ||= 0
        channel.template_id_list ||= 0
        channel.template_id_detail ||= 0

        InfoModel.where("model_name in (?)", ["ShopProduct", "Product"]).each do |info_model|
          
          if info_model.id == channel.info_model_id.to_i 
            if Channel.where("info_model_id = ? ", channel.info_model_id.to_i).count >= 1
              #对应的商城和产品系统只能添加一个栏目
              flash[:error]  = "该“#{info_model.name}系统”对应的栏目已存在"
              redirect_to :back and return
            end
          end
        end


        if channel.save
          if channel.single_page
            custom_page = CustomPage.create(:channel_id => channel.id)
            redirect_to edit_admin_custom_page_path(custom_page)
            return
          elsif channel.template_id_index+channel.template_id_list+channel.template_id_detail == 0
            channel.update_attributes(channel.template_id_by_model)
          end
          redirect_to link_channel_admin_custom_page_path(channel.id) and return if channel.single_page == 1
          format.html { flash[:success] = "创建成功"; redirect_to admin_channels_path }
        else
          format.html { flash[:error] = channel.errors.messages.map { |m| m[1] }.join(","); redirect_to new_child_admin_channel_path(:id => params[:channel][:parent_id]) }
        end
      end
    end
  rescue
    raise $!
  end

  # 方法作用描述:
  # 后台栏目编辑页
  def edit
    @channel = Channel.find params[:id]
    render :layout => false if request.headers["X-Requested-With"]
  end

  # 方法作用描述:
  # 后台栏目修改
  def update
    channel = Channel.find params[:id]
    channel.template_id_index ||= 0
    channel.template_id_list ||= 0
    channel.template_id_detail ||= 0
    respond_to do |format|
      if channel.update_attributes(params[:channel])
        if channel.single_page 
          if channel.custom_page.present?
            custom_page = channel.custom_page
            redirect_to edit_admin_custom_page_path(custom_page) and return
          else
            custom_page = CustomPage.create(:channel_id => channel.id)
            redirect_to edit_admin_custom_page_path(custom_page) and return 
          end
        end
        format.html { flash[:success] = "更新成功"; redirect_to admin_channels_path }
      else
        format.html { flash[:error] = channel.errors.messages.map { |m| m[1] }.join(","); render :edit }
      end
    end
  end

  # 方法作用描述:
  # 后台栏目删除
  #
  # 作者:郭金平
  #
  # 最后更新时间: 2012-3-8
  def destroy
    channel = Channel.find_by_id(params[:id])
    channel.destroy
    respond_to do |format|
      format.html { flash[:success] = "删除成功"; redirect_to admin_channels_path }
    end
  end

  # 方法作用描述:
  # 异步验证字段唯一性
  #
  # 作者:郭金平
  #
  # 最后更新时间: 2012-3-14
  def exists_attach

    if params[:channel_id]
      result = Channel.where(:path_customize => params[:channel][:path_customize].strip).where("id != ?", params[:channel_id]).count(1) if !params[:channel][:path_customize].blank?
    else
      result = Channel.where(:path_customize => params[:channel][:path_customize].strip).count(1) if !params[:channel][:path_customize].blank?
    end
    render :text => (result>0 ? "false" : "true")
  end
  
  # 方法作用描述:
  #     准备左侧树信息
  #
  # 作者:郭金平
  #
  # 最后更新时间: 2012-3-14
  def tree_info
    tree = []
    channel_id = params[:id]
    if channel_id
      channel = Channel.where("parent_id = ?", channel_id)
    else
      channel = Channel.where("id = ?", 1)
    end
    channel.each do |ch|
      url = "/admin/#{ch.info_model.model_name.downcase}s/#{ch.id}/channel_index" if ch.final_page
      url = "/admin/custom_pages/#{ch.custom_page.id}/edit" if ch.single_page
      tree << {:id => ch.id, :name => ch.name, :isParent => !(ch.single_page||ch.final_page), :path_customize => ch.path_customize, :loadURL => url}
    end
    render :json => tree
  end

  # 方法作用描述:
  #    添加栏目--选择模型后,动态加载模版信息
  #
  # 作者:佟立家
  #
  # 最后更新时间: 2012-6- 16
  def template_json_info
    info_model =  InfoModel.find_by_id  params[:id]
    render :json => info_model.get_templates.to_json
  end


end
