class AddDebitUriAndCreditUriToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :debit_uri, :string
    add_column :orders, :credit_uri, :string
  end
end
