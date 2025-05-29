FactoryBot.define do
  factory :bank_account do
    association :user
    # Gera agencies válidas de 4 dígitos (1000, 1001, ...)
    sequence(:agency) { |n| "%04d" % (1000 + n) }
    balance { 1000.00 }
    # Gera account_number único de 8 caracteres hexadecimais
    sequence(:account_number) { |_| SecureRandom.hex(4).upcase }
  end
end
