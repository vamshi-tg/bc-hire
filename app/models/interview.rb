class Interview < ApplicationRecord
  belongs_to :application
  belongs_to :interviewer, class_name: "Employee"
end
