require 'test_helper'

class InterventionTest < ActiveSupport::TestCase

  should_validate_presence_of(:place, :message => /lieu/)
  should_validate_presence_of(:firemen, :message => /personnel/)  
  
  context "with an instance" do
    setup do
      @i = make_intervention_with_firemen(:station => Station.make)
    end

    should "initialize kind to sap" do
      assert_equal(Intervention::KIND[:sap], @i.kind)
    end
    
    should "be valid" do
      assert(@i.valid?)
    end
    
    context "and start_date in future" do
      setup do
        @i.start_date = 3.days.from_now
      end
      
      should "not be valid" do
        assert_equal(false, @i.valid?)
      end
    end
    
    context "and end_date in future" do
      setup do
        @i.end_date = 3.days.from_now
      end
      
      should "not be valid" do
        assert_equal(false, @i.valid?)
      end
    end
    
    context "and end_date before start_date" do
      setup do
        @i.start_date = 1.days.ago
        @i.end_date = 2.days.ago
      end

      should "not be valid" do
        assert_equal(false, @i.valid?)
      end
    end
    
    should "have a number" do
      assert_not_nil(@i.number)
    end
  end
  
  context "with many interventions" do
    setup do
      @station = Station.make
      # 3 interventions of kind 1,2 and 2 interventions of kind 3,4
      10.times do |i|
        make_intervention_with_firemen(:station => @station,
                                       :kind => (i%4)+1)
      end
    end

    context "stats_by_type" do
      setup do
        @stats_by_type = Intervention.stats_by_type(@station)
      end

      should "return number of intervention grouped by type" do
        assert_equal({1 => 3, 2 => 3, 3 => 2, 4 => 2}, @stats_by_type)
      end
    end
  end
end
