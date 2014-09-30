# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Intervention do

  let(:intervention) { create(:intervention, :station => create(:station)) }

  let(:station) { create(:station) }

  subject { intervention }

  it { should validate_presence_of(:place).with_message(/lieu/) }

  describe "#initialized_fireman_interventions" do

    subject { intervention.initialized_fireman_interventions }

    let(:fireman) { create(:fireman) }

    context "with a new intervention" do

      let(:intervention) { create(:intervention, :station => station) }

      # force creation of a fireman in the station
      before { fireman }

      it "should have one item" do
        expect(subject.size).to eq 1
      end
    end

    context "with an existing intervention" do

      let(:intervention) { create(:intervention, :station => station,
                                                 :firemen => [fireman]) }

      it "should have one item" do
        expect(subject.size).to eq 1
      end

      it "should be linked to the existing fireman intervention" do
        expect(intervention.fireman_interventions.first.fireman).to eq fireman
      end
    end
  end

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

      it { should be_falsey }
    end

    context "start_date in future" do

      before do
        intervention.update_attributes(:start_date => 2.day.from_now,
                                       :end_date => 3.days.from_now)
      end

      it { should be_falsey }
    end

    context "end_date in future" do

      before do
        intervention.update_attributes(:start_date => 1.day.ago,
                                       :end_date => 3.days.from_now)
      end

      it { should be_falsey }
    end

    context "end_date before start_date" do

      before do
        intervention.update_attributes(:start_date => 1.day.ago,
                                       :end_date => 2.days.ago)
      end

      it { should be_falsey }
    end

    context "grade updated since intervention" do

      let(:station) { create(:station, :intervention_editable_at => 2.days.ago) }
      let(:intervention) { create(:intervention, :start_date => 4.days.ago,
                                                 :end_date => 3.days.ago,
                                                 :station => station) }

      it { should be_truthy }
    end
  end

  describe "editable?" do

    context "grade updated since intervention" do

      let(:station) { create(:station, :intervention_editable_at => 2.days.ago) }
      let(:intervention) { create(:intervention, :start_date => 4.days.ago,
                                                 :end_date => 3.days.ago,
                                                 :station => station) }

      subject { intervention.editable? }

      it { should be_falsey }
    end
  end

  describe ".number" do

    let(:intervention) { create(:intervention, :station => station) }

    it "is not nil" do
      expect(intervention.number).to_not be_nil
    end

    context "default settings and no other intervention" do

      before do
        expect(Intervention).to receive(:get_last_intervention_number)
                                .with(instance_of(Station))
                                .and_return(0)
        expect(Intervention).to_not receive(:get_last_intervention_number_this_year)
      end

      it "is set to 1" do
        expect(intervention.number).to eq "1"
      end
    end

    context "interventions_number_size set to 5, and no other intervention" do

      before do
        station.update_attribute(:interventions_number_size, 5)
        expect(Intervention).to receive(:get_last_intervention_number)
                                .with(instance_of(Station))
                                .and_return(0)
        expect(Intervention).to_not receive(:get_last_intervention_number_this_year)
      end

      it "is set to 00001" do
        expect(intervention.number).to eq "00001"
      end
    end

    context "default settings and last number set to 10" do

      before do
        expect(Intervention).to receive(:get_last_intervention_number)
                                .with(instance_of(Station))
                                .and_return(10)
        expect(Intervention).to_not receive(:get_last_intervention_number_this_year)
      end

      it "is set to 11" do
        expect(intervention.number).to eq "11"
      end
    end

    context "interventions_number_per_year enabled" do

      before do
        station.update_attribute(:interventions_number_per_year, true)
        expect(Intervention).to receive(:get_last_intervention_number_this_year)
                                .with(instance_of(Station))
                                .and_return(0)
        expect(Intervention).to_not receive(:get_last_intervention_number)
      end

      it "is set to 1" do
        expect(intervention.number).to eq "1"
      end
    end
  end

  describe "stats" do

    before(:all) do
      @year = Date.today.year - 1
      @station = create(:station)

      12.times do |i|
        # One per month at 4 differents hours, force timezone to avoid problem
        # with winter/summer hour
        start_date = Time.new(@year, (i%12)+1, 15, (i%4), 30, 00, '+01:00')
        create(:intervention, :station => @station,
                              :kind => (i%4)+1,          # 3 of each kind
                              :subkind => "st#{i%4}",    # 4 subkinds
                              :city => "city#{i%4}",     # 4 cities
                              :start_date => start_date,
                              :end_date =>start_date + 1,
                              :vehicles => [[Vehicle.new(:name => 'FPT'), Vehicle.new(:name => 'VSAV')][i%2]])
      end
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
