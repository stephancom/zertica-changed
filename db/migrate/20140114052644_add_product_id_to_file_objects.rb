class AddProductIdToFileObjects < ActiveRecord::Migration
  def change
  	add_column :file_objects, :product_id, :integer
  end
end
