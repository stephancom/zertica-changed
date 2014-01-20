class AddEstimateHoursToBids < ActiveRecord::Migration
  def change
  	add_column :bids, :estimated_hours, :integer
  end
end
