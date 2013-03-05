#encoding: UTF-8
class FriendlyWebsite < ActiveRecord::Base
  #------------------------------载-入-类----------------------------------------
  
  

  #------------------------------插---件-----------------------------------------
  #软删除
  acts_as_paranoid
  acts_as_list
  mango_liquid
  #------------------------------关---系-----------------------------------------
  
  
  
  #------------------------------常---量-----------------------------------------
  
  
  
  #------------------------------scope------------------------------------------
  #根据名称模糊匹配
  scope :by_name, lambda{|name| where("name like ?", "%#{name}%")}
  #根据链接地址模糊匹配
  scope :by_website_url, lambda{|website| where("website_url like ?", "%#{website}%")}
  
  #------------------------------验---证-----------------------------------------
  #名称验证
  validates :name, :presence => {:message => "名称不能为空！"},
    :length => {:minimum => 2, :maximum => 30, :message => "名称长度应介于2-30!"}
  #链接地址验证
  validates :website_url, :presence => {:message => "网址不能为空！"},
    :length => {:maximum => 255, :message => "网址长度不能超过255"},
    :format => {:with => URI.regexp(['http']), :message => "链接格式不正确！"}
  #  validates_as_paranoid
  
  #-------------------------------cache-----------------------------------------
  def self.cache_all
    Rails.cache.fetch("friendly_website_all") { all }
  end

  #------------------------------类-方-法----------------------------------------
  
  
  
  #------------------------------实例方法-----------------------------------------

  # 模板标签（cms_FriendlyWebsite）操作数据库方法
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-28
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_FriendlyWebsite vo in limit:5 %}
  #     {{vo.name}}
  #   {% endcms_FriendlyWebsite%}
  #
  # ==== 返回
  #   集合<FriendlyWebsite>
  #
  def self.cms_liquid_each(attributes, option)
    option[:url] = "${website_url}"
    self.limit(attributes["limit"]||5)
  end
  
end
