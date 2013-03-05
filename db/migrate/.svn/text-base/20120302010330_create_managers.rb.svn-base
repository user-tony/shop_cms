#encoding: UTF-8
class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :login, :string, :limit => 20, :null => false       #登录帐号
      t.column :password, :string, :null => false      #登录密码
      t.column :manager_type, :integer, :default => 0                  #管理员类别
      t.column :email, :string, :limit => 50                       #用户邮件
      t.column :deleted_at, :datetime
      t.column :position, :integer
      t.timestamps
    end
    say "---------------------初始化数据开始......"
    Manager.create(:login => 'super_admin', :password => Digest::MD5.hexdigest('netcenter'), :email => 'mangocms1@wowoj.com')
    say "添回超级管理员..."
    Manager.create(:login => 'admin', :password => Digest::MD5.hexdigest('admin'), :email => 'mangocms2@wowoj.com')
    say "添加管理员..."
  end
end
