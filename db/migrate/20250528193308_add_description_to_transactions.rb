class AddDescriptionToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :description, :string
  end
end
