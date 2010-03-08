require 'test_helper'

class InterventionTest < ActiveSupport::TestCase

  should_validate_presence_of(:place, :message => /lieu/)
  
  context "with an instance" do
    setup do
      @i = Intervention.make_unsaved(:station => Station.make)
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
    
    context "saved" do
      setup do
        @i.save
      end

      should "have a number" do
        assert_not_nil(@i.number)
      end
    end
  end
end
