#encoding: UTF-8
class MemberInfo < ActiveRecord::Base
  
  #软删除
  acts_as_paranoid
  acts_as_list
  #------------------------------关--系------------------------------------------
  #用户基本信息
  belongs_to :member
  #用户地址
  belongs_to :area_country
  
  #------------------------------验--证------------------------------------------
  #用户姓名验证
  validates :name, :presence => {:message => "姓名不能为空！"},
    :length => {:minimum => 2, :maximum => 50, :message => "姓名长度应介于2-50！"}
#  validates_as_paranoid
  
  #------------------------------条--件------------------------------------------
  
  
  #------------------------------方--法------------------------------------------

end
