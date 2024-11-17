FactoryBot.define do
  factory :invite do
    project_id { create(:project).id }
    email { create(:user).email }
    role { :member }
    status { :pending }
    user { create(:user) }

    trait :accepted do
      status { :accepted }
    end

    trait :member do
      role { :member }
    end

    trait :admin do
      role { :admin }
    end
  end
end
