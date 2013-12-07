class AddCustomerUriAndBankAccountUriToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :customer_uri, :string
    add_column :admins, :bank_account_uri, :string
  end
end
