class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string      :order_type
      t.references  :project, index: true, null: false
      t.string      :state, null: false, default: 'submitted'
      t.string      :title, null: false
      t.text        :description
      t.decimal     :price, :precision => 8, :scale => 2

      # only used in print order subclass
      t.string      :carrier
      t.string      :tracking_number

      # confirmation of payment
      # could be confirmation number from card run
      # or admin notes such as check number or "cash"
      t.string      :confirmation

      t.timestamps
    end
  end
end
