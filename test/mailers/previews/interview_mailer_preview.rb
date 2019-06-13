# Preview all emails at http://localhost:3000/rails/mailers/interview_mailer
class InterviewMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/interview_mailer/interview_schedule
  def interview_schedule
    interview = Interview.first
    InterviewMailer.interview_schedule(interview)
  end

  # Preview this email at http://localhost:3000/rails/mailers/interview_mailer/interview_activity
  def interview_activity
    feedback = Feedback.find(18)
    InterviewMailer.interview_activity(feedback)
  end

end
