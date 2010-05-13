ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'shoulda/rails'
require 'test_help'
require "authlogic/test_case"
require File.expand_path(File.dirname(__FILE__)+"/blueprints")

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...

  # setup :activate_authlogic

  setup { Sham.reset }
end

# Disable transparent delayed_job methods in test mode
module Delayed
  module MessageSending
    def send_later(method, *args)
      send(method, *args)
    end
  end
end

def login(station = Station.make, user = User.make(:confirmed))
  @station = station
  @user = user
  @user.station = @station

  @request.host = "#{@station.url}.sp-gestion.fr"

  UserSession.create(@user)
end

def logout(user)
  session = UserSession.find(user)
  session.destroy
end

def send_file_to_disk(content, filename)
  test_file_path = "#{RAILS_ROOT}/tmp/tests/"
  FileUtils.mkdir_p(test_file_path)
  File.open(test_file_path+filename, "w") do |f|
    f.write(content)
  end
end

# data

def make_station_with_user(attributes = {})
  s = Station.make_unsaved(attributes)
  s.users << User.new
  s.save
  s
end

def make_fireman_with_grades(attributes = {})
  f = Fireman.make_unsaved(attributes)
  f.grades = Grade::new_defaults
  f.grades.last.date = 2.months.ago
  f.save
  f
end

def make_convocation_with_firemen(attributes = {})
  c = Convocation.make_unsaved(attributes)
  c.firemen << make_fireman_with_grades(:station => c.station)
  c.save
  c
end

def make_check_list_with_items(attributes = {})
  cl = CheckList.make(attributes)
  5.times { cl.items << Item.make }
  cl.save
  cl
end

def make_intervention_with_firemen(attributes = {})
  i = Intervention.make_unsaved(attributes)
  i.firemen << make_fireman_with_grades(:station => i.station)
  i.save
  i
end