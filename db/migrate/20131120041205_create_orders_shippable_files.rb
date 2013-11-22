class CreateOrdersShippableFiles < ActiveRecord::Migration
   def change
    create_table :orders_shippable_files, id: false do |t|
      t.references :order, index: true
      t.references :file_object, index: true
    end

    add_index :orders_shippable_files, [:order_id, :file_object_id], unique: true
  end
end
