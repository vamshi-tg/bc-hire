class CandidateApplicationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.candidate_applicatin_mailer.application_status.subject
  #
  def application_status(application, previous_change, triggerer)
    @application = application
    @previous_change = previous_change
    @triggerer = triggerer
    recipients = get_recipients_for_application_status_activity(application, triggerer)
    if recipients.any?
      mail to: recipients, subject: "Activity on Interview"
    else 
      return
    end
  end

  private
    def get_recipients_for_application_status_activity(application, triggerer)
      employees = Application.get_employees_associated_with_application(application)
      recipients = Application.remove_activity_triggerer(employees, triggerer.email)
    end
end
