class Feedback < ApplicationRecord
  belongs_to :interview
  belongs_to :interviewer, class_name: "Employee"
end
