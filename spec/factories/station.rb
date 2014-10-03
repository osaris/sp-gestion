FactoryGirl.define do
  factory :station do
    sequence(:name) { |n| "Fireman station #{n}" }
    sequence(:url) { |n| "station#{n}"}

    factory(:station_logo) do
      logo(File.open("#{Rails.root}/spec/fixtures/files/uploads/logo/logo_test.png"))
    end
  end
end
