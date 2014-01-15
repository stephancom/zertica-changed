class AddAnotherProductFilesTable < ActiveRecord::Migration
  def change
  	  create_table "products_files", id: false, force: true do |t|
    	t.integer "product_id"
    	t.integer "file_object_id"
  	  end
  end
end
