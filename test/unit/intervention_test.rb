# -*- encoding : utf-8 -*-
require 'test_helper'

class InterventionTest < ActiveSupport::TestCase

  context "with an instance and station last_grade_update_at nil" do
    setup do
      @i = make_intervention_with_firemen(:station => Station.make!)
    end

    should "initialize kind to sap" do
      assert_equal(Intervention::KIND[:sap], @i.kind)
    end

    should "be valid" do
      assert(@i.valid?)
    end

    context "and place not set" do
      setup do
        @i.place = ''
      end

      should "not be valid" do
        assert_equal(false, @i.valid?)
      end
    end

    context "and no firemen" do
      setup do
        @i.firemen = []
      end

      should "not be valid" do
        assert_equal(false, @i.valid?)
      end
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

    should "be editable" do
      assert(@i.editable?)
    end
  end

  context "with an instance and station last_grade_update_at set" do
    setup do
      @s = Station.make!(:last_grade_update_at => 2.days.ago)
      @i = make_intervention_with_firemen(:start_date => 4.days.ago, :end_date => 3.days.ago, :station => @s)
    end

    should "be valid" do
      assert(@i.valid?)
    end

    should "not be editable" do
      assert_equal(false, @i.editable?)
    end
  end

  context "with many interventions" do
    setup do
      @station = Station.make!
      # 3 interventions of kind 1,2 and 2 interventions of kind 3,4
      10.times do |i|
        make_intervention_with_firemen(:station => @station,
                                       :kind => (i%4)+1)
      end
    end

    context "stats_by_type" do
      setup do
        @stats_by_type = Intervention.stats_by_type(@station, Date.today.year)
      end

      should "return number of intervention grouped by type" do
        assert_equal({1 => 3, 2 => 3, 3 => 2, 4 => 2}, @stats_by_type)
      end
    end
  end
end
