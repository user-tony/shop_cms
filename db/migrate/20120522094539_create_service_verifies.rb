class CreateServiceVerifies < ActiveRecord::Migration
  def change
    create_table :service_verifies, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :serial_number, :string, :length => 50, :null => false     #序列号
      t.column :password, :string, :length => 500                         #密码
      t.column :status, :integer, :default => 0                           #状态
      t.column :verify_num, :integer, :default => 0                           #验证次数
      t.column :verify_at, :datetime                                      #验证时间
      t.timestamps

      #--------------外健---------------------------
      t.references :service_category                                      #序列号分类
      #--------------------------------------------
    end
  end
end
