require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  body        { Faker::Lorem.sentences(5).join(' ') }
  city        { Faker::Lorem.words(1).join(' ') }
  code        { Faker::Lorem.words(1).join(' ') }
  description { Faker::Lorem.sentences(2).join(' ') }
  email       { Faker::Internet.email }
  firstname   { Faker::Name.first_name }
  lastname    { Faker::Name.last_name }
  name        { Faker::Company.name }
  place       { Faker::Lorem.words(2).join(' ') }
  title       { Faker::Lorem.words(3).join(' ') }
  url         { Faker::Internet.domain_word }
end

BetaCode.blueprint do
  email
end

CheckList.blueprint do
  title
end

Convocation.blueprint do
  title
  date(2.weeks.from_now)
  place
  uniform
end

Fireman.blueprint do
  firstname
  lastname
  validate_grade_update(1)
end

Intervention.blueprint do
  place
  city
  start_date(3.days.ago)
  end_date(2.days.ago)
end

Item.blueprint do
  title
  quantity(1)
end

Message.blueprint do
  title
  body
end

Newsletter.blueprint do
  email
end

Newsletter.blueprint(:invited) do
  email
  activated_at(Time.now)
  invited_at(Time.now)
end

Newsletter.blueprint(:inactive) do
  email
  activated_at(nil)
end

Newsletter.blueprint(:active) do
  email
  activated_at(Time.now)
  invited_at(nil)
end

Station.blueprint do
  name
  url
end

Uniform.blueprint do
  title
  code
  description
end

User.blueprint do
  email
  station
  password(pass = Authlogic::Random.hex_token)
  password_confirmation(pass)
end

User.blueprint(:beta) do
  email
  station
  password(pass = Authlogic::Random.hex_token)
  password_confirmation(pass)
  beta_code(BetaCode.make.code)
end

User.blueprint(:confirmed) do
  email
  station
  password(pass = 'test1234')
  password_confirmation(pass)
  confirmed_at(1.day.ago)
  beta_code(BetaCode.make.code)
end

Vehicle.blueprint do
  name
end