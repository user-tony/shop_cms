class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      
      t.column :title,           :string,         :null => false ,  :limit => 50        #文件标题
      t.column :view_count,      :integer,         :default => 0                         #查看数量
      t.column :description,     :string,         :limit => 200                         #文章摘要
      t.column :recomment,       :integer,         :default => 0                         #推荐字段(0为不推荐)
      t.column :article_status,  :integer,         :default => 0                         #审核字段(0为未审核)
      t.column :deleted_at,     :datetime                                               #软删除字段(非空为软删除数据)

      #--------------外健---------------------------
      t.references :channel
      t.references :member
      #--------------------------------------------

      #-------------文章图片------------------------
      t.column :thumb_file_name,            :string                                                  #文件名称
      t.column :thumb_content_type,         :string                                                  #文件类型
      t.column :thumb_file_size,           :integer                                                  #文件大小
      t.column :thumb_updated_at,         :datetime                                                  #文件更新时间
      #---------------------------------------------
      
      t.timestamps
      
    end
    add_index :articles, :channel_id
    add_index :articles, :member_id
  end
end
