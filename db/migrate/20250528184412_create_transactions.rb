class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :transaction_type, null: false
      t.references :source_account, null: false, foreign_key: { to_table: :bank_accounts }
      t.references :destination_account, null: false, foreign_key: { to_table: :bank_accounts }
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end
  end
end
