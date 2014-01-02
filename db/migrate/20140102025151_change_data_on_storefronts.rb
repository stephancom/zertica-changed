class ChangeDataOnStorefronts < ActiveRecord::Migration
  def change
  	add_column :storefronts, :cad, :boolean
  	add_column :storefronts, :print, :boolean
  	remove_column :storefronts, :printing_capabilities
  	remove_column :storefronts, :cad_capabilities
  end
end
