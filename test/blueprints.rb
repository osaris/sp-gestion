require 'machinist/active_record'
require 'faker'

password = 'test1234'

CheckList.blueprint do
  title                 { Faker::Lorem.words(3).join(' ') }
end

Convocation.blueprint do
  title                 { Faker::Lorem.words(3).join(' ') }
  date                  { 2.weeks.from_now }
  place                 { Faker::Lorem.words(2).join(' ') }
  uniform
end

Fireman.blueprint do
  firstname             { Faker::Name.first_name }
  lastname              { Faker::Name.last_name }
  validate_grade_update { 1 }
  email                 { Faker::Internet.email }
end

Intervention.blueprint do
  place                 { Faker::Lorem.words(2).join(' ') }
  city                  { Faker::Lorem.words(1).join(' ') }
  start_date            { 3.days.ago }
  end_date              { 2.days.ago }
end

Item.blueprint do
  title                 { Faker::Lorem.words(3).join(' ') }
  quantity              { 1 }
end

Message.blueprint do
  title                 { Faker::Lorem.words(3).join(' ') }
  body                  { Faker::Lorem.sentences(5).join(' ') }
end

Station.blueprint do
  name                  { "Firemen station #{sn}" }
  url                   { "station#{sn}" }
end

Station.blueprint(:logo) do
  name                  { "Firemen station logo #{sn}" }
  url                   { "station-logo#{sn}" }
  logo                  { File.open("#{Rails.root}/test/fixtures/uploads/logo/logo.png")}
end

Uniform.blueprint do
  title                 { Faker::Lorem.words(3).join(' ') }
  code                  { Faker::Lorem.words(1).join(' ') }
  description           { Faker::Lorem.sentences(2).join(' ') }
end

User.blueprint do
  email                 { "test#{sn}@test.com" }
  station
  password              { password }
  password_confirmation { password }
end

User.blueprint(:confirmed) do
  email                 { "test-confirmed#{sn}@test.com" }
  station
  password              { password }
  password_confirmation { password }
  confirmed_at          { 1.day.ago }
end

TypusUser.blueprint do
  email                 { "test-admin#{sn}@test.com" }
  role                  { "admin" }
  status                { true }
  token                 { "1A2B3C4D5E6F" }
  password              { "12345678" }
end

Vehicle.blueprint do
  name                  { Faker::Company.name }
end