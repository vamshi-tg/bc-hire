class Feedback < ApplicationRecord
  belongs_to :interview
  belongs_to :interviewer, class_name: "Employee"

  validates :content, presence: true

  def send_interview_activity_mail
    InterviewMailer.interview_activity(self).deliver_now
  end
end
