class AddOrderAddressConsignee < ActiveRecord::Migration
  def up
    add_column  :order_addresses, :name , :string , :null => true                  #收货人姓名
    add_column  :order_addresses, :phone , :string, :null => true                  #收货人电话
    add_column  :order_addresses, :area_province_id , :integer                     #省ID
    add_column  :order_addresses, :area_city_id , :integer                         #市ID
    add_column  :order_addresses, :zip_code , :string                              #邮编
  end

  def down
    remove_column  :order_addresses, :name                                  #收货人姓名
    remove_column  :order_addresses, :phone                                 #收货人电话
    remove_column  :order_addresses, :area_province_id                       #省ID
    remove_column  :order_addresses, :area_city_id                           #市ID
    remove_column  :order_addresses, :zip_code                              #邮编
  end
end
