require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  def setup
    @feedback = feedbacks(:feedback_one)
  end

  test "should be valid" do
    assert @feedback.valid?
  end
end
