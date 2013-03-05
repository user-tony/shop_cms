class AddShopProductShopCategoryId < ActiveRecord::Migration
  def up
    add_column :shop_products , :shop_category_id, :integer           #商品分类
  end

  def down
    remove_column :shop_products , :shop_category_id
  end
end
