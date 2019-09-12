FactoryBot.define do
  factory :topic_feedback do
    interview

    name { "MyString" }
    positives { "MyString" }
    negatives { "MyString" }
    candidate_level { "MyString" }
  end
end
