class CreateOrdersFileObjects < ActiveRecord::Migration

  def change
    create_table :orders_file_objects, id: false do |t|
      t.references :order, index: true
      t.references :file_object, index: true
    end

    add_index :orders_file_objects, [:order_id, :file_object_id]
    # TODO: OOPS!  forgot unique: true
  end
end
