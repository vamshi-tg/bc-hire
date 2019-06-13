class InterviewMailer < ApplicationMailer
  helper ApplicationHelper
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.interview_mailer.interview_schedule.subject
  #
  def interview_schedule(interview)
    @interview = interview
    mail to: @interview.interviewer.email, subject: "Interview Schedule"
  end
end
