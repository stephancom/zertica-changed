class BankAccountsController < ApplicationController
  def edit
  	@admin = current_admin
  end

  def update
  	current_admin.update_attributes(params[:bank_account])
  	flash[:success] = "bank account info updated!"
  	redirect_to edit_bank_account_path
  end

  private

  def bank_account_params
    params[:bank_account].permit(:name, :bank_account_uri)
  end

end
