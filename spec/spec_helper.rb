require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start('rails') do
  add_filter("/lib/navigation_renderers/")
  merge_timeout(15*60)
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require File.expand_path(File.dirname(__FILE__) + '/blueprints')
require 'authlogic/test_case'
require File.expand_path(File.dirname(__FILE__) + '/matchers/custom_matchers')
require 'email_spec'

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

RSpec.configure do |config|

  config.include(Authlogic::TestCase)
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # FIXME this should be integrated in machinist gem but isn't ready in version 2.0.0.beta2
  def plan(object)
    assigned_attributes = {}
    object.attributes.each do |key, value|
      assigned_attributes[key.to_sym] = value
    end
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

  def make_check_list_with_items(attributes = {})
    cl = CheckList.make!(attributes)
    5.times { cl.items << Item.make! }
    cl.save
    cl
  end

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
    fi = i.fireman_interventions.new
    fi.fireman = make_fireman_with_grades(:station => i.station)
    i.save
    i
  end
end
