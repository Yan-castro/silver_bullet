FactoryBot.define do
  factory :property do
    association :team
    name { "MyString" }
    description { "MyText" }
  end
end
