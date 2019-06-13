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
    def get_interviewers_assocaited_with_application(interview)
      application = Application.includes({interviews: :interviewer}).find(interview.application_id)
      associated_interviewers = application.interviews.map do |interview|
        interview.interviewer.email
      end

      associated_interviewers.uniq
      return associated_interviewers
    end

    def remove_activity_owner(interviewers, feedback)
      interviewers.delete(feedback.interviewer.email)
      return interviewers
    end

    def get_recipients_for_interview_activity(interview, feedback)
      interviewers = get_interviewers_assocaited_with_application(interview)
      interviewers = append_managers(interviewers)
      recipients = remove_activity_owner(interviewers, feedback)
    end

    def append_managers(interviewers)
      managers = Employee.managers_email_ids
      recipients = interviewers.push(*managers)
      return recipients
    end
end
