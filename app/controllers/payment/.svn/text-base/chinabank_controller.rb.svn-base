#encoding: UTF-8
class Payment::ChinabankController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:notify_page, :return_page]
  HOSTNAME = $cms_global_variable["web_site_url"]
  # 支付接口入口
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-03
  def get_page
    show_url = "#{HOSTNAME}/shop/order_manager/#{params[:id]}"
    success = false
    notice = ""

    #获取订单对象
    if orderinfo = Order.find(:first, :conditions =>["id=?",params[:id]])
      if orderinfo.payment_status == Order::PAYMENT_STATUS_NOT_PAYMENT
        @bank_id = params[:bank_id].to_i
        @v_url = "#{HOSTNAME}/payment/chinabank/return_page" #返回地址
        @v_mid = $cms_global_variable["payment_chinabank_v_mid"] #商户ID
        @key = $cms_global_variable["payment_chinabank_key"] #密钥
        @v_oid = orderinfo.scode #订单号
        @v_amount = "%.2f" % (orderinfo.amount.to_f - orderinfo.payment.to_f).abs.to_s #订单金额
        @v_moneytype = "CNY" #币种
        @text = ""<<@v_amount<<@v_moneytype<<@v_oid<<@v_mid<<@v_url<<@key	#拼凑加密串
        @v_md5info = Digest::MD5.hexdigest(@text).upcase #MD5加密
        success = true
      else
        notice = "请不要重复付款！"
      end
    else
      notice = "订单不存在！"
    end
    unless success
      if request.headers["Referer"]
        redirect_to "#{request.headers["Referer"]}?notice=#{URI.encode(notice)}"
      else
        redirect_to "#{show_url}?notice=#{URI.encode(notice)}"
      end
    end
  end

  # 支付接口同步回调入口
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-03
  def return_page
    @success = false

    key = $cms_global_variable["payment_chinabank_key"] #密钥
    v_oid = params[:v_oid].to_s
    v_pstatus = params[:v_pstatus].to_s
    v_pstring = params[:v_pstring].to_s
    v_pmode = params[:v_pmode].to_s
    v_md5str = params[:v_md5str].to_s
    v_amount = params[:v_amount].to_s
    v_moneytype = params[:v_moneytype].to_s
    text = "" << v_oid << v_pstatus << v_amount << v_moneytype << key	#拼凑加密串
    v_md5info = Digest::MD5.hexdigest(text).upcase #MD5加密
    
    if v_md5info == v_md5str
      orderinfo = Order.find(:first, :conditions =>["scode=?", v_oid])
      if v_pstatus.to_s == "20" && orderinfo.payment_status == Order::PAYMENT_STATUS_NOT_PAYMENT
        orderinfo.payment += params[:total_fee].to_f #修改订单的已支付金额
        if orderinfo.payment >= orderinfo.amount
          orderinfo.payment_status = Order::PAYMENT_STATUS_PAYMENTED #标记已付款
        end

        orderinfo.save
        @success = true
      else
        notice = "支付失败！"
      end
    else
      notice = "支付失败，数据可疑"
    end
    if @success
      notice = "支付成功！"
    end
    redirect_to "/shop/order_manager/#{orderinfo.id}?notice=#{URI.encode(notice)}"
  end

  # 支付接口异步回调入口
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-03
  def notify_page
    @success = false

    key = "fengshizaojiao@163.com" #密钥
    v_oid = params[:v_oid]
    v_pstatus = params[:v_pstatus]
    v_pstring = params[:v_pstring]
    v_pmode = params[:v_pmode]
    v_md5str = params[:v_md5str]
    v_amount = params[:v_amount]
    v_moneytype = params[:v_moneytype]
    text = "" << v_oid << v_pstatus << v_amount << v_moneytype << key	#拼凑加密串
    v_md5info = Digest::MD5.hexdigest(text).upcase #MD5加密
    if v_md5info == v_md5str
      orderinfo = Order.find(:first, :conditions =>["scode=?", v_oid])
      if v_pstatus.to_s == "20" && orderinfo.payment_status == Order::PAYMENT_STATUS_NOT_PAYMENT
        orderinfo.payment += params[:total_fee].to_f #修改订单的已支付金额
        if orderinfo.payment >= orderinfo.amount
          orderinfo.payment_status = Order::PAYMENT_STATUS_PAYMENTED #标记已付款
        end
        orderinfo.save
        @success = true
      end
    end
    if @success
      render :text => "ok"
    else
      render :text => "error"
    end
  end
end