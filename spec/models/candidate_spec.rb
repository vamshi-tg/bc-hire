require "rails_helper"

RSpec.describe Candidate, type: :model do
  before(:all) do
    @user1 = create(:candidate)
  end

  it "is valid with valid attributes" do
    expect(@user1).to be_valid
  end
end