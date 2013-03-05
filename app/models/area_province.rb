class AreaProvince < ActiveRecord::Base
  #------------------------------载-入-类----------------------------------------
  
  #注册模板字段
  mango_liquid

  #------------------------------插---件-----------------------------------------
  #软删除
  acts_as_paranoid
  acts_as_list
  
  #------------------------------关---系-----------------------------------------
  #城市
  has_many :area_cities, :dependent => :destroy
  has_many :order_addresses
  
  
  
  #------------------------------常---量-----------------------------------------
  
  
  
  #------------------------------scope------------------------------------------
  
  #  validates_as_paranoid
  
  #------------------------------验---证-----------------------------------------
  
  
 
  #------------------------------类-方-法----------------------------------------
  
  
  
  #------------------------------实例方法-----------------------------------------
  # 模板标签（cms_AreaProvince）操作数据库方法
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-28 10:59:28
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_AreaProvince vo in nil %}
  #     {{vo.name}}
  #   {% endcms_AreaProvince%}
  #
  # ==== 返回
  #   集合<AreaProvince>
  #
  def self.cms_liquid_each(attributes, options)
    #主体
    temp = self.order("id ASC")
    temp = temp.offset(attributes["offset"]) if attributes["offset"]
    temp = temp.select(attributes["column"]) if attributes["column"]
    temp = temp.where("id = ?", attributes["id"]) if attributes["id"]
    temp
  end

  # 省市联动数据
  #
  # 作者: 孙博
  # 最后更新时间: 2011-5-14
  #
  # ==== 示例
  #   OaUtil.address_data
  #
  # ==== 返回
  #   json 格式的
  #   { data : [
  #          {treeNode:'北京',value:1,childNode:[
  #              {treeNode:'东城区',value:11,childNode:[]},
  #              {treeNode:'西城区',value:12,childNode:[
  #                  {treeNode:'西城区1',value:121,childNode:[]},
  #                  {treeNode:'西城区2',value:122,childNode:[]}
  #                  ]
  #              }
  #              ]
  #          },
  #          {treeNode:'吉林',value:2,childNode:[
  #              {treeNode:'朝阳区',value:2-1,childNode:[]},
  #              {treeNode:'南关区',value:2-2,childNode:[
  #                  {treeNode:'南关区1',value:2-2-1,childNode:[]},
  #                  {treeNode:'南关区2',value:2-2-2,childNode:[]}
  #                  ]
  #              }
  #              ]
  #          }
  #      ]
  #  };
  #
  def self.address_data
    Rails.cache.fetch("area_province_all",:expires_in => 2.hours ) do
      provinces = AreaProvince.find :all, :include => :area_cities
      province_datas = []
      provinces.each do |province|
        city_datas = []
        province.area_cities.each do |city|
          country_datas = []
          city.area_countries.each do |country|
            country_datas << {:treeNode => country.name,:value => "#{province.id}-#{city.id}-#{country.id}",:childNode => []}
          end
          city_datas << {:treeNode => city.name,:value => "#{province.id}-#{city.id}",:childNode => country_datas}
        end
        province_datas << {:treeNode => province.name,:value => "#{province.id}",:childNode => city_datas}
      end
      province_datas.to_json.html_safe
    end
  end
end