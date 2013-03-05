class CreateAreaProvinces < ActiveRecord::Migration
  def change
    create_table :area_provinces, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :name, :string
      t.column :deleted_at, :datetime
      t.column :position, :integer
    end
  end
end
