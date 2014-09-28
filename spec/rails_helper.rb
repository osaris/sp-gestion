# This file is copied to spec/ when you run 'rails generate rspec:install'
SimpleCov.start('rails') do
  add_filter("/lib/navigation_renderers/")
  merge_timeout(15*60)
end

ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'authlogic/test_case'
require File.expand_path(File.dirname(__FILE__) + '/matchers/custom_matchers')
require 'email_spec'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.include(FactoryGirl::Syntax::Methods)
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.include(Authlogic::TestCase)

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  def send_file_to_disk(content, filename)
    test_file_path = "#{Rails.root}/tmp/tests/"
    FileUtils.mkdir_p(test_file_path)
    File.open(test_file_path+filename, "w") do |f|
      f.write(content.force_encoding('UTF-8'))
    end
  end

  def login(station = Station.make!, user = User.make!(:confirmed))
    @station = station
    @user = user
    @user.station = @station

    @request.host = "#{@station.url}.sp-gestion.fr"

    UserSession.create(@user)
  end

  # data generation methods
  def make_fireman_with_grades(attributes = {})
    f = attributes[:station].firemen.make(attributes)
    f.grades = Grade::new_defaults
    f.grades.last.date = 2.months.ago
    f.save
    f
  end

  def make_convocation_with_firemen(attributes = {}, number_of_firemen = 1)
    c = Convocation.make(attributes)
    number_of_firemen.times do
      c.firemen << make_fireman_with_grades(:station => c.station)
    end
    c.save
    c
  end

  def make_intervention_with_firemen(attributes = {})
    i = attributes[:station].interventions.make(attributes)
    attributes[:firemen] ||= [make_fireman_with_grades(:station => i.station)]
    attributes[:firemen].each do |fireman|
      fi = i.fireman_interventions.new
      fi.fireman = fireman
    end
    i.save
    i
  end
end
