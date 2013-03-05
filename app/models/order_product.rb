#encoding: UTF-8
class OrderProduct < ActiveRecord::Base
  #软删除
  acts_as_paranoid
  # ----------关系----------------------
  belongs_to :order
  belongs_to :item, :polymorphic => true
  
  mango_liquid %w(buy_member)

  #根据订单查找
  scope :by_order, lambda { |order| where("order_id = ? ", order) }

  #验证
  #订购数量验证
  validates :item_count,   :presence => {:message => "订购数量不能为空！"},
    :numericality => { :greater_than => 0 }

  # 获取类型中文
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-03-12
  #
  # ==== 参数
  #
  # ==== 示例
  #   product.type_cn
  #
  # ==== 返回
  #   String
  #
  def type_cn
    if self.item_type == "ShopProduct"
      return "单品"
    else
      return "套餐"
    end
  end

  # 获取商品购买记录
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-07-07
  #
  # ==== 参数
  #
  # ==== 示例
  #   OrderProduct.get_buy_log(1)
  #   OrderProduct.get_buy_log(1, Order::ORDER_STATUS_FINISH)
  #
  # ==== 返回
  #   [OrderProduct]
  #
  def self.get_buy_log(product_id, order_status = Order::ORDER_STATUS_FINISH)
    logs = OrderProduct.order("orders.created_at desc").includes("order")
    logs = logs.where("item_id = ?", product_id)
    logs = logs.where("orders.order_status = ?", order_status)
  end

  # 获取商品购买记录
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-07-07
  #
  # ==== 参数
  #
  # ==== 示例
  #   OrderProduct.get_buy_log(1)
  #   OrderProduct.get_buy_log(1, Order::ORDER_STATUS_FINISH)
  #
  # ==== 返回
  #   [OrderProduct]
  #
  def buy_member
    begin
      return self.order.member
    rescure ActiveRecord::RecordNotFound
      return nil
    end
  end
end
