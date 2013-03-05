#encoding: UTF-8
class MemberInfosController < BaseController
  
  layout "member"
  
  before_filter :authenticate_member! ,:except => [:judge_member,:judge_useremail]
  
  # 添加用户详细信息
  #
  # 作者：李季
  # 更新时间：2012-04-20 
  def new
    @member_info = current_member.build_member_info
  end
  
  # 创建用户详细信息
  #
  # 作者：李季
  # 更新时间：2012-04-20 
  def create
    @member_info = current_member.build_member_info(:name => params[:member_info][:name],
      :gender => params[:member_info][:gender],
      :birthday => params[:member_info][:birthday],
      :tel => params[:member_info][:tel],
      :address => params[:member_info][:address],
      :description => params[:member_info][:description]
    )
    if @member_info.save
      flash[:success] = "添加成功！"
      redirect_to :root
    else
      flash[:error] = "添加失败，修改后重新提交！"
      render :action => :new
    end
    
  end
  
  # 修改用户详细信息页
  #
  # 作者：李季
  # 更新时间：2012-04-20 
  def edit_info
    if current_member.member_info.present?
    @member_info = current_member.member_info
    else
      flash[:error] = "您的详细信息不存在，请您补全！"
      redirect_to new_member_info_path
    end
  end
  
  # 更新用户详细信息
  #
  # 作者：李季
  # 更新时间：2012-04-20 
  def update_info
    @member_info = current_member.member_info
    if @member_info.update_attributes(:name => params[:member_info][:name],
        :gender => params[:member_info][:gender],
        :birthday => params[:member_info][:birthday],
        :tel => params[:member_info][:tel],
        :address => params[:member_info][:address],
        :description => params[:member_info][:description]
      )
      flash[:success] = "修改成功！"
      redirect_to :root
    else
      flash[:error] = "修改失败，修改后重新提交！"
      render :action => :edit
    end
    
  end

  # 判断用户名是否重复
  #
  # 作者：吴晶
  # 更新时间：2012-06-05
  def judge_member

    member = Member.where("login = ? ",params[:member][:login]).first
    if member.present?
      render :text => false
    else
      render :text => true
    end
  end

  # 判断邮件地址是否存在
  #
  # 作者：吴晶
  # 更新时间：2012-06-05
  def judge_useremail
 
    member = Member.where("email = ? ",params[:member][:email]).first
    if member.present?
      render :text => false
    else
      render :text => true
    end
  end
end
