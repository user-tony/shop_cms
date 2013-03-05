class ProductAttachment < ActiveRecord::Base


  #注册模板字段
  mango_liquid %w(thumb)
  #从属于一个产品
  belongs_to :item, :polymorphic => true


  #软删除
  acts_as_paranoid



  #图片
  has_attached_file :thumb, :styles => { :s1 => "736x736#", :s2 => "158x158#", :s3 => "100x100#", :s4 => "218x218#"},
    :url => "/upload/thumbs/attachement/:id_partition/:style/:filename" ,
    :default_url   => "/public/skin/default/images/default_product.gif"
  #这个是以K计算的限制
  #validates_attachment_size :thumb, :less_than => 10.kilobytes
  # 图片的大小限制为8M
  validates_attachment_size :thumb, :less_than => 8.megabytes
  #图片的支持类型
  validates_attachment_content_type :thumb, :content_type => [ 'image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg']



  #添加产品缩略图
  #
  #
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-3-07
  #
  # ==== 参数
  #
  # ==== 示例
  #       ProductAttachment.add_attachment_thumb(product, attachemnt)
  # ====返回
  #    
  #
  def self.add_attachment_thumb(item, attachment_thumb)
    attachment_thumb.each do |attachment|
      create(:item_type => item.class.name, :item_id => item.id, :thumb => attachment)
    end
  end


    # 模板标签（cms_ProductAttachment）操作数据库方法
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-3-9
  #
  # ==== 参数
  # * <tt>attributes</tt> - 注入参数,对应模板标签参数的hash
  # * <tt>options</tt> - 配置参数
  #
  # ==== 模板示例
  #   {% cms_ProductAttachment vo in channel:1 limit:5 recomment:all image:true order:"created_at ASC" tags:"" %}
  #     {{vo.title}}
  #   {% endcms_ProductAttachment%}
  #
  # ==== 返回
  #   集合<Article>
  #
  def self.cms_liquid_each(attributes, options)
    temp = order(attributes["order"] || "created_at DESC")
    temp = temp.where("item_id = ? ", attributes["item_id"])  if attributes["item_id"]
    temp = temp.limit(attributes["limit"])                       if attributes["limit"]
    temp
  end









  
end
