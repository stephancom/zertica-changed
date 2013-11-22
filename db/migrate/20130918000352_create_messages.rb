class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body, null: false
      t.references :user, index: true, null: false
      t.references :sender, index: true
      t.boolean :bookmark, null: false, default: false

      t.timestamps
    end
  end
end
