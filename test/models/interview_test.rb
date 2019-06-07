require 'test_helper'

class InterviewTest < ActiveSupport::TestCase
  def setup
    @interview_one = interviews(:one)
  end

  test "should be valid" do
    assert @interview_one.valid?
  end
end
