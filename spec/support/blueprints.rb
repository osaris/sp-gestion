# -*- encoding : utf-8 -*-
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

FiremanTraining.blueprint do
  training              { Training.make! }
  achieved_at           { 2.days.ago }
end

Group.blueprint do
  name                  { Faker::Lorem.words(1).join(' ') }
end

Group.blueprint(:destroy_checklist) do
  permissions(1)        { Permission.make(:destroy_checklist) }
end

Intervention.blueprint do
  place                 { Faker::Lorem.words(2).join(' ') }
  city                  { Faker::Lorem.words(1).join(' ') }
  start_date            { 3.days.ago }
  end_date              { 2.days.ago }
end

InterventionRole.blueprint do
  name                  { Faker::Lorem.words(3).join(' ') }
  short_name            { Faker::Lorem.words(1).join(' ') }
end

Item.blueprint do
  title                 { Faker::Lorem.words(3).join(' ') }
  quantity              { 1 }
end

Message.blueprint do
  title                 { Faker::Lorem.words(3).join(' ') }
  body                  { Faker::Lorem.sentences(5).join(' ') }
end

Message.blueprint(:read) do
  title                 { Faker::Lorem.words(3).join(' ') }
  body                  { Faker::Lorem.sentences(5).join(' ') }
  read_at               { Time.now }
end

Permission.blueprint do
  resource              { Resource.make }
  can_read              { false }
  can_create            { false }
  can_update            { false }
  can_destroy           { false }
end

Permission.blueprint(:destroy_checklist) do
  resource              { Resource.make(:checklist) }
  can_destroy           { true }
end

Resource.blueprint do
  title                 { Faker::Lorem.words(1).join(' ') }
  name                  { Faker::Lorem.words(1).join(' ') }
  category              { Faker::Lorem.words(1).join(' ') }
end

Resource.blueprint(:checklist) do
  title                 { 'Check-list' }
  name                  { 'CheckList' }
  category              { 'Matériel' }
end

Station.blueprint do
  name                  { "Firemen station #{sn}" }
  url                   { "station#{sn}" }
end

Station.blueprint(:logo) do
  name                  { "Firemen station logo #{sn}" }
  url                   { "station-logo#{sn}" }
  logo                  { File.open("#{Rails.root}/spec/fixtures/files/uploads/logo/logo.png") }
end

Training.blueprint do
  name                  { Faker::Lorem.words(3).join(' ') }
  short_name            { Faker::Lorem.words(1).join(' ') }
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

Vehicle.blueprint do
  name                  { Faker::Company.name }
end

Group.blueprint do
  name                  { Faker::Company.name }
end
