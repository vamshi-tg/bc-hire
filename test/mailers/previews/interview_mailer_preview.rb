# Preview all emails at http://localhost:3000/rails/mailers/interview_mailer
class InterviewMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/interview_mailer/interview_schedule
  def interview_schedule
    interview = Interview.first
    InterviewMailer.interview_schedule(interview)
  end

end
