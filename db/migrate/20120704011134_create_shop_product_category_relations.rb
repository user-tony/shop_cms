class CreateShopProductCategoryRelations < ActiveRecord::Migration
  def self.up
    create_table :shop_product_category_relations , :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      #--------------外健---------------------------
      t.references :shop_category                                  #商品分类（外健）
      t.references :shop_product                                   #商品(外健)
      #--------------------------------------------
      t.timestamps
    end

    remove_column  :shop_products, :shop_category_id             #删除商品的分类id列
  end

  def self.down
    drop_table :comments

    add_column  :shop_products, :shop_category_id, :integer       #添加商品的分类id列
  end
end
