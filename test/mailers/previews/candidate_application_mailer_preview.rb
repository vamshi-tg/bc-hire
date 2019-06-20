# Preview all emails at http://localhost:3000/rails/mailers/candidate_application_mailer
class CandidateApplicationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/candidate_application_mailer/application_status
  def application_status
    application = Application.first
    previous_change = ["open", "rejected"]
    triggerer = Employee.first
    CandidateApplicationMailer.application_status(application, previous_change, triggerer)
  end

end
