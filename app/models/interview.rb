class Interview < ApplicationRecord
  validates :round_name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :scheduled_on, presence: true
  

  before_validation :parse_time
  validate :time_slot

  has_many :feedback
  belongs_to :application
  belongs_to :interviewer, class_name: "Employee"

  private
    def parse_time
      unless self.start_time.nil?
        self.start_time = Time.zone.parse("#{scheduled_on} #{start_time}")
      end

      unless self.start_time.nil?
        self.end_time = Time.zone.parse("#{scheduled_on} #{end_time}")
      end
    end

    def time_slot
      if(start_time != nil && end_time != nil)
        raise Exceptions::InvalidTimeSlotException if end_time <= start_time
      end
    end
end