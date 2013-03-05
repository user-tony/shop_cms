#encoding: UTF-8
class DeviseCreateMembers < ActiveRecord::Migration
  def change
    create_table(:members, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8') do |t|
      ## Database authenticatable
      t.column :login, :string, :limit => 20, :null => false       #登录帐号
      t.column :nick_name, :string, :limit => 20, :null => false
      t.column :member_type, :integer, :default => 0  
      t.column :deleted_at, :datetime
      t.column :position, :integer
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.timestamps
    end

    add_index :members, :email,                :unique => true
    add_index :members, :reset_password_token, :unique => true
    #添加预定义账号
    say "初始化会员用户"
    %w(manager superadmin super_admin administrator).each do |member|
      Member.create(:login => member, :password => '7a8b7c1e5d2f6g', :nick_name => member, :email => "#{member}@wowoj.com") and Member.where(:login => member).first.destroy
    end

  end
end
