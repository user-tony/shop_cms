#encoding: UTF-8
class Member < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable,, :validatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable
  #软删除
  acts_as_paranoid

  acts_as_list
  #------------------------------关--系------------------------------------------
  #用户详细信息
  has_one :member_info, :dependent => :destroy
  # 订单
  has_many :orders, :dependent => :destroy
  #  has_one :orders, :dependent => :destroy
  #用户订单地址
  has_many :order_addresses
  #招聘信息
  has_many :zhaopins

  #验证用户名不能重复包括软删除
  validates_as_paranoid
  validates_uniqueness_of_without_deleted :login, :uniqueness => {:message => "用户名已经存在"}
  validates_uniqueness_of_without_deleted :email, :uniqueness => {:message => "邮箱已经被占用"}
  #------------------------------验--证------------------------------------------
  #验证用户名
  validates :login, :presence => {:message => "用户名不能为空！"},
    :length => {:minimum => 6, :maximum => 18, :message => "用户名长度应介于6-18!"}



  #验证用户昵称
  validates :nick_name, :presence => {:message => "昵称不能为空"},
    :length => {:minimum => 2, :maximun => 18, :message => "昵称长度应介于2-18！"}
  #验证邮箱
  validates :email, :presence => {:message => "邮件地址不能为空！"}, :uniqueness => {:message => "邮箱已经被占用！"},
    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "邮箱格式不正确"}

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :nick_name, :member_type, :email, :password, :password_confirmation, :remember_me

  #  validates_as_paranoid
  #------------------------------scope------------------------------------------
  #按照用户名模糊匹配
  scope :by_login, lambda { |login| where("login like ?", "%#{login}%") }
  #按照昵称模糊匹配
  scope :by_nick, lambda { |nick| where("nick_name like ?", "%#{nick}%") }


  #查询今天登陆的用户
  scope :curren_day_member, where("TO_DAYS(NOW()) = ?", "TO_DAYS(last_sign_in_at)")

  mango_liquid

  #------------------------------cache------------------------------------------

  def self.cache_by_id(id)
    Rails.cache.fetch("member_#{id}") { find(id) }
  end


  #------------------------------类方法------------------------------------------

  #------------------------------实例方法-------------------------------------------


end
