class Application < ApplicationRecord
  has_many :interviews
  belongs_to :candidate

  validates :role, presence: true
  validates :experience, presence: true
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
  
end
