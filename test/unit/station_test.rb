require 'test_helper'

class StationTest < ActiveSupport::TestCase
  
  context "an instance" do
    setup do
      @station = Station.new
    end
    
    context "saved" do
      setup do
        @station.save
      end

      should "have last_grade_update_at set to 1900-01-01" do
        assert_equal(Time.mktime(2000, 1, 1), @station.last_grade_update_at)
      end
    end
  end
end
