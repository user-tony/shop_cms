class CreateArticleContents < ActiveRecord::Migration
  def change
    create_table :article_contents, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      
      t.column :content,  :text              #文章内容
      t.column :deleted_at,   :datetime                                                                #软删除字段(非空为软删除数据)

      
      #--------------外健---------------------------
      t.references :article                 #文章id
      #----------------------

      t.timestamps
    end
    add_index :article_contents, :article_id
  end
end
