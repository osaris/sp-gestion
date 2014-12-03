FactoryGirl.define do
  factory :fireman_availability do
    availability(1.day.from_now)

    factory(:fireman_availability_passed) do
      availability(2.days.ago)

      to_create {|instance| instance.save(validate: false) }
    end

    fireman
    station
  end
end
