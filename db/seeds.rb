# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Create a demo account
station = Station.new(:name => 'cpi-demo', :url => 'cpi-demo')
user = station.users.build(:email => 'demo@sp-gestion.dev')
station.save

# Confirm user
user.confirm!('demospg', 'demospg')
