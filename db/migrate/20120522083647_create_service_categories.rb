class CreateServiceCategories < ActiveRecord::Migration
  def change
    create_table :service_categories, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :name, :string, :length => 50, :null => false    #分类名称
      t.column :position, :integer, :default => 0               #排序
      t.column :description, :string                            #描述
      t.timestamps
    end
  end
end
