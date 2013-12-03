class AddDataToStorefront < ActiveRecord::Migration
  def change
  	add_column :storefronts, :vendor_name, :string
  	add_column :storefronts, :admin_id, :integer
  end
end
