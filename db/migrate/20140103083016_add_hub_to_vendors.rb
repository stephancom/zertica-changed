class AddHubToVendors < ActiveRecord::Migration
  def change
  	add_column :storefronts, :hub, :boolean
  end
end
