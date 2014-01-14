FactoryGirl.define do
  factory :activity_session do
    time_available 10
    start_time 2.minutes.ago
    finished_at Time.new
    duration_in_seconds 120

    association :activity
    association :user
  end
end
