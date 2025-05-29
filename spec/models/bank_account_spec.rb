require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  let(:user) { create(:user) }

  it "is valid with valid attributes" do
    account = BankAccount.new(user: user, balance: 100.0, agency: "0001")
    expect(account).to be_valid
  end

  it "is invalid without an agency" do
    account = BankAccount.new(user: user, balance: 100.0)
    account.agency = nil
    expect(account).not_to be_valid
  end

  it "does not allow negative balance" do
    account = BankAccount.new(user: user, balance: -10.0, agency: "0001")
    expect(account).not_to be_valid
  end

  it "updates balance atomically" do
    account = BankAccount.create!(user: user, balance: 100.0, agency: "0001")
    expect { account.update_balance(50) }.to change { account.reload.balance }.by(50)
  end
end
