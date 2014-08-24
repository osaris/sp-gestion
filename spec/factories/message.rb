FactoryGirl.define do
  factory :message do
    title(Faker::Lorem.words(3).join(' '))
    body(Faker::Lorem.sentences(5).join(' '))
  end
end
