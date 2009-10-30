require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  email       { Faker::Internet.email }
  firstname   { Faker::Name.first_name }
  lastname    { Faker::Name.last_name }
  name        { Faker::Company.name }
  url         { Faker::Internet.domain_word }
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