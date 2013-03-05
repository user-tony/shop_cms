#encoding: UTF-8
class Answer < ActiveRecord::Base


  #从属一个栏目
  belongs_to :channel
  #回复信息
  has_many :reply_answers,  :dependent => :destroy

  #倒序查询
  scope :ct_desc , order("created_at DESC")
  #正序查询
  scope :ct_asc , order("created_at ASC")


  #注册模板字段
  mango_liquid

  # 模板标签（cms_Answer）操作数据库方法
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-05-03
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_Answer vo in  limit:5 %}
  #
  #   {% endcms_Answer%}
  #
  # ==== 返回
  #   集合<Article>
  #
  def self.cms_liquid_each(attributes, options)
    #设置url
    options[:url] = "/answer/${id}"

    #主体
    temp = self.order(attributes["order"] || "updated_at DESC")
    temp = temp.where("id in (?)",attributes["ids"].split(","))  if attributes["ids"]
    temp = temp.where("channel_id = ?", attributes["channel_id"]) if attributes["channel_id"]
    temp = temp.where("answer_status",1)
    temp = temp.limit(attributes["limit"] || 10)
    temp = temp.offset(attributes["offset"]) if attributes["offset"]
    temp = temp.select(attributes["column"]) if attributes["column"]
    temp
  end


  # 赞成数加一
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-05-09
  #
  # ==== 参数
  # * <tt>id</tt> - 回复的id
  # 
  # ==== 返回
  #   返回当前回复的赞成数
  #
  def self.add_approval(id)
    answer = find_by_id(id)
    answer.increment(:approval_count)
    answer.save
    answer.approval_count
  end

end
