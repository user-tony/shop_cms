class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|

      t.column :name,         :string,         :limit => 50,     :null => false                       #产品名称
      t.column :description,  :string,         :limit => 200                                          #产品摘要
      t.column :position,           :integer, :default => 0    #排序
      t.column :deleted_at,   :datetime                                                               #软删除字段(非空为软删除数据)
      t.column :product_color,  :string                                                               #产品颜色

      #--------------外健---------------------------
      t.references :product_category                                                                 #产品分类（外健）
      t.references :channel                                                                          #栏目id(外健)
      #--------------------------------------------
      t.timestamps
    end
  end
end
