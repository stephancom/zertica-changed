class AddDataToStorefronts < ActiveRecord::Migration
  def change
  	add_column :storefronts, :printing_capabilities, :string
  	add_column :storefronts, :cad_capabilities, :string
  	add_column :storefronts, :description, :text
  end
end
