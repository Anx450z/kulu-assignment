FactoryBot.define do
  factory :project do
    association :owner, factory: :user
    title { "Sample Project Title" }
    description { "Sample Project Description" }

    trait :with_users do
      after(:create) do |project|
        create_list(:user, 3, projects: [ project ])
      end
    end

    trait :with_invites do
      after(:create) do |project|
        create_list(:invite, 2, project: project)
      end
    end
  end
end
