FactoryGirl.define do
  factory :station do
    sequence(:name) { |n| "Fireman station #{n}" }
    sequence(:url) { |n| "station#{n}"}
  end
end
