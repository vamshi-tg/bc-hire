class InterviewMailer < ApplicationMailer  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.interview_mailer.interview_schedule.subject
  #
  def interview_schedule(interview)
    @interview = interview
    mail to: @interview.interviewer.email, subject: "Interview Schedule"
  end

  def interview_schedule_update(interview, previous_changes, triggerer)
    @interview = interview
    @previous_changes = previous_changes
    @triggerer = triggerer
    mail to: @interview.interviewer.email, subject: "Interview Schedule Updated"
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
    def remove_activity_owner(employees, feedback)
      employees.delete(feedback.interviewer.email)
      return employees
    end

    def get_recipients_for_interview_activity(interview, feedback)
      application = Application.find(interview.application_id)
      employees = Application.get_employees_associated_with_application(application)
      recipients = Application.remove_activity_triggerer(employees, feedback.interviewer.email)
    end
end
