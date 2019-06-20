require "rails_helper"

RSpec.describe Candidate, type: :model do
  before(:all) do
    @user1 = create(:candidate)
  end

  it "is valid with valid attributes" do
    expect(@user1).to be_valid
  end

  it "is not valid without a name" do
    @user1.name = " "
    expect(@user1).to_not be_valid
  end

  it "is not valid without a email" do
    @user1.email = nil
    expect(@user1).to_not be_valid
  end
end