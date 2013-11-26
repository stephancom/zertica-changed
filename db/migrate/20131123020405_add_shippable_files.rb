class AddShippableFiles < ActiveRecord::Migration
  def change

  create_table :orders_files, id: false, force: true do |t|
    t.integer :order_id
    t.integer :file_object_id
  end

  end
end
