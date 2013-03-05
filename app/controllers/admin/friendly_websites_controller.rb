#encoding: UTF-8
class Admin::FriendlyWebsitesController < Admin::BaseController
  
  before_filter :prepare_data, :only => [:show, :edit, :update, :destroy]
  cache_sweeper :friendly_website_sweeper,:only => [:update, :create, :destroy]

  
  # 友情链接首页
  # 作者: 李季 
  # 
  # 最后更新时间: 2012-3-7
  def index
    @websites = FriendlyWebsite.cache_all
  end
  
  # 添加友情链接页
  # 作者: 李季 
  # 
  # 最后更新时间: 2012-3-6
  def new
    @website = FriendlyWebsite.new(:website_url => "http://")
  end
  
  # 创建友情链接
  # 作者: 李季 
  # 
  # 最后更新时间: 2012-3-6
  def create
    @website = FriendlyWebsite.new(
      :name => params[:website][:name],
      :website_url => params[:website][:website_url],
      :description => params[:website][:description]
    )
    if @website.save
      flash[:success] = "友情链接保存成功！"
      redirect_to admin_friendly_websites_path
    else
      flash.now[:error] = "友情链接保存失败失败，修改后请重新提交！"
      render new_admin_friendly_website_path
    end
  end
  
  # 友情链接修改页面
  # 作者: 李季 
  # 
  # 最后更新时间: 2012-3-6
  def edit
  end
  
  # 友情链接更新
  # 作者: 李季 
  # 
  # 最后更新时间: 2012-3-6
  def update
    if @website.update_attributes(
        :name => params[:website][:name],
        :website_url => params[:website][:website_url],
        :description => params[:website][:description]
      )
      flash[:success] = "友情链接修改成功！"
      redirect_to admin_friendly_websites_path
    else
      flash.now[:error] = "友情链接修改失败！"
      render :action => :edit
    end
  end
  
  # 友情链接删除
  # 作者: 李季 
  # 
  # 最后更新时间: 2012-3-7
  def destroy
    if @website.destroy
      flash[:success] = "友情链接删除成功！"
      redirect_to admin_friendly_websites_path
    else
      flash[:error] = "友情链接删除失败！"
      redirect_to admin_friendly_websites_path
    end
  end
  
  protected
  
  def prepare_data
    @website = FriendlyWebsite.find(params[:id])
  end
  
end
