FactoryBot.define do
    factory :candidate do
      name { Faker::Name.name }
      email { Faker::Internet.email }
    end
end