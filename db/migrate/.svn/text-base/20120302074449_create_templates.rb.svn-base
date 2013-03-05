class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :name,             :string                 #模板名称
      t.column :description,      :string                 #模板描述
      t.column :content,          :text                   #模板内容
      t.column :template_type,    :integer, :limit => 2, :default => 0 #模板类型
      t.column :template_status,  :boolean, :default => false #是否为默认模板

      t.references :info_model
      
      t.timestamps
    end
  end
end
