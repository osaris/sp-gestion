FactoryGirl.define do
  factory :uniform do
    title(Faker::Lorem.words(3).join(' '))
    code(Faker::Lorem.words(1).join(' '))
    description(Faker::Lorem.sentences(2).join(' '))
  end
end
