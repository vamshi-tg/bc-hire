require 'test_helper'

class CandidateTest < ActiveSupport::TestCase
  def setup
    @candidate = candidates(:jon_snow)
  end

  test "should be valid" do
    assert @candidate.valid?
  end

  test "name should be present" do
    @candidate.name = "  " 
    assert_not @candidate.valid?
  end

  test "email should be present" do
    @candidate.email = " "
    assert_not @candidate.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @candidate.email = valid_address
      assert @candidate.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @candidate.email = invalid_address
      assert_not @candidate.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @candidate.dup
    duplicate_user.email = @candidate.email.upcase
    @candidate.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved in lower case" do
    mixed_case_email = "JonSNOW@ExAMPle.CoM"
    @candidate.email = mixed_case_email
    @candidate.save
    assert_equal mixed_case_email.downcase, @candidate.reload.email
  end
end
