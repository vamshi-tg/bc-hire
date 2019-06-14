class Interview < ApplicationRecord
  validates :round_name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :scheduled_on, presence: true
  
  before_validation :parse_time
  validate :validate_time_slot

  has_many :feedback
  belongs_to :application
  belongs_to :interviewer, class_name: "Employee"

  after_commit :send_interview_schedule_mail, on: :create

  def send_interview_schedule_mail
    InterviewMailer.interview_schedule(self).deliver_now
  end
  
  private
    DATE_FORMAT = "%d-%m-%Y"
    TIME_FORMAT = "%I:%M %p"
    TIMEZONE = "Kolkata"
    DATETIME_ZONE_FORMAT = "#{DATE_FORMAT} #{TIME_FORMAT} %Z"

    def parse_time
      # By default time is storing the wrong year. So, building the time with interview date.
      # Also, storing the date and time in IST timezone. While saving it will automatically before do
      # stored in UTC format.
      # Time.strptime("19-06-2019 7:14 PM Kolkata", "%d-%m-%Y %I:%M %p %Z")
      unless self.start_time.nil?
        datetime_zone_value = get_date_and_time(self.scheduled_on, self.start_time)
        self.start_time = Time.strptime(datetime_zone_value, DATETIME_ZONE_FORMAT)
      end

      unless self.start_time.nil?
        datetime_zone_value = get_date_and_time(self.scheduled_on, self.end_time)
        self.end_time = Time.strptime(datetime_zone_value, DATETIME_ZONE_FORMAT)
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
end