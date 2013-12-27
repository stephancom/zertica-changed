class ChangeDeadlinToString < ActiveRecord::Migration
  def change
  	 change_column :orders, :deadline, :string

  end
end
