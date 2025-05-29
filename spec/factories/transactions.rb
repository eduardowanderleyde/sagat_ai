FactoryBot.define do
  factory :transaction do
    amount { 100.00 }
    transaction_type { 'transfer' }
    status { 'pending' }
    association :source_account, factory: :bank_account
    association :destination_account, factory: :bank_account
  end
end
