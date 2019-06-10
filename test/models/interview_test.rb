require 'test_helper'

class InterviewTest < ActiveSupport::TestCase
  def setup
    @interview_one = interviews(:one)
  end

  test "should be valid" do
    assert @interview_one.valid?
  end

  test "round name should be present" do 
    @interview_one.round_name = " "
    assert_not @interview_one.valid?
  end

  test "start time should be present" do 
    @interview_one.start_time = " "
    assert_not @interview_one.valid?
  end

  # TODO: Fix this test case
  test "end time should be present" do 
    @interview_one.end_time = "    "
    assert_not @interview_one.valid?
  end

  test "scheduled_on should be present" do 
    @interview_one.scheduled_on = " "
    assert_not @interview_one.valid?
  end
end
