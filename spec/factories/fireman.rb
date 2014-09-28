FactoryGirl.define do
  factory :fireman do
    firstname(Faker::Name.first_name)
    lastname(Faker::Name.last_name)
    validate_grade_update(1)
    email(Faker::Internet.email)

    station

    status(Fireman::STATUS['Actif'])
    after(:build) do |fireman|
      fireman.grades.first.date = Date.today
    end
  end
end
