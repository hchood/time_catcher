FactoryGirl.define do
  factory :activity_session do
    time_available 10

    association :activity
  end
end
