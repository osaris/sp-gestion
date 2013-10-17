# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Intervention do

  let(:intervention) { make_intervention_with_firemen(:station => Station.make!) }

  let(:station) { Station.make! }

  subject { intervention }

  it { should validate_presence_of(:place).with_message(/lieu/) }

  describe ".kind" do

    subject { intervention.kind }

    it { should == Intervention::KIND[:sap] }
  end

  describe ".valid?" do

    subject { intervention.valid? }

    context "no firemen" do

      before do
        intervention.firemen = []
      end

      it { should be_false }
    end

    context "start_date in future" do

      before do
        intervention.update_attributes(:start_date => 2.day.from_now,
                                       :end_date => 3.days.from_now)
      end

      it { should be_false }
    end

    context "end_date in future" do

      before do
        intervention.update_attributes(:start_date => 1.day.ago,
                                       :end_date => 3.days.from_now)
      end

      it { should be_false }
    end

    context "end_date before start_date" do

      before do
        intervention.update_attributes(:start_date => 1.day.ago,
                                       :end_date => 2.days.ago)
      end

      it { should be_false }
    end

    context "grade updated since intervention" do

      let(:station) { Station.make!(:last_grade_update_at => 2.days.ago) }
      let(:intervention) { make_intervention_with_firemen(:start_date => 4.days.ago,
                                                          :end_date => 3.days.ago,
                                                          :station => station) }

      it { should be_true }
    end
  end

  describe "editable?" do

    context "grade updated since intervention" do

      let(:station) { Station.make!(:last_grade_update_at => 2.days.ago) }
      let(:intervention) { make_intervention_with_firemen(:start_date => 4.days.ago,
                                                          :end_date => 3.days.ago,
                                                          :station => station) }

      subject { intervention.editable? }

      it { should be_false }
    end
  end

  describe ".number" do

    let(:intervention) { station.interventions.make }

    it "is not nil" do
      intervention.number.should_not be_nil
    end

    context "default settings and no other intervention" do

      before do
        Intervention.should_receive(:get_last_intervention_number)
                    .with(instance_of(Station))
                    .and_return(0)
        Intervention.should_not_receive(:get_last_intervention_number_this_year)
      end

      it "is set to 1" do
        intervention.number.should == "1"
      end
    end

    context "interventions_number_size set to 5, and no other intervention" do

      before do
        station.update_attribute(:interventions_number_size, 5)
        Intervention.should_receive(:get_last_intervention_number)
                    .with(instance_of(Station))
                    .and_return(0)
        Intervention.should_not_receive(:get_last_intervention_number_this_year)
      end

      it "is set to 00001" do
        intervention.number.should == "00001"
      end
    end

    context "default settings and last number set to 10" do

      before do
        Intervention.should_receive(:get_last_intervention_number)
                    .with(instance_of(Station))
                    .and_return(10)
        Intervention.should_not_receive(:get_last_intervention_number_this_year)
      end

      it "is set to 11" do
        intervention.number.should == "11"
      end
    end

    context "interventions_number_per_year enabled" do

      before do
        station.update_attribute(:interventions_number_per_year, true)
        Intervention.should_receive(:get_last_intervention_number_this_year)
                    .with(instance_of(Station))
                    .and_return(0)
        Intervention.should_not_receive(:get_last_intervention_number)
      end

      it "is set to 1" do
        intervention.number.should == "1"
      end
    end
  end

  describe "stats" do

    before(:all) do
      @year = Date.today.year - 1
      @station = Station.make!

      12.times do |i|
        # One per month at 4 differents hours, force timezone to avoid problem
        # with winter/summer hour
        start_date = Time.new(@year, (i%12)+1, 15, (i%4), 30, 00, '+01:00')
        make_intervention_with_firemen(:station => @station,
                                       :kind => (i%4)+1,          # 3 of each kind
                                       :subkind => "st#{i%4}",    # 4 subkinds
                                       :city => "city#{i%4}",     # 4 cities
                                       :start_date => start_date,
                                       :end_date =>start_date + 1,
                                       :vehicles => [[Vehicle.new(:name => 'FPT'), Vehicle.new(:name => 'VSAV')][i%2]])
      end
    end

    after(:all) do
      # because before(:all) isn't runned in a transaction
      @station.destroy
    end

    describe ".stats_by_type" do

      subject { Intervention.stats_by_type(@station, @year) }

      it { should == {1 => 3, 2 => 3, 3 => 3, 4 => 3} }
    end

    describe ".stats_by_subkind" do

      subject { Intervention.stats_by_subkind(@station, @year) }

      it { should == [["st0", 3], ["st1", 3], ["st2", 3], ["st3", 3]] }
    end

    describe ".stats_by_month" do

      subject { Intervention.stats_by_month(@station, @year) }

      it { should == Array.new(12,1) }
    end

    describe ".stats_by_hour" do

      subject { Intervention.stats_by_hour(@station, @year) }

      it { should == Array.new(4, 3) + Array.new(20, 0) }
    end

    describe ".stats_by_city" do

      subject { Intervention.stats_by_city(@station, @year) }

      it { should == [["city0", 3], ["city1", 3], ["city2", 3], ["city3", 3]] }
    end

    describe ".stats_by_vehicle" do

      subject { Intervention.stats_by_vehicle(@station, @year) }

      it { should == [["FPT", 6], ["VSAV", 6]] }
    end
  end
end
