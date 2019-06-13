require 'test_helper'

class InterviewMailerTest < ActionMailer::TestCase
  test "interview_schedule" do
    mail = InterviewMailer.interview_schedule
    assert_equal "Interview schedule", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
