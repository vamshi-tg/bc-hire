FactoryBot.define do
    factory :application do
      candidate
      owner
      
      transient do
        status { "open" }
        resume { nil }
      end

      role        { Faker::Job.title }
      experience  { rand 1..20 }
    end

    factory :applications_with_interviews, parent: :application do
      transient do
        interviews_count { 1 }
      end

      after(:create) do |application, evaluator|
        create_list(:interview, evaluator.interviews_count, application: application)
      end

      after(:stub) do |application, evaluator|
        build_stubbed_list(:interview, evaluator.interviews_count, application: application)
      end
    end
end