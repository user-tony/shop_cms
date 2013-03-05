class CreateShopProductPackageRelations < ActiveRecord::Migration
  def change
    create_table :shop_product_package_relations, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|

      t.column :product_count,  :integer                   #数量
      t.column :deleted_at,     :datetime                  #软删除字段(非空为软删除数据)
      
      t.references :shop_package
      t.references :shop_product

      t.timestamps
    end
    add_index :shop_product_package_relations, :shop_package_id
    add_index :shop_product_package_relations, :shop_product_id
  end
end
