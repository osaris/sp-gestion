FactoryGirl.define do
  factory :message do
    title(Faker::Lorem.words(3).join(' '))
    body(Faker::Lorem.sentences(5).join(' '))

    factory(:message_read) do
      read_at(Date.today)
    end
  end
end
