class CreateProductContents < ActiveRecord::Migration
  def change
    create_table :product_contents, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      
      t.column :item_id ,            :integer               #类型id
      t.column :item_type,           :string                #类名称
      t.column :content,             :text                  #内容
       t.column :deleted_at,   :datetime                                                                #软删除字段(非空为软删除数据)

      t.timestamps
    end
  end
end
