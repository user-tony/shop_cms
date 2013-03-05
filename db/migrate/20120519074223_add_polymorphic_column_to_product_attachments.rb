class AddPolymorphicColumnToProductAttachments < ActiveRecord::Migration
  def up
    self.add_column :product_attachments, :item_type,  :string , :default => 0       #父表类型
    self.rename_column :product_attachments, :product_id, :item_id        #父表id
  end

  def down
    self.remove_column :product_attachments, :item_type
    self.rename_column :product_attachments, :item_id, :product_id        #父表id
  end
end
