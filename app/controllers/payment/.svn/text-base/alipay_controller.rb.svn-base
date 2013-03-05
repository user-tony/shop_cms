#encoding: UTF-8
class Payment::AlipayController < ApplicationController
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
  # 更新时间：2012-05-02
  def get_page
    show_url = "#{HOSTNAME}/shop/order_manager/#{params[:id]}"
    notice = ""
    
    #获取订单对象
    if orderinfo = Order.find(:first, :conditions =>["id=?",params[:id]])
      if orderinfo.payment_status == Order::PAYMENT_STATUS_NOT_PAYMENT
        @notify_url = "#{HOSTNAME}/payment/alipay/notify_page" #交易过程中服务器通知的页面 要用 http://格式的完整路径
        @return_url = "#{HOSTNAME}/payment/alipay/return_page" #付完款后跳转的页面 要用 http://格式的完整路径
        @amount = "%.2f" % (orderinfo.amount.to_f - orderinfo.payment.to_f).abs
        @out_trade_no = orderinfo.scode.to_s #支付流水号
        @parameter = {
          "service" => "create_direct_pay_by_user", #交易类型
          "partner" => @@partner, #合作商户号
          "return_url" => @return_url, #同步返回
          "notify_url" => @notify_url, #异步返回
          "_input_charset" => @@_input_charset, #字符集，默认为GBK
          "subject" => "商城在线支付", #商品名称，必填
          "body" => "商城在线支付", #商品描述，必填
          "out_trade_no" => @out_trade_no, #商品外部交易号，必填（保证唯一性）
          "payment_type" => "1", #默认为1,不需要修改
          "total_fee" => @amount, #支付金额
          "show_url" => show_url, #商品相关网站
          "seller_email" => @@seller_email #卖家邮箱，必填
        }

        alipay_service(@parameter,@@security_code,@@sign_type,"https")
        @link=create_url()
        redirect_to @link and return
      else
        notice = "请不要重复付款！"
      end
    else
      notice = "订单不存在！"
    end
    if request.headers["Referer"]
      redirect_to "#{request.headers["Referer"]}?notice=#{URI.encode(notice)}"
    else
      redirect_to "#{show_url}?notice=#{URI.encode(notice)}"
    end
  end

  # 支付接口同步回调入口
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-02
  def return_page
    @success = false

    alipay_notify(params,@@partner,@@security_code,@@sign_type,@@_input_charset,@@transport)
    verify_result = true
    flash[:msg]=return_verify()
    orderinfo = Order.find(:first, :conditions =>["scode=?",params[:out_trade_no]])
    if orderinfo && verify_result && params[:is_success]=="T" && (params[:trade_status]=="TRADE_FINISHED" || params[:trade_status]=="TRADE_SUCCESS") && orderinfo.payment_status==Order::PAYMENT_STATUS_NOT_PAYMENT
      orderinfo.payment += params[:total_fee].to_f #修改订单的已支付金额
      if orderinfo.payment >= orderinfo.amount
        orderinfo.payment_status = Order::PAYMENT_STATUS_PAYMENTED #标记已付款
      end
      orderinfo.save
      @success = true
    end
    if @success
      notice = "支付成功！"
    else
      notice = "支付失败，请重试！"
    end
    redirect_to "/shop/order_manager/#{orderinfo.id}?notice=#{URI.encode(notice)}"
  end

  # 支付接口异步回调入口
  #
  # 作者：赵晓龙
  # 更新时间：2012-05-02
  def notify_page
    #判断通知是否由阿里巴巴发送的
    @host = request.remote_ip.to_s
    if @host.eql?("121.0.26.1")

      alipay_notify(params,@@partner,@@security_code,@@sign_type,@@_input_charset,@@transport)
      verify_result = true
      flash[:error]=return_verify()
      orderinfo = Order.find(:first, :conditions =>["scode=?",params[:out_trade_no]])
      if orderinfo && verify_result && params[:is_success]=="T" && (params[:trade_status]=="TRADE_FINISHED" || params[:trade_status]=="TRADE_SUCCESS") && orderinfo.payment_status==Order::PAYMENT_STATUS_NOT_PAYMENT
        orderinfo.payment += params[:total_fee].to_f #修改订单的已支付金额
        if orderinfo.payment >= orderinfo.amount
          orderinfo.payment_status = Order::PAYMENT_STATUS_PAYMENTED #标记已付款
        end
        orderinfo.save
        @success = true
      end
      if @success
        render :text => "success"
      else
        render :text => "fail"
      end
    else
      render :text => "fail"
    end
  end

  # 支付接口加密与对比方法
  protected

  def alipay_service(parameter,security_code,sign_type,transport)
    @@parameter = para_filter(parameter)
    @@security_code = security_code
    @@sign_type = sign_type
    @@mysign = ''
    @@transport = transport
    if(parameter['_input_charset'] == "")
      @@parameter['_input_charset']='GBK'
    end
    if(@@transport == "https")
      @@gateway = "https://www.alipay.com/cooperate/gateway.do?"
    else
      @@gateway = "http://www.alipay.com/cooperate/gateway.do?"
    end
    sort_array = {}
    arg = ""
    sort_array = @@parameter
    sort_array.keys.sort.each do |key|
      if (key != "sign" && key != "sign_type" )
        arg+=key+"="+sort_array[key]+"&"
      end
    end
    prestr = arg[0,arg.length-1]
    @@mysign = sign(prestr+@@security_code)
  end
  def create_url()
    url = @@gateway
    sort_array = {}
    arg = ""
    sort_array = @@parameter
    sort_array.keys.sort.each do |key|
      arg+=key+"="+URI.escape(sort_array[key])+"&"
    end
    url+=arg+"sign="+@@mysign+"&sign_type="+@@sign_type
    return url
  end
  def alipay_notify(parameter,partner,security_code,sign_type,_input_charset,transport)
    @@parameter = parameter
    @@partner = partner
    @@security_code = security_code
    @@sign_type = sign_type
    @@mysign = ""
    @@_input_charset = _input_charset
    @@transport = transport
    if(@@transport == "https")
      @@gateway = "https://www.alipay.com/cooperate/gateway.do?"
    else
      @@gateway = "http://notify.alipay.com/trade/notify_query.do?"
    end
  end
  def return_verify()
    sort_get={}
    sort_get= @@parameter
    arg=""
    sort_get.keys.sort.each do |key|
      if (key != "sign" && key != "sign_type" && key !="action" && key != "controller")
        arg+=key+"="+ sort_get[key]+"&"
      end
    end
    prestr = arg[0,arg.length-1] #去掉最后一个&号
    @@mysign = sign(prestr+@@security_code)
    if (@@mysign == sort_get["sign"])
      return true
    else
      return false
    end
  end
  def sign(prestr)
    mysign = ""
    if(@@sign_type == 'MD5')
      mysign = Digest::MD5.hexdigest(prestr)
    elsif (@@sign_type =='DSA')
      #DSA 签名方法待后续开发
      exit("DSA 签名方法待后续开发，请先使用MD5签名方式")
    else
      exit("支付宝暂不支持"+@@sign_type+"类型的签名方式")
    end
    return mysign
  end
  def para_filter(parameter) #除去数组中的空值和签名模式
    para = {}
    parameter.keys.each do |key|
      if !(key == "sign" || key == "sign_type" || parameter[key] == "")
        para[key] = parameter[key]
      end
    end
    return para
  end
end