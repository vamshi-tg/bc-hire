class Interview < ApplicationRecord
  include ActiveModel::Dirty

  validates :round_name, :start_time, :end_time, :scheduled_on, presence: true

  before_validation :prepend_scheduled_date_to_time

  validate :validate_time_slot
  validates :interviewer, uniqueness: {scope: [:application, :start_time, :end_time], message: "already scheduled for this application at the same time"}
  validates :interviewer, uniqueness: {scope: [:start_time, :end_time], message: "already has an interview in this time slot"}
  validates :application, uniqueness: {scope: [:start_time, :end_time], message: "already has an interview in this time slot"}

  validate :validate_interview_overlap

  has_many :feedback
  belongs_to :application
  belongs_to :interviewer, class_name: "Employee"

  after_commit :send_interview_schedule_mail, on: :create

  def send_interview_schedule_mail
    InterviewMailer.interview_schedule(self).deliver_now
  end

  def send_interview_schedule_update_mail(changes, triggerer)
    InterviewMailer.interview_schedule_update(self, changes, triggerer).deliver_now
  end

  private
    DATE_FORMAT = "%d-%m-%Y"
    TIME_FORMAT = "%I:%M %p"
    TIMEZONE = "Kolkata"
    DATETIME_ZONE_FORMAT = "#{DATE_FORMAT} #{TIME_FORMAT} %Z"

    def prepend_scheduled_date_to_time
      # By default time is storing the wrong year. So, building the time with interview date.
      # Also, storing the date and time in IST timezone. While saving it will automatically before do
      # stored in UTC format.
      # Time.strptime("19-06-2019 7:14 PM Kolkata", "%d-%m-%Y %I:%M %p %Z")
      unless self.scheduled_on.nil?
        self.start_time = prepend_date(self.start_time)
        self.end_time = prepend_date(self.end_time)
      end
    end

    def prepend_date(time)
      unless time.nil?
        datetime_zone_value = get_date_and_time(self.scheduled_on, time)
        time = Time.strptime(datetime_zone_value, DATETIME_ZONE_FORMAT)
      end
    end

    def get_date_and_time(scheduled_on, start_time)
      date = scheduled_on.strftime(DATE_FORMAT)
      time = start_time.strftime(TIME_FORMAT)
      return "#{date} #{time} #{TIMEZONE}"
    end

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
end