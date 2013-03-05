class AreaCountry < ActiveRecord::Base
  #------------------------------载-入-类----------------------------------------
  
  #注册模板字段
  mango_liquid

  #------------------------------插---件-----------------------------------------
  #软删除
  acts_as_paranoid
  acts_as_list
  
  
  #------------------------------关---系-----------------------------------------
  #城市
  belongs_to :area_city
  #用户详细信息
  has_many :member_infos
  #用户订单地址
  has_many :order_addresses, :dependent => :destroy
  
  
  #------------------------------常---量-----------------------------------------
  
  
  
  #------------------------------scope------------------------------------------
  
  
  
  #------------------------------验---证-----------------------------------------
  
  #  validates_as_paranoid
 
  #------------------------------类-方-法----------------------------------------
  
  
  
  #------------------------------实例方法-----------------------------------------
  
   # 模板标签（cms_AreaCountry）操作数据库方法
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-28 10:59:28
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_AreaCountry vo in nil %}
  #     {{vo.name}}
  #   {% endcms_AreaCountry%}
  #
  # ==== 返回
  #   集合<AreaCountry>
  #
  def self.cms_liquid_each(attributes, options)
    #主体
    temp = self.order("id ASC")
    temp = temp.offset(attributes["offset"]) if attributes["offset"]
    temp = temp.select(attributes["column"]) if attributes["column"]
    temp = temp.where("area_city_id = ?", attributes["area_city_id"]) if attributes["area_city_id"]
    temp
  end
  
end
