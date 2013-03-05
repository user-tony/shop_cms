class CreateOrderAddresses < ActiveRecord::Migration
  def change
    create_table :order_addresses, :options => "ENGINE InnoDB CHARSET utf8" do |t|
      t.column :member_id,        :integer
      t.column :area_country_id,  :integer
      t.column :address,          :string,     :limit => 255
      
      t.column :deleted_at, :datetime
      t.column :position, :integer
      
      t.timestamps
    end
  end
end
