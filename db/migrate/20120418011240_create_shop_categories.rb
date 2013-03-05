#encoding: UTF-8
class CreateShopCategories < ActiveRecord::Migration
  def change
    create_table :shop_categories, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :name,         :string,         :limit => 30,         :null => false                   #商品分类名称
      t.column :position,     :integer,        :default  => 0                                         #排序字段
      t.column :description,  :string,         :limit    => 200                                       #分类描述
      t.column :deleted_at,   :datetime                                                               #软删除字段(非空为软删除数据)
      t.column :keyword,      :string, :limit => 100                                                  #关键词
      t.column :path_customize,:string, :limit => 30                                                  #ID自定义
      t.column :parent_node, :boolean , :default => false                                             #ID自定义

      #--------------多级菜单--------------------------------
      t.column :lft,          :integer                                                                #左节点
      t.column :rgt,          :integer                                                                #右节点
      t.column :parent_id,    :integer                                                                #父节点
      #-------------------------------------------------------
      t.timestamps
    end
    say "create_shop_categoies"
    puts "商品分类数据导入完成..." if ShopCategory.create(:name => "根节点",:parent_node => true)
  end
end
