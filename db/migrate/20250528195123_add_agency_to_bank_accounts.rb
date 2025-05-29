class AddAgencyToBankAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :bank_accounts, :agency, :string, null: false, default: '0001'
    add_index :bank_accounts, :agency
  end
end
