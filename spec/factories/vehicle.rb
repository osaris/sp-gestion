FactoryGirl.define do
  factory :vehicle do
    name(Faker::Company.name)
    station

    factory(:vehicle_delisted) do
      date_delisting(Date.today)
    end
  end
end
