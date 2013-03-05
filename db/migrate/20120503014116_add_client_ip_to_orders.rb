class AddClientIpToOrders < ActiveRecord::Migration
  def up
    add_column  :orders,     :client_ip,                 :string                 #客户ip
  end

  def down
    remove_columns  :orders,     :client_ip
  end
end
