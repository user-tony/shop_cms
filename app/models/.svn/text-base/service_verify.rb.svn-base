#encoding: UTF-8
class ServiceVerify < ActiveRecord::Base
  # ----------状态枚举----------------------
  STATUS_LOCK = -1   #已锁定
  STATUS_READY = 0   #可用
  # ----------关系--------------------------
  belongs_to :service_category
  #-----------SCOPE-------------------------
  #根据序列号类型查询
  scope :by_category_id, lambda{|service_category_id| where("service_category_id = ?", service_category_id)}
  #根据序列号类型查询
  scope :like_serial_number, lambda{|serial_number| where("serial_number LIKE ? ", "%#{serial_number}%")}

  # 获取中文状态
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-23
  #
  # ==== 参数
  # * <tt>status</tt> - 状态
  #
  # ==== 示例
  #   ServiceVerify.status_cn(1)
  #
  # ==== 返回
  #   String
  #
  def self.status_cn(status = nil)
    case status
      when STATUS_LOCK then return "序列号已被锁定"
      when STATUS_READY then return "可用"
    else
      return "未知状态"
    end
  end

  # 锁定序列号
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-23
  #
  # ==== 参数
  #
  # ==== 示例
  #   service_verify.lock
  #
  # ==== 返回
  #   true OR false
  #
  def lock
    update_attribute(:status, STATUS_LOCK)
    return true
  end

  # 解锁序列号
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-05-23
  #
  # ==== 参数
  #
  # ==== 示例
  #   service_verify.unlock
  #
  # ==== 返回
  #   true OR false
  #
  def unlock
    update_attribute(:status, STATUS_READY)
    return true
  end
end