class CreateGlobalVariableAttrachments < ActiveRecord::Migration
  def change
    create_table :global_variable_attrachments, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :global_variable_id,         :integer 
      
      t.column :deleted_at, :datetime
      t.column :position, :integer
      
      t.column :thumb_file_name,            :string                                                  #文件名称
      t.column :thumb_content_type,         :string                                                  #文件类型
      t.column :thumb_file_size,           :integer                                                  #文件大小
      t.column :thumb_updated_at,         :datetime   

      t.timestamps
    end
  end
end
