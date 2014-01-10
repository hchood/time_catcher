FactoryGirl.define do
  factory :activity_session do
    time_available 10
    start_time Time.new

    association :activity
  end
end
