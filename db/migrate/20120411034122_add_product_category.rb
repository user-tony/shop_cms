#encoding: UTF-8
class AddProductCategory < ActiveRecord::Migration
  def up
    add_column :product_categories, :parent_node, :boolean
    ProductCategory.reset_column_information
    #产品分类
    puts "产品分类数据导入完成..." if ProductCategory.create(:name => "根节点",:parent_node => true)
  end
  
  def down
    remove_column :product_categories, :parent_node
  end
end
