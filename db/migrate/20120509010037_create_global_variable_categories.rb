class CreateGlobalVariableCategories < ActiveRecord::Migration
  def change
    create_table :global_variable_categories, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.column :name,      :string, :limit => 50                         #分类名称
      t.column :parent_id,   :integer,   :default => 0                   #上级id
      t.column :depth,   :integer,   :default => 0                       #深度
      t.column :description,   :string, :limit => 500                    #描述
      t.column :level,   :integer,   :default => 0                       #配置级别
      t.column :position,     :integer,        :default  => 0            #排序字段
      t.timestamps
    end
  end
end
