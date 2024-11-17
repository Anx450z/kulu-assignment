FactoryBot.define do
  factory :invite do
    project_id { :project_id }
    email { :email }
    role { :member }
    status { :pending }

    trait :accepted do
      status { :accepted }
    end

    trait :owner do
      role { :owner }
    end

    trait :admin do
      role { :admin }
    end
  end
end
