FactoryBot.define do
    factory :interview do 
        interviewer
        application
        
        interview_rounds = ["round_1", "round_2", "round_2", "round_4"]
        
        round_name { interview_rounds[rand 0..(interview_rounds.size - 1)]}
        scheduled_on { Faker::Date.between(15.days.ago, Date.today) }
        start_time { Time.zone.now }
        end_time { 1.hour.after }
    end
end