#encoding: UTF-8
class ShopCategory < ActiveRecord::Base
  #软删除
  acts_as_paranoid
  
  #自定义URL插件
  extend FriendlyId
  friendly_id :path_customize

  #下级分类
  has_many :children, :class_name => "ShopCategory", :foreign_key => "parent_id", :dependent => :destroy, :order => "position asc, id asc"
  #商品分类关系表
  has_many :shop_product_category_relations , :dependent => :destroy

  #分类节点插件
  acts_as_nested_set
  attr_protected :lft, :rgt
  #排序插件
  acts_as_list
  
  #注册模板字段
  mango_liquid


  #验证文章标题不能重复包括软删除
  validates_as_paranoid
  validates_uniqueness_of_without_deleted :name,   :uniqueness => {:message =>  "商品分类名称不能重复"}
  #倒序查询
  scope :ct_desc , order("created_at DESC")
  scope :ct_asc , order("created_at ASC")

  scope :parent_id,  where(:parent_id  => 1)

  scope :get_cate_id, lambda{|id| where("parent_id =?",id )}

  #是否为父节点
  scope :parent_node , lambda{|mark| where(:parent_node => mark)}
  
  # 通过父类ID获取所有子类别
  #
  # 作者：李季
  # 更新时间：2012-04-23
  
  def self.parent_and_child_categories(parent_id)
    where(:parent_id => parent_id).inject([]) do |arr, category|
      arr << category
      arr << self.where(:parent_id => category.id);arr
    end
  end
  
  
  # 模板标签（cms_ShopCategory）操作数据库方法
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-3-22
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_ShopCategory vo in channel:1 limit:5 recomment:all image:true%}
  #     {{vo.title}}
  #   {% endcms_ShopCategory%}
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
    options[:url] = "/shop_products/${id}"
    #主体
    temp = self.order(attributes["order"] || "created_at DESC")
    temp = temp.where("parent_id = ? ", attributes["cate_id"])  if attributes["cate_id"]
    temp = temp.limit(attributes["limit"])  if attributes["limit"]
    temp = temp.offset(attributes["offset"]) if attributes["offset"]
    temp = temp.select(attributes["column"]) if attributes["column"]
    temp
  end
  
  
end
