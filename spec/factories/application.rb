FactoryBot.define do
    factory :application do
      #Belongs to a candidate
      candidate

      #Belongs to a Employee who is the owner
      # owner

      transient do
        status { "open" }
        resume { nil }
      end

      role        { Faker::Job.title }
      experience  { rand 1..20 }
    end
end