class AddDescriptionToShopProducts < ActiveRecord::Migration
  def up
    add_column  :shop_products, :description, :string, :length => 500 #描述
  end

  def down
    remove_column  :shop_products, :description
  end
end
