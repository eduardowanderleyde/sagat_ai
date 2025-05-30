FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    name { Faker::Name.name }
    sequence(:cpf) { |n| generate_valid_cpf(n) }

    trait :with_bank_account do
      after(:create) do |user|
        create(:bank_account, user: user)
      end
    end
  end
end

# Generates a valid and unique CPF for each n
# Algorithm: uses n to generate the digits, calculates the check digits
# Not for production, only for tests!
def generate_valid_cpf(n)
  base = (n % 1_000_000_000).to_s.rjust(9, '0')
  nums = base.chars.map(&:to_i)
  # First check digit
  sum1 = nums.each_with_index.sum { |num, i| num * (10 - i) }
  d1 = sum1 * 10 % 11
  d1 = 0 if d1 == 10
  # Second check digit
  sum2 = (nums + [ d1 ]).each_with_index.sum { |num, i| num * (11 - i) }
  d2 = sum2 * 10 % 11
  d2 = 0 if d2 == 10
  (base + d1.to_s + d2.to_s)
end
