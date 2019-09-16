FactoryBot.define do
    factory :employee, aliases: [:owner, :interviewer] do
        transient do
            manager { false }
        end

        omniauth_google = Faker::Omniauth.google        
        uid         { omniauth_google[:uid] }
        email       { omniauth_google[:info][:email] }
        name        { omniauth_google[:info][:name] }
        picture     { omniauth_google[:info][:image] }
        provider    { omniauth_google[:provider] }

        after(:create) do |employee, evaluator|
            if evaluator.manager
                employee.role = "manager"
                employee.save!
            end
        end
    end
  end