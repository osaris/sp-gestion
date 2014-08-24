FactoryGirl.define do
  factory :item do
    title(Faker::Lorem.words(3).join(' '))
    quantity(1)
  end
end
