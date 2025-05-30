FactoryBot.define do
  factory :audit_log do
    user { nil }
    action { "MyString" }
    auditable { nil }
    data { "" }
  end
end
