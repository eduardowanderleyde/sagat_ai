require 'rails_helper'

RSpec.describe ScheduledTransaction, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:account1) { BankAccount.create!(user: user1, account_number: "333333", balance: 1000.0, agency: "0001") }
  let(:account2) { BankAccount.create!(user: user2, account_number: "444444", balance: 500.0, agency: "0001") }

  it "is valid with valid attributes" do
    sched = ScheduledTransaction.new(source_account: account1, destination_account: account2, amount: 100.0, scheduled_for: 1.day.from_now, status: "pending")
    expect(sched).to be_valid
  end

  it "is invalid without scheduled_for" do
    sched = ScheduledTransaction.new(source_account: account1, destination_account: account2, amount: 100.0, status: "pending")
    expect(sched).not_to be_valid
  end

  it "is invalid if amount is negative" do
    sched = ScheduledTransaction.new(source_account: account1, destination_account: account2, amount: -50.0, scheduled_for: 1.day.from_now, status: "pending")
    expect(sched).not_to be_valid
  end

  it "is invalid if source and destination are the same" do
    sched = ScheduledTransaction.new(source_account: account1, destination_account: account1, amount: 100.0, scheduled_for: 1.day.from_now, status: "pending")
    expect(sched).not_to be_valid
  end
end 