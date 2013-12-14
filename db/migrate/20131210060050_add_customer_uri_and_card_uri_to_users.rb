class AddCustomerUriAndCardUriToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customer_uri, :string
    add_column :users, :card_uri, :string
  end
end
