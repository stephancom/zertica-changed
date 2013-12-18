class AddCityAndProvince < ActiveRecord::Migration
  def change
  	add_column :orders, :city, :string
  	add_column :orders, :province, :string
  end
end
