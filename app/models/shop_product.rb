#encoding: UTF-8
class ShopProduct < ActiveRecord::Base
  # ----------插件----------------------
  #排序
  acts_as_list
  #软删除
  acts_as_paranoid

  #注册模板字段
  mango_liquid %w(get_comments product_attachments product_content)
  # ----------关系----------------------
  belongs_to :product
  has_one :product_content, :dependent => :destroy, :as => "item"
  has_many :order_products
  has_many :shop_product_package_relations
  #图片附件
  has_many :attached_pictures,    :dependent => :destroy, :as  => "item"
  #产品缩略图
  has_many :product_attachments , :dependent => :destroy, :as  => "item"
  #评论
  has_many :comments, :dependent => :destroy, :as  => "item"
  #商品分类关系表
  has_many :shop_product_category_relations , :dependent => :destroy

 
  # ----------常量----------------------
  #未上架、已上架
  STATUS_NOT_SELL = 0
  STATUS_SELL = 1
  SELECT_STATUS = [["未上架", STATUS_NOT_SELL], ["已上架", STATUS_SELL]]

  #试用商品
  STATUS_NOT_TRY = 1
  # ----------scope----------------------
  #倒序查询
  scope :ct_desc , order("created_at DESC")
  #正序查询
  scope :ct_asc , order("created_at ASC")
  #已上架商品
  scope :get_shop_count_status_sell , where(:product_status => STATUS_SELL)
  #未上架商品
  scope :get_shop_count_status_not_sell , where(:product_status => STATUS_NOT_SELL)

  scope :get_shop_count_status_try , where(:shop_product_type => STATUS_NOT_TRY)

  scope :get_cate_id, lambda { |cate_id| where("shop_category_id =? ", cate_id) }

  #--------------------验证---------------------
  #验证不能重复包括软删除
  validates_as_paranoid
  validates_uniqueness_of_without_deleted :name, :message =>  "商品名称不能重复"
  #验证售价
  validates_numericality_of :price, :message => "价格格式错误"

  #--------------------过滤器---------------------
  before_save :filter_price

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
  
  
  #返回产品的缩略图地址
  #
  # 作者: 佟立家  
  # 最后更新时间: 2012-04-10
  #
  # ==== 参数
  #
  # ==== 示例
  #   product.get_images
  #
  # ==== 返回
  #   String
  #
  def get_images
    if attachments =  self.product.product_attachments.first
      attachments.thumb.url(:s1)
    else
      "/assets/nopic.gif"
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

  #获取可以参加套餐的商品
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-03-21
  #
  # ==== 参数
  # *<tt>limit</tt> - 数量，默认不填取所有
  # ==== 示例
  #   ShopProduct.get_product_to_package()
  #
  # ==== 返回
  # [Product]
  #
  def self.get_product_to_package(limit = 0)
    products = ct_desc
    products = products.limit(limit) if limit > 0

    return products
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
  #   {% cms_ShopProduct vo in cate:1  %}
  #     {{vo.title}}
  #   {% endShopProduct%}
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
    if attributes["cart_id"]
      ids = []
      attributes["cart_id"].each { |key,value| ids << key }
      temp = temp.where("id in (?)", ids)
    end
    temp = temp.where("recommend = ?", attributes["recommend"].to_i )  if attributes["recommend"]
    #查询上架后的商品
    temp = temp.where("product_status = ?", STATUS_SELL)
    temp = temp.limit(attributes["limit"]) if attributes["limit"]
    temp = temp.select(attributes["column"]) if attributes["column"]
    temp
  end

  # 获取中文状态
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-07
  #
  # ==== 参数
  # * <tt>status</tt> - 状态
  #
  # ==== 示例
  #   ShopProduct.product_status_cn(1)
  #
  # ==== 返回
  #   String
  #
  def self.product_status_cn(status)
    case status
    when STATUS_NOT_SELL then return "未上架"
    when STATUS_SELL then return "已上架"
    else
      return "未知状态"
    end
  end

  # 获取评论
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-29
  #
  # ==== 参数
  # * <tt>status</tt> - 状态
  #
  # ==== 示例
  #   shop_product.get_comments
  #
  # ==== 返回
  #   Array
  #
  def get_comments(status = nil)
    comments = Comment.where(:item_type => self.class.name, :item_id => self.id).order("created_at desc")
    if status.present?
      comments = comments.where(:status => status)
    else
      comments = comments.where(:status => Comment::STATUS_PASSED)
    end
  end

  # 判断用户是否成功购买过这个商品
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-07-04
  #
  # ==== 参数
  # * <tt>member_id</tt> - 用户id
  #
  # ==== 示例
  #   shop_product.has_buy(1)
  #
  # ==== 返回
  #   true or false
  def has_buy?(member_id)
    OrderProduct.count_by_sql("SELECT COUNT(orders.id) FROM orders INNER JOIN order_products ON orders.id = order_products.order_id AND orders.order_status = 4 AND orders.member_id = #{member_id} AND item_id = #{self.id} AND item_type = '#{self.class.name}'").to_i > 0
  end
 

end
