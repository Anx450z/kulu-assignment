FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    description { "Sample project description" }
    owner { create(:user) }

    trait :with_owner do
      after(:build) do |project|
        project.owner ||= create(:user)
      end
    end

    trait :with_members do
      transient do
        members_count { 2 }
      end

      after(:create) do |project, evaluator|
        owner = User.find(project.owner.id)

        create_list(:invite, evaluator.members_count, user: owner, project: project, role: :member, status: :accepted)
      end
    end

    factory :project_with_owner, traits: [ :with_owner ]
    factory :project_with_members, traits: [ :with_members ]
  end
end
