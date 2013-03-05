#encoding:UTF-8
module LiquidFilters

  #分页
  def paginate(scope, options = {})
    options = Hash[options.split("&").map{|param| param.split("=")}] if options && options.class != Hash
    paginate = Cms::Paginate.new(scope, options.reverse_merge(:per_page => scope.limit_value, :param_name => Kaminari.config.param_name, :remote => false))
    paginate.to_s
  end

  #取paperclip插件图片
  def thumb(scope, thumb = nil)
    return "/skin/default/images/default_product.gif" unless scope
    scope = scope.thumb unless scope.class == Paperclip::Attachment
    return scope.url(thumb) if thumb
    scope.url
  end

  #生成栏目URL
  def channel_url(scope)
    channel = scope.id
    #如果是跳转链接
    Channel.channel_url(channel)
  end

  #字符串格式化
  def string_format(var, format_type, format)
    case format_type
    when "float" then return "￥#{format % var}"
    else
      return var
    end
  end


  #购物车返回数量
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-29 13:11:06
  #
  # ==== 参数
  # * <tt>cookies</tt> - 购物车
  # * <tt>id</tt> - 商品ID
  # * <tt>count</tt> - 数量
  # ==== 示例
  #    {{ cookies | get_cart_count:product.id "count" }}
  #
  # ==== 返回
  #      Integer
  #
  def get_cart_count(hash,id,count)
    if hash  && id && count
      return   hash["#{id}"][count]
    else
      return 0
    end
  end


  # 返回购物车所有商品数量
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-29 13:11:06
  #
  # ==== 参数
  # * <tt>cookies</tt> - 购物车
  # * <tt>id</tt> - 商品ID
  # * <tt>count</tt> - 数量
  # ==== 示例
  #    {{ cookies | get_cart_total_count }}
  #
  # ==== 返回
  #      Integer
  #
  def get_cart_total_count(cookies)
    ShopCart.cart_count(cookies.to_json)
  end

  # 返回购物车某商品小计
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-29 13:11:06
  #
  # ==== 参数
  # * <tt>cookies</tt> - 购物车
  # * <tt>ID</tt> - 产品ID
  # * <tt>type</tt> - 商品类型
  # ==== 示例
  #    {{ cookies | get_cart_item_price:product.id "shop_product" }}
  #
  # ==== 返回
  #      Integer
  #
  def get_cart_item_price(cookies,id,type = ShopCart::SHOP_PRODUCT)
    price = 0.0
    price =  ShopCart.get_item_price(cookies.to_json,id.to_i,type)
    return  "%.2f" % price
  end
 

  #生成商品搜索过滤url
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-28
  #
  # ==== 参数
  # * <tt>q</tt> - 搜索词
  # * <tt>param_category_ids</tt> - 当前分类id条件
  # * <tt>parent_category_id</tt> - 上级分类
  # * <tt>category_id</tt> - 本级分类
  # * <tt>order</tt> - 排序
  # ==== 示例
  #   {{q | generate_shop_search_filter_url:category_ids, root_category.id, 0, order}}
  #
  # ==== 返回
  #   String
  #
  def generate_shop_search_filter_url(q, param_category_ids, parent_category_id, category_id, order)
    category_ids = Hash[param_category_ids.clone.split(",").map{|category| category.split("_")}]
    parent_category_id = parent_category_id.to_s
    category_id = category_id.to_i
    order = filter_order_by(order)
    url_arr = Array.new

    url_arr << "q-#{q}" if q.present?
    if category_id.to_i == 0
      category_ids.delete(parent_category_id)
    else
      category_ids[parent_category_id] = category_id
    end
    url_arr << "category_id-#{category_ids.map{|c| "#{c[0]}_#{c[1]}"}.join(",")}" if category_ids.present?

    url_arr << "order-#{order}" if order

    return url_arr.join("|")
  end

  #过滤排序规则
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-28
  #
  # ==== 参数
  # * <tt>order</tt> - 排序规则
  # ==== 示例
  #   filter_order_by("created_at desc")
  #
  # ==== 返回
  #   String
  #
  def filter_order_by(order)
    order_template = ["created_at desc", "created_at asc", "pointer desc", "pointer asc"]
    return order if order_template.include?(order)
  end

  #生成分类选择状态
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-28
  #
  # ==== 参数
  # * <tt>param_category_ids</tt> - 当前分类id条件
  # * <tt>parent_category_id</tt> - 上级分类
  # * <tt>category_id</tt> - 本级分类
  # ==== 示例
  #   {{category_ids | generate_shop_search_selection_status:root_category.id, category.id}}
  #
  # ==== 返回
  #   String
  #
  def  generate_shop_search_selection_status(param_category_ids, root_category_id, category_id)
    category_ids = Hash[param_category_ids.clone.split(",").map{|category| category.split("_")}]
    if category_ids[root_category_id.to_s].to_s == category_id.to_s
      return "selected"
    end
  end


  #获取订单物流信息
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-06-28
  #
  # ==== 参数
  # * <tt>order_id</tt> - 订单号
  # ==== 示例
  #
  #  {{ order.id | get_logistic }}
  #
  # ==== 返回
  #   String
  #
  def get_logistic(order_id)
    str_info = ""
    Logistic.get_logistics(order_id).reverse_each do |logistic|
      str_info +=  "<li>#{logistic["context"]}  <span> #{logistic["time"]}  </span></li>"
    end
    str_info

  end

  #获取订单快递公司名字
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-06-28
  #
  # ==== 参数
  # * <tt>order_id</tt> - 订单号
  # ==== 示例
  #
  #  {{ order.id | get_logistic }}
  #
  # ==== 返回
  #   String
  #
  def get_logistic_name(str_name)
    logistic =  Logistic::LOGISTIC_COM.select {|key| key[1] == str_name}
    logistic = logistic.flatten
    logistic.first
  end


  #获取订单商品数量
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-7-9 9:38:43
  #
  # ==== 参数
  # * <tt>orders</tt> - 订间集合
  # ==== 示例
  #
  #  {{ products | get_order_item_count }}
  #
  # ==== 返回
  #   String
  #
  def get_order_item_count(orders)
      orders.inject(0){|count,order| count += order.item_count ; count }
  end




  Dir[File.dirname(__FILE__) + '/template_methods/*.rb'].each { |f| require f }
  Liquid::Template.register_filter(LiquidFilters)
end
