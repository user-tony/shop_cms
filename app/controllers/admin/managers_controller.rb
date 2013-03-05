#encoding: UTF-8
class Admin::ManagersController < Admin::BaseController
  

  #管理员登录页面
  #
  #作者：李季
  #更新时间：2012-3-5
  def login
    unless session[:manager_id] == nil
      flash[:notice] = "您已经登录！"
      redirect_to admin_main_index_path and return
    end
    render :layout => "login"
  end
  
  #检测登录
  #
  #作者：李季
  #更新时间：2012-3-5
  def check_login
    unless params[:keyword][:password].blank?
      password = Digest::MD5.hexdigest(params[:keyword][:password])
      manager = Manager.by_login_and_password(params[:keyword][:login], password).first
      unless manager.blank?
        session[:manager_id] = manager.id
        #如果密码是admin则记录并且提示用户
        flash[:notice] = "请尽快修改默认密码" if params[:keyword][:password] == "admin"
        redirect_to admin_main_index_path
      else
        flash[:error] = "登录失败，请重新登录！"
        redirect_to login_admin_managers_path
      end
    else
      flash[:notice] = "用户名或密码不能为空，请重新输入！"
      redirect_to login_admin_managers_path
    end
  end
  
  # 管理员注销
  # 
  # 作者：李季
  # 最后更新时间:2012-3-16
  def logout
    session[:manager_id] = nil
    flash[:success] = "注销成功！"
    redirect_to login_admin_managers_path
  end
  
  # 管理员列表
  #
  # 作者：李季
  # 最后更新时间：2012-3-16
  def index
    @managers = Manager.order("id asc").where("login != 'super_admin'")
  end
  
  #管理员新建界面
  #
  #作者：李季
  #更新时间：2012-3-5
  def new
    @manager = Manager.new
  end
  
  #创建管理员
  #
  #作者：李季
  #更新时间：2012-3-5
  def create
    @manager = Manager.new(
      :login => params[:manager][:login],
      :manager_type => params[:manager][:manager_type],
      :email => params[:manager][:email]
    )
    unless params[:manager][:password].blank?
      @manager.password = Digest::MD5.hexdigest(params[:manager][:password])
    end
    unless @manager.save
      flash.now[:error] = "管理员创建失败，更改后请重新提交！"
      render new_admin_manager_path
    else
      flash[:success] = "管理员创建成功！"
      redirect_to admin_managers_path
    end
    
  end
  
  #管理员信息修改页面
  #
  #作者：李季
  #更新时间：2012-3-5
  def edit
    @manager = Manager.find(params[:id])
  end
  
  #管理员信息更新
  #
  #作者：李季
  #更新时间：2012-3-5
  def update
    @manager = Manager.find(params[:id])
    if @manager.update_attributes(
        :manager_type => params[:manager][:manager_type],
        :email => params[:manager][:email])
      flash[:success] = "管理员信息修改成功！"
      redirect_to admin_managers_path
    else
      flash.now[:error] = "管理员信息修改失败！"
      render :action => :edit
    end
  end
  
  # 当前管理员修改页面
  #
  #
  #
  def modify_password
    @manager = Manager.find(params[:id])
  end
  
  # 更新当前管理员密码
  #
  # 作者：李季
  # 最后更新时间：2012-3-10
  
  def update_password
    @manager = Manager.find(params[:id])
    unless params[:old_password].blank?
      if params[:new_password].present? and params[:new_password_confirm].present? and params[:new_password] == params[:new_password_confirm]
        
        passwd = encrypted_password(params[:old_password])
        new_passwd = encrypted_password(params[:new_password])
        if passwd == @manager.password
          if @manager.update_attributes(:password => new_passwd)
            flash[:success] = "密码修改成功！"
            session[:manager_id] = nil
            redirect_to login_admin_managers_path
          else
            flash[:error] = "密码修改失败，请重新修改！"
            redirect_to modify_password_admin_manager_path
          end
        else
          flash[:error] = "密码修改失败，请重新修改！"
          redirect_to modify_password_admin_manager_path
        end
      else
        flash[:error] = "两次输入的密码不一致，请重新输入！"
        redirect_to modify_password_admin_manager_path
      end
    else
      flash[:notice] = "密码不能为空！"
      redirect_to modify_password_admin_manager_path
    end
  end
  
  #管理员删除
  #
  #作者：李季
  #更新时间：2012-3-5
  # 删除方法优化
  # 更新时间 2012-6-20 14:42:38
  #  作者： 佟立家
  
  def destroy
    @manager = Manager.find(params[:id])
    redirect_to :back, :notice => "不能删除当前登陆用户" and return   if @manager.id == @manager_curr.id
    flash[:success] = @manager.destroy ? "管理员删除成功！" : "管理员删除失败！"
    redirect_to admin_managers_path
  end
  
  def exists_attach
    result = Manager.where(:login => params[:manager][:login]) unless params[:manager][:login].blank?
    if result.present?
      render :text => "false"
    else
      render :text => "true"
    end
  end
  
  protected
    
  def encrypted_password(password)
    return Digest::MD5.hexdigest(password)
  end
    
end
