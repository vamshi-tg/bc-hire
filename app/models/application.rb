class Application < ApplicationRecord
  include ActiveModel::Dirty

  has_many :interviews
  belongs_to :candidate
  belongs_to :owner, class_name: "Employee"

  validates :role, presence: true
  validates :experience, presence: true, numericality: { less_than_or_equal_to: 50,  only_integer: true }
  validate  :resume_size

  mount_uploader :resume, ResumeUploader

  default_scope -> { order(created_at: :desc)}

  STATUS = {
    accepted: "Accepted",
    rejected: "Rejected",
    on_hold: "On Hold",
    open: "Open"
  }

  def resume_size
    if resume.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  def self.get_employees_associated_with_application(application)
    interviewers = get_interviewers_associated_with_application(application.id)
    owner = application.owner.email
    employees = interviewers.push(owner).uniq
  end

  def self.get_interviewers_associated_with_application(application_id)
    application = Application.includes({interviews: :interviewer}).find(application_id)
    associated_interviewers = application.interviews.map do |interview|
      interview.interviewer.email
    end
    return associated_interviewers
  end

  def self.remove_activity_triggerer(employees, triggerer_email)
      employees.delete(triggerer_email)
      return employees
  end

  def self.create_application(params, current_user)
    candidate = Candidate.find_by(email: params[:email])
    if candidate.nil?
      is_created = self.create_candidate_and_application(params, current_user)
      message = "Candidate and application created"
    else
      is_created = self.add_application_to_existing_candidate(params, candidate, current_user)
      message = "New application added to existing candidate with #{candidate.email} email."
    end
    return {is_created: is_created, message: message}
  end

  def self.create_candidate_and_application(candidate_application_params, current_user)
    candidate = Candidate.new(candidate_application_params)
    # Assign owner to the newly built application
    candidate.applications.first.assign_owner_id(current_user.id)
    candidate.save
  end

  def self.add_application_to_existing_candidate(candidate_application_params, candidate, current_user)
    application_params = candidate_application_params[:applications_attributes]["0"]
    application = candidate.applications.build(application_params)
    application.assign_owner_id(current_user.id)
    application.save
end

  def send_application_status_mail(triggerer)
    application = self
    previous_change = application.status_previous_change
    if previous_change
      CandidateApplicationMailer.application_status(application, previous_change, triggerer).deliver_now
    end
  end

  def assign_owner_id(owner_id)
    self.owner_id = owner_id
  end
end
