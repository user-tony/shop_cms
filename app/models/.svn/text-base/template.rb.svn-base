#encoding: UTF-8
class Template < ActiveRecord::Base

  #模板类型键值对
  TEMPLATE_TYPE = {
    :index_type => 1,                #首页
    :channel_type => 2,              #栏目
    :list_type => 3 ,                #列表
    :content_type => 4 ,             #显示
    :single_type => 7,               #单页
    :other_type => 5,                #其它
    :partil_type  => 6                #片段
  }

  #找不到模版时提示
  NOT_TEMP0LATE_MESSAGE = "没有找到对应模板"

  #倒序scope
  scope :ct_desc, order("created_at desc")
  #正序scope
  scope :ct_asc, order("created_at asc")
  #获取对应模型
  scope :get_model_type, lambda { |a| where(:info_model_id => a) }
  #根据模版英文名称查找模版
  scope :get_template_name, lambda { |a| where(:template_name => a) }

  #首页模板
  scope :template_list, lambda {|type_id| where("template_type = ?", type_id)}

  #从属于某个模型
  belongs_to :info_model
  #属于某个模版分类
  belongs_to :template_category




  
end