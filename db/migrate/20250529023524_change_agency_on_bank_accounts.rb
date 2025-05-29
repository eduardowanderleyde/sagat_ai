class ChangeAgencyOnBankAccounts < ActiveRecord::Migration[8.0]
  def change
    change_column_default :bank_accounts, :agency, from: '0001', to: nil

    change_column_null    :bank_accounts, :agency, false
  end
end
