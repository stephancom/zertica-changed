class AddCityAndStateToStorefront < ActiveRecord::Migration
  def change
  	add_column :storefronts, :city, :string
  	add_column :storefronts, :state, :string
  end
end
