require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
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

Convocation.blueprint do
  title
  date(2.weeks.from_now)
  place
  uniform
end

Fireman.blueprint do
  firstname
  lastname
end

Newsletter.blueprint do
  email
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

User.blueprint(:confirmed) do
  email
  station
  password(pass = 'test1234')
  password_confirmation(pass)
  confirmed_at(1.day.ago)  
end

Vehicle.blueprint do
  name
end