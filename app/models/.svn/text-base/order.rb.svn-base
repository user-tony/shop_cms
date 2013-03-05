#encoding: UTF-8
class Order < ActiveRecord::Base
  #软删除
  acts_as_paranoid
  # ----------关系----------------------
  belongs_to :member
  belongs_to :order_address
  has_many :order_products
  #货运信息
  has_one :logistic

  #常量
  #订单状态：退货、拒收、已作废、未处理、审核通过、已发货、已签收、已完成
  #退货
  ORDER_STATUS_RETURN = -3
  #拒收
  ORDER_STATUS_REJECT = -2
  #已作废
  ORDER_STATUS_WASTE = -1
  #未处理
  ORDER_STATUS_DEFAULT = 0
  #审核通过
  ORDER_STATUS_AUDIT = 1
  #己发货
  ORDER_STATUS_SEND = 2
  #己签收
  ORDER_STATUS_RECEIVED = 3
  #己完成
  ORDER_STATUS_FINISH = 4 

  SELECT_ORDER_STATUS = [["退货", ORDER_STATUS_RETURN],
    ["拒收", ORDER_STATUS_REJECT],
    ["已作废", ORDER_STATUS_WASTE],
    ["未处理", ORDER_STATUS_DEFAULT],
    ["审核通过", ORDER_STATUS_AUDIT],
    ["已发货", ORDER_STATUS_SEND],
    ["已签收", ORDER_STATUS_RECEIVED],
    ["已完成", ORDER_STATUS_FINISH]]

  #支付状态：未支付、已支付
  PAYMENT_STATUS_NOT_PAYMENT = 0
  PAYMENT_STATUS_PAYMENTED = 1
  SELECT_PAYMENT_STATUS = [["未支付", PAYMENT_STATUS_NOT_PAYMENT], ["已支付", PAYMENT_STATUS_PAYMENTED]]


  #倒序查询
  scope :ct_desc, order("created_at DESC")
  #正序查询
  scope :ct_asc, order("created_at ASC")
  #今天的
  scope :today, where("DATE(created_at) = DATE(now())")
  #返回订单状态
  scope :get_payment_status, lambda { |status| where("payment_status =? ", status) }
  #根据用户查找
  scope :by_member, lambda { |member| where("member_id = ? ", member) }


  #--------------------------验证---------------------------------
  #联系人验证
  validates :recipient_name, :presence => {:message => "联系人不能为空！"}
  #手机验证
  validates :phone, :presence => {:message => "手机不能为空！"},
    :format => {:with => /((1[3458]\d{9}))|((\d{3,4}-)?\d{7,8})/i, :message => "手机格式不正确！"}
  #收货地址验证
  validates :address, :presence => {:message => "收货地址不能为空！"},
    :length => {:minimum => 10, :message => "收货地址长度不能小于10！"}

  mango_liquid %w(order_status_cn payment_status_cn logistic)


  #方法

  # 获取中文状态
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-03-09
  #
  # ==== 示例
  #   order.order_status_cn
  #
  # ==== 返回
  #   String
  #
  def order_status_cn
    case self.order_status
    when ORDER_STATUS_RETURN then
      return "退货"
    when ORDER_STATUS_REJECT then
      return "拒收"
    when ORDER_STATUS_WASTE then
      return "已作废"
    when ORDER_STATUS_DEFAULT then
      return "未处理"
    when ORDER_STATUS_AUDIT then
      return "审核通过"
    when ORDER_STATUS_SEND then
      return "已发货"
    when ORDER_STATUS_RECEIVED then
      return "己签收"
    when ORDER_STATUS_FINISH then
      return "已完成"
    else
      return "未知状态"
    end
  end

  # 获取中文支付状态
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-03-09
  #
  # ==== 示例
  #   order.payment_status_cn
  #
  # ==== 返回
  #   String
  #
  def payment_status_cn
    case self.payment_status
    when PAYMENT_STATUS_NOT_PAYMENT then
      return "未支付"
    when PAYMENT_STATUS_PAYMENTED then
      return "已支付"
    else
      return "未知状态"
    end
  end

  # 生成订单号
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-03-23
  #
  # ==== 示例
  #   Order.generate_order_scode
  #
  # ==== 返回
  #   String
  #
  def self.generate_order_scode
    Time.now.strftime('%y%m%d') << "%05d" % (Order.today.size + 1) << "%04d" % rand(10000)
  end
  
   
  def self.get_price_sum(id)
    find_by_id(id).order_products.select("price").inject([]) do |price,order_product |
      price << order_product.column
      price
    end
  end

  # 生成订单
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-25
  #
  # ==== 参数
  # * <tt>products</tt> - 购物车
  #     products = {
  #       :shop_product => {"1" => {"count" => 10}, "12" => {"count" => 20}},
  #       :shop_package => {"1" => {"count" => 10}}
  #     }
  # * <tt>member_id</tt> - 用户id
  # * <tt>remark</tt> - 备注
  # * <tt>order_address_id</tt> - 收货地址id
  # * <tt>client_ip</tt> - 客户端i
  # * <tt>phone</tt> - 联系电话
  # * <tt>recipient_name</tt> - 收货人
  # * <tt>address</tt> - 收货地址
  # ==== 示例
  #   Order.create_order(products, 1, "备注","1", "8.8.8.8", "13844193899", "龙哥", "长春市西安大路1038号")
  #
  # ==== 异常
  #   RuntimeError: 购物车为空
  #   RuntimeError: 数量必须大于0
  #
  # ==== 返回
  #   true or false
  #
  def self.create_order(shop_cart, member_id, remark, order_address_id, client_ip, phone, recipient_name, address)
    raise "购物车为空" unless hash.present?
    #订单
    order = Order.new(
      :amount => 0, #总金额
      :scode => Time.now.strftime('%y%m%d') << "%05d" % (Order.today.count + 1) << "%04d" % rand(10000),#订单号
      :order_status => Order::ORDER_STATUS_DEFAULT,#订单状态
      :payment_status => Order::PAYMENT_STATUS_NOT_PAYMENT, #支付状态
      :member_id => member_id, #用户id
      :remark => KeyWordFilter.replace_content(remark), #备注
      :client_ip => client_ip, #客户端ip
      :order_address_id => order_address_id, #收获地址id
      :phone => phone, #电话
      :recipient_name => recipient_name, #收货人姓名
      :address => address #收货地址
    )
    #解密购物车数据
    hash = ShopCart.get_cart(shop_cart)
 
    #开始事务
    Order.transaction do

      #商品
      if hash[ShopCart::SHOP_PRODUCT].present?
        hash[ShopCart::SHOP_PRODUCT].each do |key, cookie_product|
          raise "数量必须大于0" if cookie_product["count"].to_i < 1
          if product = ShopProduct.find_by_id(key.to_i)
            order.order_products.build(:item_type => product.class.name, :item_id => product.id, :price => product.price, :item_count => cookie_product["count"].to_i)
            order.amount += product.price.to_f * cookie_product["count"].to_i
          end
        end
      end 
      #套餐
      if hash[ShopCart::SHOP_PACKAGE].present?
        hash[ShopCart::SHOP_PACKAGE].each do |key, cookie_product|
          raise "数量必须大于0" if cookie_product["count"].to_i < 1
          if product = ShopPackage.find_by_id(key.to_i)
            order.order_products.build(:item_type => product.class.name, :item_id => product.id, :price => product.price, :item_count => cookie_product["count"].to_i)
            order.amount += product.price.to_f * cookie_product["count"].to_i
          end
        end
      end

      #保存订单
      order.save
    end
    order
  end

  def self.test_gen_where
    param_str = "q-搜索词|category_id-1_2_3_4|order-desc"
    params = Hash[param_str.split("|").map{|param| param.split("-")}]
    categor_ids = params["category_id"].to_s.split("_")

    #    param_arr.each do |param|
    #      case param[0]
    #      when "q" then Article.where("title like ?", "%#{categor_ids}%")
    #      end
    #    end
    #
    #    param_str = "q-搜索词|category_id-1_2_3_4|order-desc"
    #    params = Hash[param_str.split("|").map{|param| param.split("-")}]
    #    q = params["q"]
    #    category_ids = params["category_id"].to_s.split("_")
    #    order = params["order"]
  end

  def self.test_gen_url(q, category_ids, categor_id, order)
    categor_id = categor_id.to_i
    order = filter_order_by(order)
    url_arr = Array.new

    url_arr << "q-#{q}" if q.present?
    if category_ids.include?(categor_id)
      category_ids.delete(categor_id)
    else
      category_ids << categor_id
    end
    url_arr << "category_id-#{category_ids.join("_")}"

    url_arr << "order-#{order}" if order

    return url_arr
  end

  def self.filter_order_by(order)
    order_template = ["created_at desc", "created_at asc", "pointer desc", "pointer asc"]
    return order if order_template.include?(order)
  end
end