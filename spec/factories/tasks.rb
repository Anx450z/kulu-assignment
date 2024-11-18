FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    due_date { Faker::Time.forward(days: 30) }
    completed_at { nil }
    association :project

    trait :completed do
      completed_at { Time.current }
    end

    trait :overdue do
      due_date { 2.days.ago }
      completed_at { nil }
    end

    after(:create) do |task|
      task.users << create(:user) unless task.users.any?
    end
  end
end
