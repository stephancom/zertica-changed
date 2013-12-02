class AddSubtotalToOrderAndBid < ActiveRecord::Migration
  def change
  	remove_column :orders, :subtotal
  	add_column :orders, :subtotal, :decimal, :precision => 8, :scale => 2
  	add_column :bids, :subtotal, :decimal, :precision => 8, :scale => 2

  end
end
