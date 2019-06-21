require "rails_helper"

RSpec.describe Candidate, type: :model do
  before { @candidate1 = FactoryBot.create :candidate}

  it "is valid with valid attributes" do
    expect(@candidate1).to be_valid
  end

  it "is not valid without a name" do
    @candidate1.name = " "
    expect(@candidate1).to_not be_valid
  end

  it "is not valid without a email" do
    @candidate1.email = nil
    expect(@candidate1).to_not be_valid
  end

  context "email" do
    it "rejects invalid address" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        @candidate1.email = invalid_address
        expect(@candidate1).to_not be_valid
      end
    end

    it "accepts valid address" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @candidate1.email = valid_address
        expect(@candidate1).to be_valid
      end
    end

    it "is unique" do
      @candidate1_dup = @candidate1.dup
      @candidate1_dup.email = @candidate1.email.upcase
      expect(@candidate1_dup).to_not be_valid
    end

    it "gets stored in downcase" do 
      mixed_case_email = "KiSHORE@gmail.COM"
      @candidate2 = create(:candidate, email: mixed_case_email)
      expect(@candidate2.email).to eq(mixed_case_email.downcase)
    end
  end
end