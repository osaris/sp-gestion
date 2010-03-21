require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  
  should_validate_presence_of(:name, :message => /nom/)
  
  context "with an instance" do
    setup do
      @vehicle = Vehicle.make_unsaved
    end
    
    should "be valid" do
      assert(@vehicle.valid?)
    end
    
    context "used in an intervention" do
      setup do
        make_intervention_with_firemen(:vehicles => [@vehicle], :station => Station.make)
      end
      
      should "not be destroyable" do
        assert_equal(false, @vehicle.destroy)
      end
    end
  end
end
