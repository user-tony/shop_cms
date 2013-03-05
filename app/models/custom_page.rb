#encoding: UTF-8
class CustomPage < ActiveRecord::Base

  #从属于一个栏目
  belongs_to :channel
  #自定义内容
  has_one :custom_page_content,   :dependent => :destroy

  #软删除
  acts_as_paranoid

  #注册模板字段
  mango_liquid

 
  #添加一个关联属性-- 产品详细信息
  accepts_nested_attributes_for :custom_page_content
  #图片附件
  has_many :attached_pictures,    :dependent => :destroy, :as  => "item"
  #倒序查询
  scope :ct_desc , order("created_at DESC")
  #正序查询
  scope :ct_asc , order("created_at ASC")


  #--------------------验证---------------------
  #自定义名URL不能为空
  #  validates :custom_url,   :presence => {:message => "自定义URL地址不能为空"}
  validates :channel_id,   :presence => {:message => "栏目ID不能为空"}




end
