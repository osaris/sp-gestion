FactoryGirl.define do
  factory :check_list do
    title(Faker::Lorem.words(3).join(' '))

    factory(:check_list_with_items) do
      after(:create) do |check_list|
        create_list(:item, 5, check_list: check_list)
      end
    end
  end
end
