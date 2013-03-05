#encoding: UTF-8
class ReplyAnswer < ActiveRecord::Base
  
  #从属一个问题
  belongs_to :answer


  #倒序查询
  scope :ct_desc , order("created_at DESC")
  #正序查询
  scope :ct_asc , order("created_at ASC")

  #注册模板字段
  mango_liquid



  # 模板标签（cms_ReplyAnswer）操作数据库方法
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-05-03
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_ReplyAnswer vo in  limit:5   order:"created_at ASC" %}
  #     {{vo.title}}
  #   {% endcms_ReplyAnswer%}
  #
  # ==== 返回
  #   集合<Article>
  #
  def self.cms_liquid_each(attributes, options)
    #主体
    temp = self.order(attributes["order"] || "updated_at DESC")
    temp = temp.where("answer_id = ?", attributes["answer_id"])  if attributes["answer_id"]
    temp = temp.limit(attributes["limit"] || 5)
    temp = temp.offset(attributes["offset"]) if attributes["offset"]
    temp = temp.select(attributes["column"]) if attributes["column"]
    temp
  end
end
