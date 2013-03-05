class AddOrdersScode < ActiveRecord::Migration
  def up
    add_column  :orders,     :scode,                 :string                 #订单号
    add_column  :orders,     :phone,                :string                 #电话
    add_column  :orders,     :recipient_name,       :string                 #收货人姓名
    add_column  :orders,     :address,              :string                 #收货地址
  end

  def down
    remove_columns  :orders,     :scode
    remove_columns  :orders,     :phone
    remove_columns  :orders,     :recipient_name
    remove_columns  :orders,     :address                
  end
end
