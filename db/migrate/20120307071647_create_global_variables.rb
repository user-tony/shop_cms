#encoding: UTF-8
class CreateGlobalVariables < ActiveRecord::Migration
  def change
    create_table :global_variables, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      ## 变量名称
      t.column :name,          :string,    :limit => 50,   :null => false
      ## 变量键名
      t.column :key_name,      :string,    :limit => 50,   :null => false
      ## 变量类型
      t.column :var_type,      :integer
      ## 变量值
      t.column :content,       :text
      ## 变量描述信息
      t.column :description,   :string,    :limit => 255
      
      t.column :deleted_at, :datetime
      t.column :position, :integer
      
      t.timestamps
    end
  end
end
