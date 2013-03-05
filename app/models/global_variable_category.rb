#encoding: UTF-8
class GlobalVariableCategory < ActiveRecord::Base
  belongs_to :parent,
    :class_name  => 'GlobalVariableCategory'
  has_many :children, :class_name => "GlobalVariableCategory", :foreign_key => "parent_id", :dependent => :destroy, :order => "position asc, id asc"
  has_many :global_variables, :dependent => :destroy

  #配置级别
  LEVEL_HIGHEST = 100	#高级，不可删改
  LEVEL_NORMAL = 200	#中级，只可以改
  LEVEL_LOWER = 300		#低级，可增删改

  #根据父id获取分类
  scope :by_parent_id, lambda{|parent_id| where("parent_id = ?", parent_id.to_i).order("position asc, id asc")}
  #根据配置级别获取
  scope :by_level, lambda{|level| where("level = ?", level.to_i).order("position asc, id asc")}

  #--------------------验证---------------------
  validates :name,   :presence => {:message => "名称不能为空"}

  #--------------------过滤器---------------------
  before_destroy{
    if self.level < GlobalVariableCategory::LEVEL_LOWER
      raise "配置级别太高不可删除"
    end
  }

  # 下拉分类列表
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-10
  #
  # ==== 参数
  # * <tt>parent_id</tt> - 初始上级id
  # * <tt>depth</tt> - 递归深度
  # * <tt>level</tt> - 配置级别
  #
  # ==== 示例
  #   GlobalVariableCategory.recursive_get_options
  #
  # ==== 返回
  #   Hash
  #
  def self.get_options(parent_id = 0, level = LEVEL_LOWER)
    categories = by_level(level)
     #关系数组转换成对象数组
    categories = categories.to_a
    return recursive_get_options(parent_id, categories)
  end
  
  def self.recursive_get_options(parent_id, categories)
    options = Hash.new
    categories.select{|category| category.parent_id == parent_id}.each do |category|
      child_categories = categories.select{|child_category| child_category.parent_id == category.id}
      if child_categories.present?
        options[category.name] = recursive_get_options(category.id, child_categories)
      else
        if category.depth == 0
          options["根分类"] = {category.name => category.id.to_s}
        else
          options[category.name] = category.id.to_s
        end
      end
    end
    return options
  end

  # 获取分类列表
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-21
  #
  # ==== 参数
  # * <tt>level</tt> - 配置级别
  #
  # ==== 示例
  #   GlobalVariableCategory.get_list(0)
  #
  # ==== 返回
  #   Array[GlobalVariableCategory]
  #
  def self.get_list(level = LEVEL_LOWER)
    list = Array.new
    categories = by_level(level)
    #关系数组转换成对象数组
    categories = categories.to_a
    recursive_get_list(0, list, categories)
    return list
  end

  # 递归获取分类列表
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-21
  #
  # ==== 参数
  # * <tt>parent_id</tt> - 初始上级id
  # * <tt>list</tt> - 结果列表
  # * <tt>categories</tt> - 当前分类列表
  #
  # ==== 示例
  #   GlobalVariableCategory.recursive_get_list(parent_id, list, categories)
  #
  # ==== 返回
  #   Array[GlobalVariableCategory]
  #
  def self.recursive_get_list(parent_id, list, categories)
    categories.select{|category| category.parent_id == parent_id}.each do |category|
      list << category
      categories.delete(category)
      recursive_get_list(category.id, list, categories)
    end
    
  end

  # 获取关联深度的名称
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-28
  #
  # ==== 示例
  #   GlobalVariableCategory.depth_name
  #
  # ==== 返回
  #   string
  #
  def depth_name
    return_str = "┣"
    return return_str + "━" * self.depth.to_i + self.name
  end


end
