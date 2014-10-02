FactoryGirl.define do
  factory :fireman_training do
    achieved_at(Date.today)

    training
  end
end
