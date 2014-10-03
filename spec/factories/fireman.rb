FactoryGirl.define do
  factory :fireman do
    ignore do
      grade(Grade::GRADE['2e classe'])
    end

    firstname(Faker::Name.first_name)
    lastname(Faker::Name.last_name)
    validate_grade_update(1)
    email(Faker::Internet.email)

    station

    status(Fireman::STATUS['Actif'])

    after(:build) do |fireman, evaluator|
      fireman.grades.each do |grade|
        if grade.kind <= evaluator.grade
          grade.date = Date.today
        end
      end
    end
  end
end
