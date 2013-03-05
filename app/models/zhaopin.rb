class Zhaopin < ActiveRecord::Base

  #软删除
  acts_as_paranoid

  belongs_to :channel

  #注册模板字段
  mango_liquid

  
  belongs_to :member
  #倒序查询
  scope :ct_desc , order("created_at DESC")
  #正序查询
  scope :ct_asc , order("created_at ASC")



  # 模板标签（cms_Article）操作数据库方法
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-3-9
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_Article vo in channel:1 limit:5 recomment:all image:true%}
  #     {{vo.title}}
  #   {% endcms_Article%}
  #
  # ==== 返回
  #   集合<Article>
  #
  def self.cms_liquid_each(attributes, options)
    #设置url
    options[:url] = "/zhaopins/${id}"
    #主体
    temp = self.order(attributes["order"] || "created_at DESC")
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
    recomment = attributes["recomment"]
    if recomment&&recomment == "all"
      temp = temp.where(["recomment > 0"])
    elsif recomment
      temp = temp.where(:recomment => recomment)
    end
    temp = temp.where("thumb_file_name IS NOT NULL") if attributes["image"]
    temp
  end
  
end
