FactoryGirl.define do
  factory :daybook do
    text(Faker::Lorem.sentence(2))
    frontpage(true)
    station
  end
end
