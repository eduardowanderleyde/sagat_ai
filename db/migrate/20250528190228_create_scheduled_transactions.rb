class CreateScheduledTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :scheduled_transactions do |t|
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.references :source_account, null: false, foreign_key: { to_table: :bank_accounts }
      t.references :destination_account, null: false, foreign_key: { to_table: :bank_accounts }
      t.datetime :scheduled_for, null: false
      t.string :description
      t.string :status, default: 'pending', null: false

      t.timestamps
    end

    add_index :scheduled_transactions, :scheduled_for
    add_index :scheduled_transactions, :status
  end
end
