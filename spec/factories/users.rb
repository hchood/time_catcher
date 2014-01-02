# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "Jane"
    last_name "Smith"
    sequence(:email) { |n| "jsmith#{n}@example.com"}
    password "secret_password"
    password_confirmation "secret_password"
  end
end
