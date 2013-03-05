#encoding: UTF-8
class Comment < ActiveRecord::Base
  # ----------关系----------------------
  belongs_to :member
  
  #审核状态
  #未通过
  STATUS_NOT_PASSED = 0
  #通过
  STATUS_PASSED =1
  SELECT_STATUS = [["未通过审核", STATUS_NOT_PASSED], ["通过审核", STATUS_PASSED]]

  #注册模板字段
  mango_liquid

  #--------------------------验证---------------------------------
  #评论内容验证
  validates :content, :length => {:minimum => 10, :maximum => 500, :message => "字数限制为10-500个字符"}

   #方法

  # 获取中文状态
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-29
  #
  # ==== 示例
  #   comment.status_cn
  #
  # ==== 返回
  #   String 
  #
  
  def status_cn
    case self.status
    when STATUS_NOT_PASSED then
      return "未通过审核"
    when STATUS_PASSED then
      return "通过审核"
    else
      return "未知状态"
    end
  end

  def item_type_cn
    case self.item_type
    when "ShopProduct" then
      return "商品"
    else
      return self.item_type
    end
  end

end