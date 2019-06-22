FactoryBot.define do
    factory :candidate do
      name { Faker::Name.name }
      email { Faker::Internet.email }
    end
    
    after :build do |candidate|
      create :application, candidate: candidate
    end
end