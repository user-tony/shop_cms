class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders, :options => "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.column :amount,         :float,   :default => 0 #金额
      t.column :payment,        :float,   :default => 0 #已支付金额
      t.column :order_status,   :integer, :default => 0 #订单状态
      t.column :payment_status, :integer, :default => 0 #支付状态
      t.column :remark,         :string                 #备注
      t.column :deleted_at,     :datetime               #软删除字段(非空为软删除数据)
      
      t.references :member
      t.references :order_address   #收货人地址

      t.timestamps
    end
    add_index :orders, :member_id
  end
end
