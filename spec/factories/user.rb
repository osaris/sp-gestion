password = 'test1234'

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com"}
    station
    password(password)
    password_confirmation(password)
  end
end
