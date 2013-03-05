#encoding: UTF-8
class Product < ActiveRecord::Base

  #软删除
  acts_as_paranoid
  #标签插件
  acts_as_taggable
  # ----------关系----------------------
  #产品
  belongs_to :channel
  #产品分类
  belongs_to :product_category
  #产品内容
  has_one :product_content, :dependent => :destroy, :as => "item"
  #图片附件
  has_many :attached_pictures, :dependent => :destroy, :as => "item"
  #产品缩略图
  has_many :product_attachments, :dependent => :destroy, :as => "item"

 

  #注册模板字段
  mango_liquid

  #如果如果产品描述导读为空就取内容的第一段当描述
  after_save :set_description
  #删除产品时 更改商品状态为下架
  before_destroy :set_shop_product_status

  #倒序查询
  scope :ct_desc, order("created_at DESC")
  #正序查询
  scope :ct_asc, order("created_at ASC")

  #--------------------验证---------------------
  #产品名不能为空
  validates :name, :presence => {:message => "产品名不能为空"}
  #产品名不能重复
  # validates :name,   :uniqueness => {:message =>  "产品名不能重复"}
  #验证文章标题不能重复包括软删除
  validates_as_paranoid
  validates_uniqueness_of_without_deleted :name, :uniqueness => {:message => "产品名不能重复"}


  # 模板标签（cms_Product）操作数据库方法
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-3-22
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_Product vo in channel:1 limit:5 recomment:all image:true%}
  #     {{vo.title}}
  #   {% endcms_Product%}
  #
  #    order 排序
  #    limit 取几条
  #    channel_id 栏目ID
  #
  # ==== 返回
  #   集合<Product>
  #
  def self.cms_liquid_each(attributes, options)
    #设置url
    options[:url] = "/products/${id}"

    #主体

    temp = self.order(attributes["order"] || "created_at DESC")
    temp = temp.where("product_category_id = ? ", attributes["cate"]) if attributes["cate"]
    temp = temp.limit(attributes["limit"] || 5)
    temp = temp.select(attributes["column"]) if attributes["column"]
    if attributes["channel_id"]
      channel_id = attributes["channel_id"]
      if channel_id.class == Fixnum
        temp = temp.where(:channel_id => channel_id)
      elsif channel_id.class == String #调用多个栏目
        temp = temp.where(:channel_id => channel_id.split(/\s+|,/))
      end
    end
    temp
  end

  


  # 模板标签（cms_Product）操作数据库方法
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-3-22
  #
  # ==== 参数
  # * <tt>channel</tt> - 栏目 对象
  #
  # ==== 模板示例
  #      Product.get_products(channel)

  #
  # ==== 返回
  #   集合<Product>
  #
  def self.get_products(channel)
    where("id in (?)", ProductCategory.next_categories(channel.product_categorys.where("parent_id == 1").first))
  end


  #  提取内容字段的第一段信息，没有返回空
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-29
  #
  # ==== 示例
  #     self.first_p_content
  #
  # ==== 返回
  #
  def first_p_content
    require 'hpricot'
    Hpricot(self.product_content.content).search("//p[1]").text
  end

  #  提取内容字段的第一段信息，没有返回空
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-05-16
  # 参数
  #<tt> product  </tt>  产品对象
  #<tt> product_list  </tt>  产品集合对象
  #<tt> page  </tt>  当前页码
  #<tt> per_page  </tt>  分页条数
  #<tt> start_time  </tt>  搜索开始时间
  #<tt> end_time  </tt>  搜索结束时间
  ##
  # ==== 示例
  #    Product.product_where(product, product_list, page=1, per_page=20, start_time, end_time)
  #
  # ==== 返回
  #
  def self.product_where(product, product_list, page=1, per_page=20, start_time = nil, end_time = nil)
    if product.present?
      product_list = product_list.where("name like ? ", "%#{product.name}%") if product.name.present?
      product_list = product_list.where("product_category_id = ? ", product.product_category_id) if product.product_category_id.present? && product.product_category_id.to_i != 0
    end
    product_list = product_list.where("TO_DAYS(created_at) >= TO_DAYS(?) ", start_time) if start_time.present?
    product_list = product_list.where("TO_DAYS(created_at) <= TO_DAYS(?) ", end_time) if end_time.present?
    product_list = product_list.page(page).per(per_page)
  end


  private
  #如果描述为空就取内容第一段赋值给它
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-03-29
  #
  # ==== 示例
  #
  # ==== 返回
  #
  def set_description
    unless self.description.present?
      if self.product_content
        if self.product_content.content.present?
          description = self.first_p_content.truncate(60).strip
          description.blank? and return
        else
          return
        end
        self.update_attributes(:description => description)
        return
      end
    end
  end
  
  #如果该产品删除后对应的商品应改成下架模式
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-05-24
  #
  # ==== 示例
  #
  # ==== 返回
  #
  def set_shop_product_status
    ShopProduct.transaction do |_|
      ShopProduct.update_all( {:product_status => ShopProduct::STATUS_NOT_SELL} , ["product_id = ? ", self.id])
    end
  end

end