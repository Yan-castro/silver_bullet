FactoryBot.define do
  factory :booking do
    association :property
    start_date_time { "2023-09-19 16:00:42" }
    end_date_time { "2023-09-19 16:00:42" }
    extra_info { "MyString" }
    access_info { "MyString" }
  end
end
