class CreateAreaCities < ActiveRecord::Migration
  def change
    create_table :area_cities, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :area_province_id, :integer
      t.column :name, :string
      t.column :deleted_at, :datetime
      t.column :position, :integer
    end
  end
end
