class AddOrdersQq < ActiveRecord::Migration
  def up
    self.add_column :orders, :qq,  :string         #订单的qq字段
  end

  def down
    self.remove_column :orders, :qq
  end
end
