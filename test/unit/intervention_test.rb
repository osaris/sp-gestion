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

  # work on last year because we can't create interventions for all month
  # of current year
  context "with many interventions" do
    setup do
      @station = Station.make!
      @year = Date.today.year - 1
      vehicles = [Vehicle.new(:name => 'FPT'), Vehicle.new(:name => 'VSAV')]
      12.times do |i|
        start_date = Time.new(@year, (i%12)+1, 15, (i%4), 30, 00) # one per month at 4 different hours
        make_intervention_with_firemen(:station => @station,
                                       :kind => (i%4)+1,					# 3 of each kind
                                       :subkind => "st#{i%4}",		# 4 subkinds
                                       :city => "city#{i%4}",			# 4 cities
                                       :start_date => start_date,
                                       :end_date =>start_date + 1,
                                       :vehicles => [vehicles[i%2]])
      end
    end

    context "stats_by_type" do
      setup do
        @stats_by_type = Intervention.stats_by_type(@station, @year)
      end

      should "return number of interventions grouped by type" do
        assert_equal({1 => 3, 2 => 3, 3 => 3, 4 => 3}, @stats_by_type)
      end
    end

    context "stats_by_subkind" do
      setup do
        @stats_by_subkind = Intervention.stats_by_subkind(@station, @year)
      end

      should "return number of interventions grouped by subkind" do
        assert_equal([["st0", 3], ["st1", 3], ["st2", 3], ["st3", 3]], @stats_by_subkind)
      end
    end

    context "stats_by_month" do
      setup do
        @stats_by_month = Intervention.stats_by_month(@station, @year)
      end

      should "return number of interventions for each month" do
        assert_equal(Array.new(12,1), @stats_by_month)
      end
    end

    context "stats_by_hour" do
      setup do
        @stats_by_hour = Intervention.stats_by_hour(@station, @year)
      end

      should "return number of interventions per hour" do
        assert_equal(Array.new(4, 3) + Array.new(20, 0), @stats_by_hour)
      end
    end

    context "stats_by_city" do
      setup do
        @stats_by_city = Intervention.stats_by_city(@station, @year)
      end

      should "return number of interventions per city" do
        assert_equal([["city0", 3], ["city1", 3], ["city2", 3], ["city3", 3]], @stats_by_city)
      end
    end

    context "stats_by_vehicle" do
      setup do
        @stats_by_vehicle = Intervention.stats_by_vehicle(@station, @year)
      end

      should "return number of interventions per vehicle" do
        assert_equal([["FPT", 6], ["VSAV", 6]], @stats_by_vehicle)
      end
    end
  end
end
