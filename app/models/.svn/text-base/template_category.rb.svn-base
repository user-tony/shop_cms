#encoding: UTF-8
class TemplateCategory < ActiveRecord::Base
  #模版分类---分组信息
	GROUP_TYPE = { :index => {:name => "首页", :key => 1, :description => "网站首页" },
    :article => {:name => "新闻", :key => 2, :description => "新闻栏目，新闻列表、内容显示等有关模版" },
    :shop => {:name => "商城",:key => 3, :description => "商城首页、商城列表页、商品显示页等有关模版" },
    :product => {:name => "产品",:key => 4, :description => "产品列表页、产品显示页等有关模版" },
    :order => {:name => "订单",:key => 5, :description => "订单显示，弹窗等有关模版" },
    :recruitment => {:name => "招聘",:key => 6, :description => "招聘列表、内容显示等有关模版" },
    :single => {:name => "自定义页", :key => 7, :description => "自定义单页模版" },
    :partil => {:name => "片段", :key => 8, :description => "全站通用的代码片段" },
    :other => {:name => "其它", :key => 9, :description => "自定义添加的模版，未分类的模版" },
    :message => {:name => "留言", :key => 10, :description => "用户反馈信息"},
    :member => {:name => "用户", :key => 11, :description => "用户模版登陆、注册等相关模版"}
  }

  #版类型： 例如 栏目模版   列表模版    内容模版    单页模版
  TEMPLATE_TYPE = {  :channel => 1, :list => 2 , :content => 3, :single => 4}

  #包含多个模版
  has_many :templates

  belongs_to :info_model

  #倒序scope
  scope :ct_desc, order("created_at desc")
  #正序scope
  scope :ct_asc, order("created_at asc")
  #根据模版名称返回模版ID
  scope :get_template, lambda {|name| where(:name => name)}

  # 根据分类名称返回分类ID
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-12
  #
  # ==== 参数
  # * <tt>name</tt> - 分类名称
  #
  #    get_id("其它")
  #
  # ==== 返回
  #
  def self.get_id(name)
    if  template =  get_template(name).first
      return   template.id
    else
      return nil
    end
  end

  # 根据模版分类返回所有模版
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-15
  #
  # ==== 参数
  #
  # ==== 返回
  #    Template
  def get_template_list
    self.templates
  end


end
