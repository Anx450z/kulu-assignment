FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    description { "Sample project description" }
    owner_id { create(:user).id } # Correctly assign a user ID

    trait :with_owner do
      after(:build) do |project|
        project.owner_id ||= create(:user).id
      end
    end

    trait :with_members do
      transient do
        members_count { 2 }
      end

      after(:create) do |project, evaluator|
        owner = User.find(project.owner_id) # Use the existing owner

        create_list(:invite, evaluator.members_count, user: owner, project_id: project.id, role: :member, status: :accepted)
      end
    end

    factory :project_with_owner, traits: [ :with_owner ]
    factory :project_with_members, traits: [ :with_members ]
  end
end
