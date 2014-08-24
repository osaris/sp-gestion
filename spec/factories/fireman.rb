FactoryGirl.define do
  factory :fireman do
    firstname(Faker::Name.first_name)
    lastname(Faker::Name.last_name)
    validate_grade_update(1)
    email(Faker::Internet.email)
  end
end
