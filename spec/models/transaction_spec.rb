require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:account1) { BankAccount.create!(user: user1, account_number: "111111", balance: 1000.0, agency: "0001") }
  let(:account2) { BankAccount.create!(user: user2, account_number: "222222", balance: 500.0, agency: "0001") }

  it "is valid with valid attributes" do
    tx = Transaction.new(source_account: account1, destination_account: account2, amount: 100.0, transaction_type: "transfer", status: "pending")
    expect(tx).to be_valid
  end

  it "is invalid if source and destination are the same" do
    tx = Transaction.new(source_account: account1, destination_account: account1, amount: 100.0, transaction_type: "transfer", status: "pending")
    expect(tx).not_to be_valid
  end

  it "is invalid if source has insufficient balance" do
    tx = Transaction.new(source_account: account1, destination_account: account2, amount: 10_000.0, transaction_type: "transfer", status: "pending")
    expect(tx).not_to be_valid
  end

  it "processes a transfer and updates balances" do
    tx = Transaction.create!(source_account: account1, destination_account: account2, amount: 200.0, transaction_type: "transfer", status: "pending")
    expect { tx.process! }.to change { account1.reload.balance }.by(-200.0).and change { account2.reload.balance }.by(200.0)
    expect(tx.reload.status).to eq("completed")
  end
end
