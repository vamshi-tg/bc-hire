class Employee < ApplicationRecord
    has_many :interviews, class_name: "Interview", foreign_key: "interviewer_id"
end
