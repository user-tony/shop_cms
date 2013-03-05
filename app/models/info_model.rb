#encoding: UTF-8
class InfoModel < ActiveRecord::Base

  #模型状态键值对
  INFO_MODEL_NAME = [["商城", 'ShopProduct'], ["文章", 'Article'], ["招聘", 'Zhaopin'], ["产品", 'Product'], ["订单", 'Order'], ["留言", 'Answer'],["用户", 'Member']]
  INFO_MODEL_STATUS = { false => "不可用", true => "可用"}
  
  #倒序scope
  scope :ct_desc, order("created_at desc")
  #正序scope
  scope :ct_acs, order("created_at asc")

  #多个栏目
  has_many :channels
  has_many :template_categories

  mango_liquid
  
  #模板映射方法
  def to_liquid
    self
  end
  #-----------------------------cache-------------------------------------------
  def self.cache_all
    Rails.cache.fetch("info_model_all") {ct_desc.all}
  end
  
  def self.cache_by_id(id)
    Rails.cache.fetch("info_model_#{id}") { find(id) }
  end


  # 根据当前模型返回模版
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-15
  #
  #
  # ==== 返回
  #    Template
  def get_templates
    result = []
    self.template_categories.each do |category|
      result << (Template.select("id,name").where("template_category_id = ?", category.id) << category.type_id)
    end
    result
  end

    # 根据当前模型返回模版  添加栏目时自动选择该模版
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-15
  #
  #<<tt>> type_id <<tt>>   模版类型  【栏目、列表、内容】
  #
  # ==== 返回
  #    Template
  def self.get_channel_templates(type_id)
    first.template_categories.where("type_id = ?",type_id).first.templates.select("id,name")
  end



  
  
end
