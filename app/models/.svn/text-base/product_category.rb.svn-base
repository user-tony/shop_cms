#encoding: UTF-8
class ProductCategory < ActiveRecord::Base

  #软删除
  acts_as_paranoid
  #自定义URL插件
  extend FriendlyId
  friendly_id :path_customize

  belongs_to :channel
  has_many :products, :dependent => :destroy

  #注册模板字段
  mango_liquid

  #分类节点插件
  acts_as_nested_set
  attr_protected :lft, :rgt
  #排序插件
  acts_as_list

  #倒序查询
  scope :ct_desc, order("created_at DESC")
  scope :ct_asc, order("created_at ASC")

   scope  :get_cate_id, lambda { |id| where("parent_id = ?", id) }
  #是否为父节点
  scope :parent_node , lambda{|mark| where(:parent_node => mark)}

  #--------------------验证---------------------
  #分类标题不能为空
  validates :name, :presence => {:message => "分类名不能为空"}
  #分类标题不能重复
  validates :name, :uniqueness => {:message => "分类名不能重复"}


  #返回所有id数组
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-3-13
  #
  # ==== 参数
  #      <tt>   category  </tt>   -----  分类对象
  #      <tt>   ids       </tt>   ----- 数组
  # ==== 示例
  #        ProductCategory.next_categories( Category,id )
  # ====返回
  #
  def self.next_categories(category, ids = [])
    if  category.present? && category.id.present?
      categorys = ProductCategory.where("parent_id = ?", category.id)
      categorys.each do |cate|
        ids.push(cate.id)
        next_categories(cate, ids)
      end
    end
    ids
  end

  # 模板标签（cms_ProductCategory）操作数据库方法
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-16
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_Channel vo in pid:1 limit:5 %}
  #     {{vo.title}}
  #   {% endcms_Channel%}
  #
  # ==== 返回
  #   集合<Channel>
  #
  def self.cms_liquid_each(attributes, options)
    options[:url] = "/products/${id}"
    if attributes["pid"].present?
      channel = Channel.find_by_id(attributes["pid"].to_i)
      product_categories = ProductCategory.where("channel_id = ?", channel.id).where("parent_id > 1")
      product_categories = product_categories.order(attributes["order"] || "created_at ASC")
      product_categories = product_categories.limit(attributes["limit"]) if attributes["limit"]
    end
    product_categories
  end


  def self.get_page_data(attributes)
      results = order(attributes["order"] || "created_at DESC")
      results = results.get_cate_id(attributes["cate_id"]) if attributes["cate_id"]
      results = results.page(attributes["current_page"])     if attributes["current_page"]
      results = results.per(attributes["page_size"])         if attributes["page_size"]
  end 


end
