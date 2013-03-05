#encoding: UTF-8
class ShopPackage < ActiveRecord::Base
  #排序
  acts_as_list
  #软删除
  acts_as_paranoid
  # ----------关系----------------------
  has_many :product_contents, :dependent => :destroy, :as => :item
  has_many :shop_product_package_relations, :dependent => :destroy
  has_many :order_products
  #图片附件
  has_many :attached_pictures,    :dependent => :destroy, :as  => "item"
  #添加一个关联属性
  accepts_nested_attributes_for :product_contents

  #倒序查询
  scope :ct_desc , order("created_at DESC")
  #正序查询
  scope :ct_asc , order("created_at ASC")

  #--------------------验证---------------------
  #套餐名不能为空
  validates :name,   :presence => {:message => "套餐名不能为空"}
  #验证不能重复包括软删除
  validates_as_paranoid
  validates_uniqueness_of_without_deleted :name, :message =>  "套餐名称不能重复"
  #验证售价
  validates_numericality_of :price, :greater_than => 0, :message => "价格格式错误"

  #--------------------过滤器---------------------
  before_save :filter_price

  #方法

  # 更新套餐商品
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-03-08
  #
  # ==== 参数
  # * <tt>shop_product_ids</tt> - 新的id列表
  #
  # ==== 示例
  #   package.update_products([1,2])
  #
  # ==== 返回
  #   true or false
  #
  def update_products(shop_product_ids)
    self.shop_product_package_relations.each do |relation|
      if shop_product_ids.include?(relation.shop_product_id)
        shop_product_ids.delete(relation.shop_product_id)
      else
        relation.destroy
      end
    end
    shop_product_ids.each do |shop_product_id|
      self.shop_product_package_relations << ShopProductPackageRelation.new(
        :shop_package_id => self.id,
        :shop_product_id => shop_product_id,
        :product_count => 1
      )
    end
  end
  # 获取完整名称
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-03-12
  #
  # ==== 参数
  #
  # ==== 示例
  #   product.full_name
  #
  # ==== 返回
  #   String
  #
  def full_name
    if self.name.present?
      return self.name
    elsif self.product
      return self.product.name
    else
      return "产品不存在"
    end
  end
  
  #过滤价格
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-03-20
  #
  # ==== 参数
  #
  # ==== 示例
  #   product.filter_price
  #
  # ==== 返回
  # nil
  #
  def filter_price
    self.market_price = self.market_price.to_f.abs
    self.price = self.price.to_f.abs
  end


   # 模板标签（cms_ShopProduct）操作数据库方法
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-3-9
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_ShopPackage vo in cate:1  %}
  #     {{vo.title}}
  #   {% endShopPackage%}
  #
  # ==== 返回
  #   集合<ShopProduct>
  #
  def self.cms_liquid_each(attributes, options)
    #设置url
    options[:url] = "/shop_products/${id}"
    #主体
    temp = self.order(attributes["order"] || "created_at DESC")
    temp = temp.where("shop_category_id = ?", attributes["cate"]) if attributes["cate"]
    temp = temp.where("id = ?", attributes["id"]) if attributes["id"]
    #查询上架后的商品
    temp = temp.where("product_status = ?", STATUS_SELL)
    temp = temp.limit(attributes["limit"]) if attributes["limit"]
    temp = temp.select(attributes["column"]) if attributes["column"]
    temp
  end


end
