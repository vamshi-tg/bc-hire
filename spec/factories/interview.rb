FactoryBot.define do
    factory :interview do 
        interviewer
        application
        
        interview_rounds = ["First Round", "Second Round", "HR Round"]
        
        round_name { interview_rounds[rand 0..(interview_rounds.size - 1)]}
        scheduled_on { Faker::Date.between(15.days.ago, Date.today) }
        start_time { Time.zone.now }
        end_time { 1.hour.after }
    end
end