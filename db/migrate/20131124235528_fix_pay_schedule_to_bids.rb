class FixPayScheduleToBids < ActiveRecord::Migration
  def change
  	remove_column :orders, :pay_schedule
  	add_column :bids, :pay_schedule, :string
  end
end
