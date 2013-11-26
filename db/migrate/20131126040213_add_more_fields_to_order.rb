class AddMoreFieldsToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :deadline, :datetime
  	add_column :orders, :color, :string
  	add_column :orders, :material, :string
  	add_column :orders, :budget, :string
  	add_column :orders, :quantity, :integer
  	add_column :orders, :software_program, :string
  	add_column :orders, :file_format, :string
  end
end
