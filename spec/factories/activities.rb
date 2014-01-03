FactoryGirl.define do
  factory :activity do
    sequence(:name) { |n| "Activity #{n}" }
    description "This is a generic activity."
    time_needed_in_min 5

    association :user
  end
end
