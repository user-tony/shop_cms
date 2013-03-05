#encoding: UTF-8
class Admin::MembersController < Admin::BaseController
  cache_sweeper :member_sweeper,:only => [:update, :create, :destroy]

  before_filter :prepare_method, :only => [:show, :edit, :update, :destroy]
  

  #后台用户列表
  #
  #作者：李季
  #更新时间：2012-3-20
  def index
    @members = Member.order("id asc")
    @members = @members.by_login(params[:login]) unless params[:login].blank?
    @members = @members.by_nick(params[:nick_name]) unless params[:nick_name].blank?
    @members = @members.page(params[:page]).per(20)
  end
  
  #后台用户显示页面
  #
  #作者：李季
  #更新时间：2012-3-6
  def show
    @member_info = @member.member_info
    @order_addresses = @member.order_addresses
  end
  
  #后台用户修改页面
  #
  #作者：李季
  #更新时间：2012-3-6
  def edit
    @member_info = @member.member_info unless @member.member_info.blank?
  end

  #后台用户信息更新
  #
  #作者：李季
  #更新时间：2012-3-6
  def update
    if @member.update_attributes(
        :email => params[:member][:email],
        :nick_name => params[:member][:nick_name],
        :member_type => params[:member][:member_type]
      )
      if @member.member_info.blank? 
        unless params[:member_info].blank?
          if @member.create_member_info(params[:member_info])
            redirect_to admin_member_path
            flash[:success] = "用户详细信息更新成功！"
          else
            flash[:error] = "用户信息更新失败，修改后请重新提交！"
            redirect_to edit_admin_member_path(params[:id])
          end
        else
          flash[:success] = "用户基本信息更新成功！"
          redirect_to admin_member_path
        end
      else
        unless params[:member_info][:name].blank?
          if @member.member_info.update_attributes(params[:member_info])
            flash[:success] = "用户详细信息更新成功！"
            redirect_to admin_member_path(params[:id])
          else
            flash[:error] = "用户详细信息更新失败，请修改后继续提交！"
            render :action => "edit"
          end
        else
          flash[:error] = "姓名不能为空！"
          render :action => "edit"
        end
      end
    else
      flash[:error] = "用户基本信息更新失败，请修改后继续提交！"
      render :action => "edit"
    end
  end
  
  #后台用户删除
  #
  #作者：李季
  #更新时间：2012-3-6
  def destroy
    if @member.destroy
      redirect_to admin_members_path, :notice => "用户删除成功！"
    else
      redirect_to admin_members_path, :notice => "用户删除失败！"
    end
  end
  
  protected
  
  #
  def prepare_method
    @member = Member.cache_by_id(params[:id])
  end
end
