class CreateShopPackages < ActiveRecord::Migration
  def change
    create_table :shop_packages, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      
      t.column :name,  :string                    #套餐名称
      t.column :market_price,       :float,   :default => 0    #市场价
      t.column :price,              :float,   :default => 0    #价格
      t.column :product_status,     :integer, :default => 0    #状态
      t.column :stock,              :integer, :default => 0    #库存
      t.column :position,           :integer, :default => 0    #排序
      t.column :deleted_at,         :datetime                  #软删除字段(非空为软删除数据)

      t.timestamps
      
    end
  end
end
