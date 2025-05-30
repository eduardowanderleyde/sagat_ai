require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
  end

  it "is invalid with an invalid CPF" do
    user = build(:user, cpf: "12345678901")
    expect(user).not_to be_valid
    expect(user.errors[:cpf]).to include("invalid")
  end

  it "strips non-digit characters from CPF" do
    user = build(:user, cpf: "529.982.247-25")
    user.valid?
    expect(user.cpf).to eq("52998224725")
  end

  it "is invalid with a duplicate email" do
    create(:user, email: "test@example.com")
    user2 = build(:user, email: "test@example.com")
    expect(user2).not_to be_valid
  end
end
