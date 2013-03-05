class CreateMemberInfos < ActiveRecord::Migration
  def change
    create_table :member_infos, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :name, :string, :limit => 50, :null => false     #用户姓名
      t.column :member_id, :integer                             #用户ID
      t.column :gender, :boolean, :default => false             #性别
      t.column :birthday, :datetime                             #出生日期
      t.column :deleted_at, :datetime
      t.column :position, :integer
      t.column :area_country_id, :integer
      t.column :tel, :string, :limit => 15                      #手机
      t.column :address, :string, :limit => 100                 #住址
      t.column :description, :string,:limit => 500              #个人说明
    end
  end
end
