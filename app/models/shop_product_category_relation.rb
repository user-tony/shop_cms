class ShopProductCategoryRelation < ActiveRecord::Base
  belongs_to :shop_category
  belongs_to :shop_product
end
