class CreateLogistics < ActiveRecord::Migration
  def change
    create_table :logistics, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      # 订单ID
      t.column :order_id, :integer, :null => false
      # 物流公司代号
      t.column :logistic_com, :string, :null => false
      # 物流号
      t.column :logistic_num, :string, :null => false

      t.timestamps
    end
  end
end
