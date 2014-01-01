class AddStuffToMAkerStorefronts < ActiveRecord::Migration
  def change
  	add_column :storefronts, :ships, :boolean
  	add_column :storefronts, :pickup, :boolean
  end
end
