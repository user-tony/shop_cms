class Shop::IndexController < BaseController
  def index
    #读取10个商品
    @hot_shop_products = ShopProduct.where("product_status = ?", ShopProduct::STATUS_SELL)
    #读取10个套餐
    @hot_shop_packages = ShopProduct.where("product_status = ?", ShopProduct::STATUS_SELL)
  end

  # 搜索
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2012-06-27
  def search
    params_arr = Hash[params[:search_condition].to_s.split("|").map{|param| param.split("-")}]
    q = params_arr["q"]
    category_ids = Hash[params_arr["category_id"].to_s.split(",").map{|category| category.split("_")}]
    order = params_arr["order"] || "position asc, created_at desc"

    category = nil
    if q.present? && category_ids.blank? && category = ShopCategory.where("name = ?", q).first
       category_ids  =  ShopCategory.where("parent_id = ? ", category.id ).inject({}){ |hash,category| hash["#{category.parent_id}_#{category.id}"] = category.id; hash  }
    end

    products = ShopProduct.order(order)
    products = products.where("name like ?", "%#{q}%") if q.present? && category.blank?
    products = products.joins("INNER JOIN shop_product_category_relations ON shop_product_category_relations.shop_product_id = shop_products.id").where("shop_category_id in (?)", category_ids.map{|category| category[1]}) if category_ids.present?
    products = products.page(params[:page]).per(16)

    shop_categories = ShopCategory.parent_id(1)     #查找二级分类

    liquid_render 20, :liquid => {
      "q" => q,
      "category_ids" => params_arr["category_id"].to_s,
      "order" => order,
      "root_categories" => ShopCategory.where(:parent_id => 1),
      "products" => products,
      "category_name" => category.present? ? category.name : nil,
      "shop_categories" => shop_categories
    }
  end
end
