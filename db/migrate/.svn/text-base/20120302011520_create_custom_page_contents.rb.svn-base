class CreateCustomPageContents < ActiveRecord::Migration
  def change
    
    create_table :custom_page_contents, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|


      t.column :content,        :text                                    #自定义页内容
      #--------------外健---------------------------
      t.references :custom_page                                          #自定义页ID（外健）
      #--------------------------------------------
      t.timestamps

      
    end
  end
end
