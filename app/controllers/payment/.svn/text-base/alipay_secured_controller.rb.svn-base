#encoding: UTF-8
class Payment::AlipaySecuredController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:notify_page, :return_page]

  HOSTNAME = $cms_global_variable["web_site_url"]
  @@gateway = "https://www.alipay.com/cooperate/gateway.do?" #支付接口
  @@parameter = ""
  @@security_code = $cms_global_variable["payment_alipay_security_code"] #安全检验码
  @@mysign = "" #签名
  @@partner = $cms_global_variable["payment_alipay_partner"] #合作伙伴ID
  @@sign_type = "MD5" #加密方式 系统默认
  @@_input_charset="" #字符编码格式
  @@transport="" #访问模式
  @@seller_email = $cms_global_variable["payment_alipay_seller_email"] #支付宝帐户
  @@_input_charset = "utf-8" #字符编码格式 目前支持 GBK 或 utf-8
  @@transport = "https" #访问模式,你可以根据自己的服务器是否支持ssl访问而选择http以及https访问模式(系统默认,不要修改)

  # 支付接口入口
  #
  # 作者：赵晓龙
  # 更新时间：2012-06-07
  #支付页面 连接支付网关
  def get_page
    order = Order.find(params[:id])
    show_url = "#{HOSTNAME}/shop/order_manager/#{params[:id]}"
    notify_url = "#{HOSTNAME}/payment/alipay_secured/notify_page"
    product = "商城在线支付"

    @b = "partner=#{@@partner}"
    @o = "seller_email=#{@@seller_email}"
    @c = @@security_code
    @a = "service=create_partner_trade_by_buyer"
    @d = "subject=#{product}"
    @n = "body=#{product}"
    @e = "out_trade_no=#{order.scode}"
    @f = "price=#{"%.2f" % (order.amount.to_f - order.payment.to_f).abs.to_s}"
    @g = "show_url=#{show_url}"
    @h = "notify_url=#{notify_url}"
    @i = "quantity=1"
    @j = "payment_type=1"
    @k = "logistics_type=EMS"
    @l = "logistics_fee=0"
    @m = "logistics_payment=SELLER_PAY"
    @r = "_input_charset=#{@@_input_charset}"
    @x = [@a,@b,@d,@n,@e,@f,@g,@h,@i,@j,@k,@l,@m,@o,@r]
    @y = @x.sort.join('&')
    @z = @y+@c
    @alipay_md5 = Digest::MD5.hexdigest(@z)
    @alipay_sign = "#{@@gateway}#{@y}&sign=#{@alipay_md5}&sign_type=MD5"
    redirect_to URI.encode(@alipay_sign)
  end

  # 支付接口异步回调入口
  #
  # 作者：赵晓龙
  # 更新时间：2012-06-07
  def notify_page
    @host = request.remote_ip.to_s
    #判断通知是否由阿里巴巴发送的
    if @host.eql?("121.0.26.1")
      @trade_status = params[:trade_status]
      order = Order.find(:first,:conditions => ["scode=?", params[:out_trade_no]])
      #如果未付款，并且订单是等待发货，则更改订单状态为已付款
      if order && order.payment_status == Order::PAYMENT_STATUS_NOT_PAYMENT && @trade_status.eql?("WAIT_SELLER_SEND_GOODS")
        order.payment += params[:total_fee].to_f #修改订单的已支付金额
        if order.payment >= order.amount
          order.payment_status = Order::PAYMENT_STATUS_PAYMENTED #标记已付款
        end
      end
      #如果订单已付款，并且淘宝订单是已完成状态，则本站订单更改订单状态为已完成
      if order && order.payment_status == Order::PAYMENT_STATUS_PAYMENTED && @trade_status.eql?("TRADE_FINISHED")
          order.order_status == Order::ORDER_STATUS_FINISH
      end
      order.save
      render :text => "success"
    else
      render :text => "fail"
    end
  end
end