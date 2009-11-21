require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  
  should_validate_presence_of(:name, :message => /nom/)
  
end
