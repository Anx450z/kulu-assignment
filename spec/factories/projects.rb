FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    description { "Sample project description" }

    factory :project_with_owner do
      transient do
        owner { create(:user) }
      end

      after(:create) do |project, evaluator|
        create(:invite, project: project, user: evaluator.owner, role: :owner, status: :accepted)
      end
    end

    factory :project_with_members do
      transient do
        members_count { 2 }
      end

      after(:create) do |project, evaluator|
        owner = create(:user)
        create(:invite, project: project, user: owner, role: :owner, status: :accepted)

        create_list(:invite, evaluator.members_count, project: project, role: :member, status: :accepted)
      end
    end
  end
end
