# -*- encoding : utf-8 -*-
require 'test_helper'

class VehicleTest < ActiveSupport::TestCase

  should validate_presence_of(:name).with_message(/nom/)

  context "with an instance" do
    setup do
      @vehicle = Vehicle.make
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
