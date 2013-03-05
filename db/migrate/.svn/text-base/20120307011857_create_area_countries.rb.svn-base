class CreateAreaCountries < ActiveRecord::Migration
  def change
    create_table :area_countries, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :area_city_id, :integer
      t.column :name, :string
      t.column :deleted_at, :datetime
      t.column :position, :integer
    end
  end
end
