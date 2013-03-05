#encoding: UTF-8
class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :name,         :string,         :limit => 30,         :null => false                   #产品分类标题
      t.column :position,     :integer,        :default  => 0                                         #排序字段
      t.column :description,  :string,         :limit    => 200                                       #分类描述
      t.column :deleted_at,   :datetime                                                               #软删除字段(非空为软删除数据)
      t.column :keyword,      :string, :limit => 100                                                  #关键词
      t.column :path_customize,:string, :limit => 30                  #ID自定义

      #--------------多级菜单--------------------------------
      t.column :lft,          :integer                                                                #左节点
      t.column :rgt,          :integer                                                                #右节点
      t.column :parent_id,    :integer                                                                #父节点
      #-------------------------------------------------------

      #--------------外健---------------------------
      t.references :channel                                                                          #栏目id(外健)
      #--------------------------------------------
      t.timestamps
    end
  end
end
