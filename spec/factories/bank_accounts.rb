FactoryBot.define do
  factory :bank_account do
    association :user
    # Generates valid 4-digit agencies (1000, 1001, ...)
    sequence(:agency) { |n| "%04d" % (1000 + n) }
    balance { 1000.00 }
    # Generates a unique 8-character hexadecimal account_number
    sequence(:account_number) { |_| SecureRandom.hex(4).upcase }
  end
end
