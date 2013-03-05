#encoding: utf-8
class OrderMail < ActionMailer::Base

  # 队列中加入mail
  @queue = :mail

  #preform将参数传入后执行order_mail发送邮件
  #
  # 最后更新时间: 2012-7-4
  #
  # ==== 参数
  # * <tt>order</tt> - 订单信息的hash
  # * <tt>orderid</tt> - 订单信息的id
  # * <tt>web_site</tt> - 网站的域名
  # * <tt>source_email</tt> - 发送邮件的地址
  # * <tt>to_email</tt> - 接受邮件的地址
  # * <tt>password</tt> - 发送邮件的邮箱密码
  #
  # ==== 示例
  # Resque.enqueue(OrderMail, order,orderid,web_site,source_email,to_email,password)
  #
  # ==== 返回
  #
  def self.perform(order,orderid,web_site,source_email,to_email,password)
    OrderMail.order_mail(order,orderid,web_site,source_email,to_email,password).deliver
  end

  # 发送邮件
  #
  # 最后更新时间: 2012-7-4
  #
  # ==== 参数
  # * <tt>order</tt> - 订单信息的hash
  # * <tt>orderid</tt> - 订单信息的id
  # * <tt>web_site</tt> - 网站的域名
  # * <tt>source_email</tt> - 发送邮件的地址
  # * <tt>to_email</tt> - 接受邮件的地址
  # * <tt>password</tt> - 发送邮件的邮箱密码
  #
  # ==== 示例
  #
  # ==== 返回
  #
  def order_mail(order,orderid,web_site,source_email,to_email,password)
    ActionMailer::Base.delivery_method =:smtp
    ActionMailer::Base.smtp_settings = {
      :address =>        "smtp.163.com",
      :port =>           25,
      :domain =>         "smtp.163.com",
      :authentication => :login,
      :user_name =>      source_email,
      :password =>       password
    }
    web_info = "" #网站名
    new_order = Order.new(order)
    web_info += "#{GlobalVariable.first.content}"
    shop_infor = ""  #商品信息
    OrderProduct.where("order_id =?",orderid).each do |f|
      shop_infor += "商品名:#{f.item.name}<br/>价格:#{f.item.price}<br/>数量:#{f.item_count}<br/>"
    end

    mail(:from => source_email, :to => to_email, :subject => "新的订单_#{web_site}") do |format|
      format.html { render :text => "网站名:#{web_info}<br/>#{shop_infor}<br/>订单号:#{new_order.scode}<br/>收件人:#{new_order.recipient_name}<br/>收件地址:#{new_order.address} <br/>电话:#{new_order.phone}<br/>下单时间:#{new_order.created_at.strftime("%Y-%m-%d %H:%M:%S")}<br/>留言:#{new_order.remark}" }
    end
  end

  # 将信息加入queue
  class Repository
    
    # 将信息加入queue
    #
    # 最后更新时间: 2012-7-4
    #
    # ==== 参数
    # * <tt>order</tt> - 订单信息的hash
    #
    # ==== 返回
    #
    def async_create_ordermail(order)
      Resque.enqueue(OrderMail,self.id,order)
    end
  end
end