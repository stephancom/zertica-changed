class AddDataToFileObjects < ActiveRecord::Migration
  def change

  	add_column :file_objects, :user_id, :integer
  	add_column :file_objects, :admin_id, :integer
  	add_column :file_objects, :order_id, :integer
  	add_column :file_objects, :url, :string, null: false
  	add_column :file_objects, :filename, :string, null: false
  	add_column :file_objects, :size, :integer, null: false
  	add_column :file_objects, :mimetype, :string, null: false

  end
end
