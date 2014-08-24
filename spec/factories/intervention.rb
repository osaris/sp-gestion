FactoryGirl.define do
  factory :intervention do
    place(Faker::Lorem.words(2).join(' '))
    city(Faker::Lorem.words(1).join(' '))
    start_date(3.days.ago)
    end_date(2.days.ago)
    station

    factory :intervention_with_firemen do
      after(:create) do |intervention|
        create_list(:fireman, 5, intervention: intervention, :station => station)
      end
    end
  end
end
