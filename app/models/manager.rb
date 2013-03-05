#encoding: UTF-8
class Manager < ActiveRecord::Base
  #------------------------------载-入-类----------------------------------------
  
  

  #------------------------------插---件-----------------------------------------
  #软删除
  acts_as_paranoid
  acts_as_list
  
  
  #------------------------------关---系-----------------------------------------
  
  
  
  #------------------------------常---量-----------------------------------------
  
  
  
  #------------------------------scope------------------------------------------
  #根据用户名和密码查询
  scope :by_login_and_password, lambda{|login,password| where("login=? and password=?", login, password)}
  
  #------------------------------验---证-----------------------------------------
  #登录名验证
  validates :login, :presence => {:message => "用户名不能为空！"}, :uniqueness => {:message => "用户名已经存在！"},
    :length => {:minimum => 5, :maximum => 18, :message => "用户名长度介于6-18！"}
  #密码验证
  validates :password, :presence => {:message => "密码不能为空！"}
  #邮件验证
  validates :email, :presence => {:message => "邮件地址不能为空！"},
    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message  => "邮箱格式不正确"}
 
  
#  validates_as_paranoid
  #------------------------------类-方-法----------------------------------------
  
  
  #------------------------------实例方法-----------------------------------------
  
  # 密码加密
  #
  # 作者：李季
  # 最后更新时间：2012-3-10
  # 
  # ==== 参数
  # *<tt>password</tt> - 密码
  def encrypted_password(password)
    Digest::MD5.hexdigest(password)
  end
  
end
