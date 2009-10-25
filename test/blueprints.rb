require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  email       { Faker::Internet.email }
  name        { Faker::Company.name }
  url         { Faker::Internet.domain_word }
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