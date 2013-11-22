class AddDataToBids < ActiveRecord::Migration
  def change
  	add_column :bids, :admin_id, :integer
  	add_column :bids, :order_id, :integer
  	add_column :bids, :price, :decimal
  	add_column :bids, :selected, :boolean, default: false
  end
end
