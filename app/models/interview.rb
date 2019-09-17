class Interview < ApplicationRecord
	include GoogleService::Calendar
  include ActiveModel::Dirty

  validates :round_name, :start_time, :end_time, :scheduled_on, presence: true

  validate :validate_time_slot
  validates :application, uniqueness: {scope: [:start_time, :end_time], message: "already has an interview in this time slot"}

  validate :validate_interview_overlap, if: :new_record_or_interview_time_changed?

  has_many :feedback, :dependent => :destroy
  has_many :topic_feedbacks, :dependent => :destroy
  
  belongs_to :application
  belongs_to :interviewer, class_name: "Employee"

  after_commit :send_interview_schedule_mail, on: :create

  ROUNDS = [:round_1, :round_2, :round_3, :round_4]
  
  ROUND_TOPICS = {
    round_1: {
      ds_and_alogorithms: "Data Strucutres & Algorithms",
      oops_and_programming: "OOPS Concepts/Programming",
      db: "Database",
      frameworks: "Frameworks (Django/Rails)",
      round_1_overall_feedback: "Interviewer Round 1 overall feedback"
    },
    round_2: {
      web_fundamentals: "Web Fundamentals",
      css: "CSS",
      js: "Javascript",
      round_2_overall_feedback: "Interviewer Round 1 overall feedback"
    },
    round_3: {
      behavioral: "Behavioural"
    }
  }

  def send_interview_schedule_mail
    InterviewMailer.interview_schedule(self).deliver_now
  end

  def send_interview_schedule_update_mail(changes, triggerer)
    InterviewMailer.interview_schedule_update(self, changes, triggerer).deliver_now
  end

  private
    DATE_FORMAT = "%d-%m-%Y"
    TIME_FORMAT = "%I:%M %p"

    def validate_time_slot
      if(start_time != nil && end_time != nil)
        raise Exceptions::InvalidTimeSlotException if end_time <= start_time
      end
    end

    def validate_interview_overlap
     conditions = 'scheduled_on = :scheduled_on'\
                  ' AND start_time <= :end_time AND :start_time <= end_time'

      interviewer_interviews = self.interviewer.interviews.where(conditions, scheduled_on: "#{self.scheduled_on}", start_time: "#{self.start_time}", end_time: "#{self.end_time}")
      if interviewer_interviews.any?
        raise Exceptions::InterviewTimeOverlapException
      end
    end

    def new_record_or_interview_time_changed?
      self.new_record? || self.start_time_changed? || self.end_time_changed?
    end
end