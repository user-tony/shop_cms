# To change this template, choose Tools | Templates
# and open the template in the editor.

class ShopCart


  # 商品
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  #
  #
  # ==== 示例
  #    Cart::SHOP_PRODUCT
  #
  # ==== 返回
  #   "shop_product"
  #
  SHOP_PRODUCT = "shop_product"
  
  # 商品套餐
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  #
  # ==== 示例
  #    Cart::SHOP_PACKAGE
  #
  # ==== 返回
  #   "shop_package"
  #
  SHOP_PACKAGE = "shop_package"



  # 获取cookie值
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  #
  #  <tt>cart_cookies </tt> ----cookies 值
  #
  # ==== 示例
  #    Cart.get_cart(cookies[:cart]
  #
  # ==== 返回
  #    
  #   {"shop_product"=>{"3"=>{"count"=>2}, "package"=>{"4"=>{"count"=>2}}}   / {}
  #
  def self.get_cart(cart_cookies)
    cart_cookies.present? ? (ActiveSupport::JSON.decode(cart_cookies)) : {}
  end




  #添加产品
  #  注： 可以验证当前添加产品是否存在
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  #
  # ==== 参数
  #      <tt>cookies </tt> ----cookies 值
  #      <tt>id </tt> ---- 商品ID
  #      <tt>quantity </tt> ---- 商品数量
  #      <tt>type </tt> ---- 商品/套餐 默认为商品(SHOP_PRODUCT)
  #
  # ==== 示例
  #   ShopCart.add_product(cookies[:shop_cart],4,1,"shop_product")
  #
  # ==== 返回
  #    "{\"product\":{\"4\":{\"count\":1}},\"shop_product\":{\"4\":{\"count\":1},\"1\":{\"count\":1}}}"
  #
  def self.add_product(cookies,id,quantity = 1, type = SHOP_PRODUCT)
    hash = get_cart(cookies)
    if  hash[type]
      if hash[type].key?(id.to_s)
        hash[type][id.to_s]["count"] = hash[type][id.to_s]["count"].to_i +  quantity.to_i
      else
        hash[type][id.to_s] =  {"count" => quantity.to_i}
      end
    else
      hash[type] = { id => {"count" => quantity.to_i}}
    end
    hash.to_json
  end
  #
  #   修改购物车商品数量
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  #
  # ==== 参数
  #      <tt>cookies </tt> ----cookies 值
  #      <tt>id </tt> ---- 商品ID
  #      <tt>quantity </tt> ---- 商品数量
  #      <tt>type </tt> ---- 商品/套餐 默认为商品(SHOP_PRODUCT)
  #
  # ==== 示例
  #   ShopCart.add_product(cookies[:shop_cart],4,1,"shop_product")
  #
  # ==== 返回
  #    "{\"product\":{\"4\":{\"count\":1}},\"shop_product\":{\"4\":{\"count\":1},\"1\":{\"count\":1}}}"
  #
  def self.modify_shop_product_count(cookies,id,quantity = 1, type = SHOP_PRODUCT)
    hash = get_cart(cookies)
    hash[type][id.to_s]["count"] = quantity if hash[type] &&  hash[type].key?(id.to_s)
    hash.to_json
  end


  # 减少产品
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  # ==== 参数
  #      <tt>cookies </tt> ----cookies 值
  #      <tt>id </tt> ---- 商品ID
  #      <tt>quantity </tt> ---- 商品数量
  #      <tt>type </tt> ---- 商品/套餐 默认为商品(SHOP_PRODUCT)
  #
  #
  # ==== 示例
  #    ShopCart.minus_product(cookies[:shop_cart],4)

  #
  # ==== 返回
  #   "{\"product\":{\"4\":{\"count\":1}},\"shop_product\":{\"4\":{\"count\":1},\"1\":{\"count\":1}}}"
  #
  def self.minus_product(cookies,id,quantity = 1,type = SHOP_PRODUCT)
    hash = get_cart(cookies)
    if  hash[type] && hash[type].key?(id.to_s)
      if hash[type][id.to_s]["count"].to_i <= 1
        hash[type].delete(id.to_s)
      else
        hash[type][id.to_s]["count"].to_i -= quantity
      end
    end
    hash.to_json
  end


  # 删除产品
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  #
  #
  # ==== 示例
  #    Cart.del_product(cookies,id,type = SHOP_PRODUCT)
  # ==== 参数
  #      <tt>cookies </tt> ----cookies 值
  #      <tt>id </tt> ---- 商品ID
  #      <tt>type </tt> ---- 商品/套餐 默认为商品(SHOP_PRODUC)
 
  #
  # ==== 返回
  #    返回 加密后的cookies值
  #
  def self.del_product(cookies,id,type = SHOP_PRODUCT)
    hash =  get_cart(cookies)
    hash[type].delete(id.to_s)
    hash.to_json
  end




  # 购物车产品总价格
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  # ==== 参数
  #      <tt>cookies </tt> ----cookies 值
  #
  # ==== 示例
  #  {"product"=>{"4"=>{"count"=>1}}, "shop_product"=>{"4"=>{"count"=>1}, "1"=>{"count"=>2}}}
  #
  # ==== 返回
  #   总价
  #
  def self.total_price(cookies)
    price = 0.0
    hash = get_cart(cookies)                   #获取购物车HASH
    return  price  unless  hash.present?        #如果购物车为空返回 0.0
    price += total_shop_package_price(hash)  #计算商品套餐的总价
    price += total_shop_product_price(hash)  #计算商品的总价
    price
  end



  #  购物车里商品套餐的总价格
  #  计算方式： 单价 * 数量
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  # ==== 参数
  #      <tt>hash </tt> ----hash 值
  #
  # ==== 示例
  #       hash =  {"product"=>{"4"=>{"count"=>1}}, "shop_product"=>{"4"=>{"count"=>1}, "1"=>{"count"=>2}}}
  #     total_shop_package_price(hash)
  # ==== 返回
  #   商品套餐总价
  #
  def self.total_shop_package_price(hash)
    price = 0.0
    return  price  unless  hash.present?
    if hash[SHOP_PACKAGE]
      #计算商品套餐
      hash[SHOP_PACKAGE].keys.each do |pack_id|
        if  package = ShopPackage.find_by_id(pack_id)
          price += package.price.to_f * hash[SHOP_PACKAGE][pack_id].values.first
        end
      end
    end
    price
  end


  #  购物车里商品的总价格
  #  计算方式： 单价 * 数量
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  # ==== 参数
  #      <tt>hash </tt> ----hash 值
  #
  # ==== 示例
  #       hash =  {"product"=>{"4"=>{"count"=>1}}, "shop_product"=>{"4"=>{"count"=>1}, "1"=>{"count"=>2}}}
  #     total_shop_product_price(hash)
  # ==== 返回
  #   商品总价
  #
  def self.total_shop_product_price(hash)
    price = 0.0
    return  price  unless  hash.present?
    if hash[SHOP_PRODUCT]
      #计算商品总价
      hash[SHOP_PRODUCT].keys.each do |shop_id|
        if  shop = ShopProduct.find_by_id(shop_id)
          price += shop.price.to_f * hash[SHOP_PRODUCT][shop_id].values.first.to_f
        end
      end
    end
    price
  end




  # 购物车产品数量
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  #
  # ==== 示例
  #   ShopCart.cart_number(cookies[:cart])
  #
  # ==== 返回
  #
  #
  def self.cart_count(cookies)
    hash  = get_cart(cookies)
    count = 0
    if hash.present?
      #计算有多少个商品
      # if  hash[SHOP_PRODUCT]
      #   hash[SHOP_PRODUCT].each do |key,value|
      #     count += hash[SHOP_PRODUCT][key]["count"].to_i
      #   end
      # end
      #计算有多少个套餐
      # if  hash[SHOP_PACKAGE]
      #   hash[SHOP_PACKAGE].each do |key,value|
      #     count += hash[SHOP_PRODUCT][key]["count"].to_i
      #   end
      # end
           count += hash[SHOP_PRODUCT].count if  hash[SHOP_PRODUCT]    #计算有多少个商品
           count += hash[SHOP_PACKAGE].count if  hash[SHOP_PACKAGE]   #计算有多少个套餐
    end
    return count
  end



  # 购物车单品小计
  #
  # 作者: 佟立家
  # 最后更新时间: 2012-6-26 8:14:52
  #
  # ==== 示例
  #
  #
  # ==== 返回
  #
  #
  def self.get_item_price(cookies,id,type = SHOP_PRODUCT)
    hash = get_cart(cookies)
    price  = 0.0
    if type == SHOP_PRODUCT
      product = ShopProduct.find_by_id(id)
    elsif type == SHOP_PACKAGE
      product = ShopPackage.find_by_id(id)
    end
    return price unless product.present?
    price = product.price.to_f * hash[type][id.to_s]["count"].to_i  if hash[type].key?(id.to_s)
    return price
  end



end
