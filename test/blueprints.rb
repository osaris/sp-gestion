require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.define do
  email       { Faker::Internet.email }
end

Newsletter.blueprint do
  email
end