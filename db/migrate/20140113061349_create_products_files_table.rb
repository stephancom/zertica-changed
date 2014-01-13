class CreateProductsFilesTable < ActiveRecord::Migration
  def change
    create_table :products_file_objects, id: false do |t|
      t.references :product, index: true
      t.references :file_object, index: true
    end
    add_index :products_file_objects, [:product_id, :file_object_id]

  end
end
