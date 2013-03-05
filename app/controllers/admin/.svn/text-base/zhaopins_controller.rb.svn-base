#encoding: UTF-8
class Admin::ZhaopinsController < Admin::BaseController

  
  #设置可选栏
  before_filter :set_channels ,  :oinly => [:new , :edit]
  #栏目跳转过来的页面
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def channel_index
    channel = Channel.find_by_id params[:id]
    @zhaopings = channel.zhaopins.ct_desc.page(params[:page]).per(20)
    render :layout => false if request.headers["X-Requested-With"]
  end

  #  列表页
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def index
    @zhaopings = Zhaopin.ct_desc.page(params[:page]).per(20)
  end


  # 列表页
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def search
    channel = Channel.find_by_id params[:id]
    @zhaopings = channel.zhaopins.ct_desc.page(params[:page]).per(20)
  end

  
  #编辑页
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def edit
    @zhaopin = Zhaopin.find_by_id params[:id]
    render :layout => "iframe"
  end

  #新建页
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def new
    @zhaopin = Zhaopin.new params[:zhaopin]
    render :layout => "iframe"
  end

  #添加
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def create
    @zhaopings = Zhaopin.new params[:zhaopin]
    @zhaopings.member = @member_curr   if @meber_curr
    @zhaopings.save
    respond_to do |format|
      format.js{
        render :js => "window.parent.$.jqmClose();window.parent.load_content();alert('保存成功');"
      }
      format.html{
        redirect_to admin_zhaopins_path
      }
    end
  end

  # 更新招聘信息
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def update
    @zhaopings = Zhaopin.find_by_id params[:id]
    @zhaopings.update_attributes(params[:zhaopin])
    respond_to do |format|
      format.js{
        render :js => "window.parent.$.jqmClose();window.parent.load_content();alert('保存成功');"
      }
    end
  end

  # 删除招聘信息
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def destroy
    @zhaopin = Zhaopin.find_by_id params[:id]
    @zhaopin.destroy
    respond_to do |format|
      format.js{
        render :js => "$('.zhaopin_tr_#{@zhaopin.id}').remove();alert('该行数据己被删除');"
      }
    end
  end

  protected
  #设置当前模型可选栏目
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-30
  #
  def set_channels
    model = InfoModel.where("model_name = ?", "Zhaopin").first
    @channels = model.channels.ct_desc if model.present?
  end
end
