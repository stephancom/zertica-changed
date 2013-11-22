class AddIdsToORders < ActiveRecord::Migration
  def change
  	add_column :orders, :user_id, :integer
  	add_column :orders, :admin_id, :integer
  end
end
