FactoryBot.define do
  factory :permission do
    employee
    can_interview_round_1 { false }
  end
end
