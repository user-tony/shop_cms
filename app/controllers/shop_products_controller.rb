#encoding: UTF-8
class ShopProductsController < BaseController


  # 验证用户是否登陆
  #
  # 作者：佟立家
  # 更新时间：2012-6-29 14:43:09
  before_filter :authenticate_member! ,:only => [:order_address, :generate_order, :buy_product, :comment_save, :delete_order_address]
   
  # 商城首页
  #
  # 作者：李季
  # 更新时间：2012-04-20 
  def index
    session[:notice] = nil
    render_404("该栏目不存在。") and return unless channel = Channel.find_by_id(params[:channel_id])
    liquid_render channel.template_id_index, :liquid => {"channel" => channel, "notice" => session[:notice]}
  end
  
  # 商品显示页
  #
  # 作者：
  # 更新时间：2012-04-20 
  
  def show
    render_404 and return unless shop_product = ShopProduct.find_by_id(params[:id])
    render_404("该栏目不存在。") and return unless channel = Channel.find_by_id(params[:channel_id])
    template_id = channel.template_id_detail
    liquid_render template_id, :liquid => {
      "shop_product" => shop_product,
      "channel" => channel,
      "notice" => session[:notice]
    }
   
  end
  
  # 提交订单
  #
  # 作者：李季
  # 更新时间：2012-04-20 
  
  def submit_order
    model = InfoModel.where(:model_name => 'Order').first
    channel = model.channels.first
    shop_product = ShopProduct.find_by_id(params[:order][:item_id])
    price = shop_product.price.to_f
    scode = Order.generate_order_scode
    amount = price * params[:order][:item_count].to_i
    order = Order.new(:recipient_name => params[:order][:recipient_name],
      :amount => amount,
      :scode => scode,
      :phone => params[:order][:phone],
      :qq => params[:order][:qq],
      :address => params[:order][:address],
      :remark => params[:order][:remark],
      :client_ip => request.remote_ip
    )

    order.order_products.new(
      :item_id => params[:order][:item_id],
      :price => price,
      :item_type => "ShopProduct",
      :item_count => params[:order][:item_count]
    )
    
    if order.save
      session[:notice] = nil
      if $cms_global_variable["mail_order_enable"].present?
        source_email = $cms_global_variable["send_mail_address"]
        to_email = $cms_global_variable["receive_mail_address"]
        password = $cms_global_variable["mail_order_cipher"]
        orderid = order.id
        web_site = $cms_global_variable["web_site_url"]
        Resque.enqueue(OrderMail, order,orderid,web_site,source_email,to_email,password)
      end
      #      redirect_to "/payment/alipay/get_page?id=#{order.id}"
      redirect_to "/shop/#{channel.path_customize}/#{order.id}"
    else
      render :text => '<script type="text/javascript">alert("订单提交失败，请重新提交！");history.back();</script>'
    end
  end
  
  # 订单详细信息页
  #
  # 作者：李季
  # 更新时间：2012-04-20 
  
  def order_info
    render_404 and return unless order = Order.find_by_id(params[:id])
    notice = "提交成功"
    if params[:notice].present?
      notice = params[:notice]
    end

    item_id = order.order_products.first.item_id
    shop_product = ShopProduct.find_by_id(item_id)
    shop_product_name = shop_product.name
    render_404("该栏目不存在。") and return unless channel = Channel.find(params[:channel_id])
    template_id = channel.template_id_detail
    liquid_render template_id, :liquid => {
      "shop_product" => shop_product_name,
      "order" => order,
      "notice" => notice
    }
  end
  
  
  # 返回物流信息记录
  #
  # 作者：佟立家
  # 更新时间：2012-6-20
  def logistics
    logistics = Logistic.get_logistics(params[:id])
    render :json => logistics.to_json
  end


  #  添加评论
  #
  # 作者：赵晓龙
  # 更新时间：2012-6-29
  def comment_save
    shop_product = ShopProduct.find_by_id(params[:id])
    comment = Comment.new(
      :item_type => shop_product.class.name,
      :item_id => shop_product.id,
      :member_id => current_member.id,
      :content => KeyWordFilter.replace_content(params[:content]),
      :status => $cms_global_variable["comment_default_status"].to_s == "true" ? Comment::STATUS_PASSED : Comment::STATUS_NOT_PASSED
    )
    unless comment.save
      flash[:error] = comment.errors.messages.map{|m| m[1]}.join(",")
    end
    
    redirect_to :back
  end


  
  # 添加商品信息
  #
  # 作者：佟立家
  # 更新时间：2012-6-20
  def add_product
    cookies[:shop_cart] = { :value => ShopCart.add_product(cookies[:shop_cart], params[:id].to_i, params[:num].to_i) }
    ShopCart.total_price(cookies[:shop_cart])
    shop = ShopProduct.find_by_id(params[:id])     if params[:type].blank? || params[:type] == ShopCart::SHOP_PRODUCT
    if shop
      hash = { :count => ShopCart.cart_count(cookies[:shop_cart]), :name => shop.name, :price => shop.price , :status => true }
    else
      hash = { :status => false }
    end
    render :json =>  hash.to_json
  end



  #立即购买产品
  #
  # 作者：佟立家
  # 更新时间：2012-6-27 13:18:52
  def buy_product
    if  params[:product_type] == "shop_product" && params[:product_id].to_i > 0  
      quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1
      shop = ShopProduct.find_by_id(params[:product_id])
      redirect_to :back  and  return "商品不合法"   unless shop.present?
      redirect_to order_address_shop_products_path(:product_id => params[:product_id], :quantity => quantity )
    else
      flash[:notice] = "参数不正确"
      redirect_to :back
    end
  end


  # 删除商品信息
  #
  # 作者：佟立家
  # 更新时间：2012-6-27 13:18:52
  def destroy_product
    cookies[:shop_cart] = { :value => ShopCart.del_product(cookies[:shop_cart], params[:id].to_i) }
    ShopCart.total_price(cookies[:shop_cart])
    count = ShopCart.total_price(cookies[:shop_cart])
    render :json => { total_price:count}
  end

  # 清空购物车
  #
  # 作者：佟立家
  # 更新时间：2012-6-20
  def clear_cart
    cookies.delete :shop_cart
    redirect_to :back
  end

  # 我的购物车
  #
  # 作者：佟立家
  # 更新时间：2012-6-20
  def my_cart
    template = Template.find_by_id(18)
    render_404("模版不存在") and return   unless template
    liquid_render 18, :liquid => {
      "list" => ShopCart.get_cart(cookies[:shop_cart]),
      "total_price" => ShopCart.total_price(cookies[:shop_cart]),
      "shop" => Channel.where("info_model_id=2").first     #商城栏目
    }
  end

  # 修改购物车信息(cookies)
  #
  # 作者：佟立家
  # 更新时间：2012-6-27 9:20:37
  def modify_cart_info
    id = params[:id]
    type = params[:type]
    count = params[:count]
    return 0   unless id && type && count
    cookies[:shop_cart] = ShopCart.modify_shop_product_count(cookies[:shop_cart],id,count,type)
    render :json => { :id => id , :type => params[:type] , :count => count, :total_price => ShopCart.total_price(cookies[:shop_cart]), :price => ShopCart.get_item_price(cookies[:shop_cart],id,type) }.to_json
  end

  # 订单地址
  #
  # 作者：佟立家
  # 更新时间：2012-6-27 9:20:37
  def order_address
    hash = { "list" => current_member.order_addresses.order("created_at DESC")   }
    hash["product_id"] = params[:product_id] if params[:product_id]
    hash["quantity"] = params[:quantity] if params[:quantity]
    liquid_render 19, :liquid => hash
  end
  
  # 添加订单地址
	#
  # 作者：佟立家
  # 更新时间：2012-6-27 9:20:37
  def add_order_address
    order_address = OrderAddress.new({
        :name => params[:name],
        :phone => params[:phone],
        :area_province_id => params[:country_id].split("-")[0],
        :area_city_id => params[:country_id].split("-")[1],
        :area_country_id => params[:country_id].split("-")[2],
        :address => params[:address],
        :zip_code => params[:zip_code],
        :member_id => current_member.id
      })
    order_address.save
    address_str = "#{order_address.area_province.name}#{order_address.area_city.name}#{order_address.area_country.name}#{order_address.address}"
    render :json => {
      :address => address_str,
      :name => order_address.name,
      :id => order_address.id
    }
		
  end
  
  # 删除订单收货地址
	#
  # 作者：佟立家
  # 更新时间：2012-6-27 9:20:37
  def delete_order_address
     ship = current_member.order_addresses.where("id = ?", params[:id]).first
      if ship && ship.destroy
  	     render :js => '$("#address_' + ship.id.to_s + '").remove();selectAddress($(".gm-address-list ul li").first().attr("address-id"));'
      else
         render :js => 'alert("删除失败");'
      end  
  end

  # 生成订单
	#
  # 作者：佟立家
  # 更新时间：2012-6-27 9:20:37
  def generate_order
    
    #如果是立即购买 组成一个hash
    if params[:product_id] && params[:quantity]
      hash = {"shop_product" => {params[:product_id].to_s => { "count" => params[:quantity].to_i}}}.to_json
    end
    order_address  = OrderAddress.find_by_id(params[:address_id])
    unless params[:address_id].present? || order_address.present?
      flash[:error] = "请选择有效的收货地址"
      redirect_to :back and return
    end
    cart = hash || cookies[:shop_cart]
    order = Order.create_order(cart,
      current_member.id,
      params[:content],
      params[:address_id],
      request.remote_ip,
      order_address.phone,  
      order_address.name,
      order_address.get_address
    )
    if order && order.id
      cookies.delete :shop_cart unless params[:product_id]  #清空购物车
      if $cms_global_variable["mail_order_enable"].present?
        source_email = $cms_global_variable["send_mail_address"]
        to_email = $cms_global_variable["receive_mail_address"]
        password = $cms_global_variable["mail_order_cipher"]
        orderid = order.id
        web_site = $cms_global_variable["web_site_url"]
        Resque.enqueue(OrderMail, order,orderid,web_site,source_email,to_email,password)
      end
      redirect_to payment_my_order_path(order.id, :goto_url => my_order_path(order.id))
    else
      flash[:error] = order.errors.messages.map{|m| m[1]}.join(",")
      redirect_to :back
    end
  end

  # 返回省份地址信息
	#
  # 作者：佟立家
  # 更新时间：2012-6-27 9:20:37
  def get_address_info
   render :text => AreaProvince.address_data
  end

  # 异步获取评论
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-07-13
  def ajax_comments
    #商品
    shop_product = ShopProduct.find_by_id(params[:id])
    #判断用户是否登陆，并且成功购买过此产品
    show_comment_form = current_member && shop_product.has_buy?(current_member.id)
    #评论记录
    comments = Comment.where("item_type = 'ShopProduct' AND item_id = ?", params[:id].to_i)
    comments = comments.page(params[:page]).per(10)
    liquid_render 25, :liquid => {
      "id" => params[:id],
      "comments" => comments,
      "page_param" => "url=/shop_products/ajax_comments/#{params[:id]}",
      "show_comment_form" => show_comment_form
    }
  end

  # 异步获取购买记录
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-07-13
  def ajax_buy_logs
     #购买记录
    buy_logs = OrderProduct.get_buy_log(params[:id].to_i).page(params[:page]).per(10)
    liquid_render 26, :liquid => {
      "buy_logs" => buy_logs,
      "page_param" => "url=/shop_products/ajax_buy_logs/#{params[:id]}"
    }
  end
end