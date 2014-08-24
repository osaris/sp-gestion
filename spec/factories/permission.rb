FactoryGirl.define do
  factory :permission do
    can_read(false)
    can_create(false)
    can_update(false)
    can_destroy(false)

    factory(:permission_destroy) do
      can_destroy(true)
    end
  end
end
