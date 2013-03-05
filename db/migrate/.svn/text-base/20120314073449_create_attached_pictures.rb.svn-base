class CreateAttachedPictures < ActiveRecord::Migration
  def change
    create_table :attached_pictures, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|

      t.column :item_id ,            :integer                                                        #类型id
      t.column :item_type,           :string                                                         #类名称
      t.column :deleted_at,   :datetime                                                              #软删除字段(非空为软删除数据)
      #-------------产品图片------------------------
      t.column :thumb_file_name,            :string                                                  #文件名称
      t.column :thumb_content_type,         :string                                                  #文件类型
      t.column :thumb_file_size,           :integer                                                  #文件大小
      t.column :thumb_updated_at,         :datetime                                                  #文件更新时间
      #---------------------------------------------
      t.timestamps
    end
  end
end
