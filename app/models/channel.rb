#encoding: UTF-8
class Channel < ActiveRecord::Base

  #自定义URL插件
  extend FriendlyId
  friendly_id :path_customize
  #关系，用于树的建立
  acts_as_nested_set
  attr_protected :lft, :rgt

  #软删除
  acts_as_paranoid
  #排序
  #  acts_as_list

  #注册模板字段
  mango_liquid

  has_many :articles,  :dependent => :destroy
  has_many :products,  :dependent => :destroy
  has_many :answers,  :dependent => :destroy
  has_many :product_categories
  has_one :custom_page,  :dependent => :destroy
  has_many :zhaopins,  :dependent => :destroy
  belongs_to :info_model
  
  #模型验证
  validates :name, :presence => {:message => "栏目名称不能为空"}
  validates :path_customize, :presence => {:message => "自定义URL不能为空"}
  #软删除验证
  validates_as_paranoid
  validates_uniqueness_of_without_deleted :path_customize,   :uniqueness => {:message =>  "自定义URL不能重复"}

  #图片
  has_attached_file :thumb, :styles => { :s1 => "240x179>"},
    :url => "/upload/thumbs/channels/:id_partition/:style/:filename",
    :default_url   => "/assets/nopic.gif"
  #以K计算的限制
  #  validates_attachment_size :thumb, :less_than => 10.kilobytes
  #限制图片上传最大为2M
  validates_attachment_size :thumb, :less_than => 2.megabytes
  validates_attachment_content_type :thumb, :content_type => [ 'image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg']

  #倒序scope
  scope :ct_desc, order("created_at desc")
  #正序scope
  scope :ct_acs, order("created_at asc")
  #最终栏目
  scope :final_page , where("final_page = ? ", true)
  #单页栏目
  scope :single_page, where("single_page = ? ", true)

  #虚拟字段，用于读出栏目的上级栏目名
  attr_reader  :parent_name
  #栏目类型 1 为原创， 2为跳转
  CHANNEL_TYPE ={ :original => 1, :jump => 2  }

  def self.get_parent_id(parent_id)
    Rails.cache.fetch("channel_parent_id_by_#{parent_id}"){self.where("parent_id = ?", parent_id).all}
  end

  #返回当前id对象
  # 作者: 佟立家
  #
  # 最后更新时间: 2012-04-28
  #
  # ==== 参数
  #      <tt>id </tt> ----栏目 id
  # ==== 示例
  #     by_id(id)
  #
  # ====返回
  #   channel对象
  #
  def self.by_id(id)
    Rails.cache.fetch("channel_by_#{id}"){self.find_by_id(id)}
  end
  
  def self.channel_url(channel_id)
    #如果是跳转链接
    if (channel = self.find_by_id(channel_id))
      return channel.return_url if channel.channel_type == 2
      model_name = channel.info_model.model_name
      case model_name
      when "ShopProduct" then return "/#{channel.path_customize}"
      when "Product" then return "/product/#{channel.path_customize}"
      when "Zhaopin" then return "/#{channel.path_customize}"
      when "Answer" then return "/questions/#{channel.path_customize}"
      else
        return "/page/#{channel.path_customize}"
      end
    end
  end

  
  #返回所有id
  #
  # 作者: 佟立家
  #
  # 最后更新时间: 2012-3-13
  #
  # ==== 参数
  #      <tt>  channel  </tt>   -----  栏目对象
  #      <tt>   ids </tt>   ----   空数组
  #
  # ==== 示例
  #        channel_down_ids（Channel.find_by_id(10)）
  #
  # ====返回
  #    
  #
  def self.next_node(channel,ids = [])
    if channel.present?
      channels = Channel.get_parent_id(channel.id)
      channels.each do |chan|
        ids.push(chan.id)
        next_node(chan,ids)
      end
    end
    ids
  end

  # 根据pid获得父节点
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-16
  #
  # ==== 参数
  # * <tt>channel</tt> - channel对象
  #
  # ==== 示例
  #   Channel.top_node(Channel.new)
  #
  # ==== 返回
  #   数组<Channel>，返回的数组需要倒序循环
  #
  def self.top_node(channel, result = [])
    result << channel
    if channel.parent_id > 1
      channel = self.find_by_id(channel.parent_id, true)
      top_node(channel, result)
    end
    return result
  end

  # 模板标签（cms_Channel）操作数据库方法
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
    if attributes["nopre_channel"]
      options[:url] = "/${path_customize}"
    else
      options[:url] = "/page/${path_customize}"
    end
    if attributes["channel"]&&attributes["top_node"] #位置导航
      top_node(attributes["channel"]).reverse
    else
      temp = self.order(attributes["order"] || "created_at ASC")
      temp = temp.limit(attributes["limit"]) if attributes["limit"]
      temp = temp.select(attributes["column"]) if attributes["column"]
      temp = temp.where(:parent_id => attributes["pid"] ? attributes["pid"] : 1)
      temp = temp.where(:show_nav => true)
      #      temp = temp.where(:single_page => false) unless attributes["single_page"]
      #Rails.cache.fetch("channel_temp"){temp.all}
      temp
    end    
  end

  # 通过模型关联模板信息
  #
  # 作者: 郭金平
  # 最后更新时间: 2012-3-27
  #
  # ==== 返回
  # Hash
  #
  def template_id_by_model
    index = Template.template_index.get_model_type(self.info_model_id).first
    list = Template.template_list.get_model_type(self.info_model_id).first
    detail = Template.template_detail.get_model_type(self.info_model_id).first
    index ? index_id = index.id : index_id = 0
    list ? list_id = list.id : list_id = 0
    detail ? detail_id = detail.id : detail_id = 0
    return {:template_id_index => index_id, :template_id_list => list_id, :template_id_detail => detail_id}
  end

  # 获得本栏目的上级栏目名称
  #
  # 作者: 郭金平
  # 最后更新时间: 2012-3-29
  #
  # ==== 返回
  # 字符串 或 空
  #
  def parent_name
    channel = Rails.cache.fetch("channel_by_#{self.parent_id}"){Channel.where("id = ?", self.parent_id).first}
    channel ? channel.name : nil
  end
 

end
