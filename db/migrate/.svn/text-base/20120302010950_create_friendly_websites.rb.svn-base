class CreateFriendlyWebsites < ActiveRecord::Migration
  def change
    create_table :friendly_websites, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :name, :string, :limit => 30, :null => false
      t.column :website_url, :string, :limit => 255, :null => false
      t.column :description, :string, :limit => 255
      t.column :deleted_at, :datetime
      t.column :position, :integer
      t.timestamps
    end
  end
end
