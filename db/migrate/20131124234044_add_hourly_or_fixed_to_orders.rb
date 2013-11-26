class AddHourlyOrFixedToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :pay_schedule, :string
  end
end
