class InterviewMailer < ApplicationMailer
  helper ApplicationHelper
  include InterviewsHelper
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.interview_mailer.interview_schedule.subject
  #
  def interview_schedule(interview)
    @interview = interview
    mail to: @interview.interviewer.email, subject: "Interview Schedule"
  end

  def interview_activity(feedback)
    @feedback = feedback
    interview = Interview.find(feedback.interview_id)
    recipients = get_recipients_for_interview_activity(interview, feedback)
    if recipients.any?
      mail to: recipients, subject: "Activity on Interview"
    else 
      return
    end
  end

  private
    def remove_activity_owner(interviewers, feedback)
      interviewers.delete(feedback.interviewer.email)
      return interviewers
    end

    def get_recipients_for_interview_activity(interview, feedback)
      interviewers = get_employees_associated_with_application(interview.application_id)
      recipients = remove_activity_owner(interviewers, feedback)
    end
end
