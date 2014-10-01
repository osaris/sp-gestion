FactoryGirl.define do
  factory :convocation do
    title(Faker::Lorem.words(4).join(' '))
    date(6.days.from_now)
    place(Faker::Lorem.words(2).join(' '))

    uniform

    station

    after(:build) do |convocation|
      f = FactoryGirl.create(:fireman,
                             :station => convocation.station)
      convocation.firemen << f
    end
  end
end
