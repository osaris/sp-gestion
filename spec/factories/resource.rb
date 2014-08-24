FactoryGirl.define do
  factory :resource do
    title(Faker::Lorem.words(1).join(' '))
    name(Faker::Lorem.words(1).join(' '))
    category(Faker::Lorem.words(1).join(' '))

    factory(:resource_checklist) do
      title('Check-list')
      name('CheckList')
      category('Matériel')
    end
  end
end
