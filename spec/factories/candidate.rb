FactoryBot.define do
    factory :candidate do
      name { Faker::Name.name }
      email { Faker::Internet.safe_email(name.split.join('.')) }
    end

    factory :candidate_with_applications, parent: :candidate do
      transient do
        applications_count { 1 }
      end

      after(:create) do |candidate, evaluator|
        create_list(:application, evaluator.applications_count, candidate: candidate)
      end

      after(:stub) do |candidate, evaluator|
        build_stubbed_list(:application, evaluator.applications_count, candidate: candidate)
      end  
    end
end