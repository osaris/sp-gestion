FactoryGirl.define do
  factory :intervention do
    place(Faker::Lorem.words(2).join(' '))
    city(Faker::Lorem.words(1).join(' '))
    start_date(3.days.ago)
    end_date(2.days.ago)

    station
    # because we need the station for number format
    initialize_with { new(:station => station) }

    after(:build) do |intervention|
      f = FactoryGirl.create(:fireman,
                             :station => intervention.station)
      intervention.firemen << f
    end
  end
end
