#encoding: UTF-8
class Admin::MainController < Admin::BaseController

  #首页
  def index

    #商品信息
    #——————————————————————————
    @shop_total_count = ShopProduct.count    #商品共计
    @shop_up_state_count = ShopProduct.get_shop_count_status_sell.count  #上架商品
    @shop_down_state_count = ShopProduct.get_shop_count_status_not_sell.count  #上架商品
    @shop_try_count = ShopProduct.get_shop_count_status_try.count  #试用商品
    #会员信息
    #——————————————————————————
    @member_count = Member.count  #会员总数
    @member_day_count = Member.curren_day_member.count  #今日登陆用户总数

    #会员信息
    #——————————————————————————
    @order_not_payment_count = Order.get_payment_status(Order::PAYMENT_STATUS_NOT_PAYMENT).count #订单未支付
    @order_payment_count = Order.get_payment_status(Order::PAYMENT_STATUS_PAYMENTED).count #订单己支付
    @order_status_default_count = Order.get_payment_status(Order::ORDER_STATUS_DEFAULT).count #未处理订单
    @order_status_audit_count = Order.get_payment_status(Order::ORDER_STATUS_AUDIT).count #未处理订单

    
  end
end
