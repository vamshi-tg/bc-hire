require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  def setup
    @application = applications(:jon_snow_app_1)
  end

  test "should be valid" do
    assert @application.valid?
  end

  test "should not allow empty value in role" do
    @application.role = " "
    assert_not @application.valid?
  end

  test "should not allow empty value in experience" do
    @application.experience = " "
    assert_not @application.valid?
  end
end
