class CreateZhaopins < ActiveRecord::Migration
  def change
    create_table :zhaopins, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|

      t.column :position,      :string,   :default => false                      #职位
      t.column :education,     :string                                           #学历
      t.column :age ,          :string                                           #年龄
      t.column :experience,    :string                                           #经验
      t.column :salary,        :string                                           # 薪资
      t.column :contact_user,  :string                                           #联系人
      t.column :contact_tel,   :string                                           #联系电话
      t.column :description,   :string                                           #工作描述
      t.column :deleted_at,     :datetime                                       #软删除字段(非空为软删除数据)
      #--------------外健---------------------------
      t.references :member                                                      #发布人员
      t.references :channel                                                     #栏目ID
      #--------------------------------------------
      t.timestamps
    end
  end
end
