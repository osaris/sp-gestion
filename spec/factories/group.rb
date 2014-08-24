FactoryGirl.define do
  factory :group do
    name(Faker::Lorem.words(1).join(' '))

    factory(:group_no_right) do
      after(:create) do |group|
        group.permissions << build(:permission,
                                   :resource => build(:resource_checklist))
      end
    end

    factory(:group_destroy_checklist) do
      after(:create) do |group|
        group.permissions << build(:permission,
                                   :can_destroy => true,
                                   :resource => build(:resource_checklist))
      end
    end
  end
end
