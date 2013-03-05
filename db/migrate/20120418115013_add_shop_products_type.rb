class AddShopProductsType < ActiveRecord::Migration
  def up
    add_column :shop_products , :shop_product_type,  :integer                   #商品类型
    add_column :shop_products , :try_price,  :float, :default => 0                             #试用价格
  end                                                   

  def down
    self.remove_column :shop_products,  :shop_product_type
    self.remove_column :shop_products , :try_price
  end
end
