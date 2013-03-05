class CreateOrderProducts < ActiveRecord::Migration
  def change
    create_table :order_products, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.column :item_type,            :string                 #产品类型（多态）
      t.column :item_id,              :integer                #产品类型（多态）
      t.column :price,                :float,   :default => 0 #价格
      t.column :item_count,           :integer, :default => 0 #数量
      t.column :deleted_at,           :datetime               #软删除字段(非空为软删除数据)

      t.references :order

      t.timestamps
    end
    add_index :order_products, :order_id
  end
end
