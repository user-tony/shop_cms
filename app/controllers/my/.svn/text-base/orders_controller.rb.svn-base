#encoding: UTF-8
class My::OrdersController  < My::BaseController

  before_filter :authenticate_member!
  # 我的订单首页
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-25
  def index
    #我的订单列表
    orders = Order.by_member(current_member)
    orders = orders.order("id desc")
    orders = orders.page(params[:page]).per(5)

    liquid_render 22, :liquid => {
      "orders" => orders
    }
  end

  # 我的订单显示页
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-25
  def show
    order = Order.by_member(current_member).find_by_id(params[:id].to_i)
    products = order.order_products
    liquid_render 21, :liquid => {
      "order" => order,
      "products" => products
    }
  end

  # 放弃订单
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-25
  def delete
    if order = Order.by_member(current_member).find_by_id(params[:id].to_i)
      #未处理、支付金额是0、未支付才可以放弃
      if order.order_status == Order::ORDER_STATUS_DEFAULT && order.payment <= 0 && order.payment_status == Order::PAYMENT_STATUS_NOT_PAYMENT
        order.destroy
      else
        flash[:error] = "该订单不可以删除"
      end
    else
      flash[:error] = "订单不存在"
    end
    redirect_to :back
  end

  # 订单支付
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-28
  def payment
    goto_url = params[:goto_url] || "/my/orders"
    order = Order.by_member(current_member).find_by_id(params[:id].to_i)
    redirect_to goto_url and return if order.present? && order.payment_status == Order::PAYMENT_STATUS_PAYMENTED
    product_count = order.order_products.inject(0){|count,order| count += order.item_count ; count }
    liquid_render 23, :liquid => {
      "order" => order,
      "product_count" => product_count,
      "goto_url" => goto_url
    }
  end

  # 订单支付跳转
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-28
  def payment_save
    redirect_to "/payment/#{params[:payment_category]}/get_page?id=#{params[:id]}&goto_url=#{params[:goto_url]}"
  end
end
