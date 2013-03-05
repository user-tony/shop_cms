class CreateCustomPages < ActiveRecord::Migration
  def change
    create_table :custom_pages, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8'  do |t|

      t.column :name,         :string,         :limit => 30                                      #自定义名称
      t.column :deleted_at,            :datetime                                                 #软删除字段(非空为软删除数据)
      t.column :description,  :string                                                            #自定义摘要

      #--------------外健---------------------------
      t.references :channel                                                                        #栏目id（外健）
      #--------------------------------------------

      t.timestamps
    end
  end
end
