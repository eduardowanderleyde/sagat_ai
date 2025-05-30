require "rails_helper"

RSpec.describe ProcessScheduledTransactionWorker, type: :worker do
  let(:user)             { create(:user, :with_bank_account) }
  let(:destination_user) { create(:user, :with_bank_account) }
  let(:scheduled_transaction) do
    ScheduledTransaction.create!(
      source_account:      user.bank_account,
      destination_account: destination_user.bank_account,
      amount:              100.0,
      scheduled_for:       2.seconds.from_now,
      status:              'pending'
    )
  end

  it 'processes the scheduled transfer and updates the balances' do
    # garante saldo suficiente antes de chamar o worker
    user.bank_account.update!(balance: 500.0)

    expect {
      described_class.new.perform(scheduled_transaction.id)
    }
      .to change { user.bank_account.reload.balance }.by(-100.0)
      .and change { destination_user.bank_account.reload.balance }.by(100.0)

    expect(scheduled_transaction.reload.status).to eq('completed')
  end
end
