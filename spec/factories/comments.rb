FactoryBot.define do
  factory :comment do
    body { "MyString" }
    likes { 1 }
    user { nil }
    task { nil }
  end
end
