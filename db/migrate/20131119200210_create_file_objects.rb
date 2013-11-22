class CreateFileObjects < ActiveRecord::Migration
  def change
    create_table :file_objects do |t|

      t.timestamps
    end
  end
end
