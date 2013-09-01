# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InterventionsHelper do

  before(:each) do
    Intervention.any_instance.stub(:init_number).and_return(1)
  end

  describe "#display_kind_and_subkind" do

    subject { display_kind_and_subkind(Intervention.new) }

    context "with no subkind" do

      before(:each) do
        Intervention.any_instance.stub(:kind).and_return(Intervention::KIND[:div])
      end

      it { should == "Divers"}
    end

    context "with subkind" do

      before(:each) do
        Intervention.any_instance.stub(:kind).and_return(Intervention::KIND[:div])
        Intervention.any_instance.stub(:subkind).and_return('Inondation')
      end

      it { should == "Divers / Inondation"}
    end
  end

  describe "#display_vehicles" do

    subject { display_vehicles(Intervention.new) }

    before(:each) do
      Intervention.any_instance.stub(:vehicles).and_return([Vehicle.make(:name => 'FPT'),
                                                            Vehicle.make(:name => 'VSAV')])
    end

    it { should == "FPT / VSAV"}
  end

  describe "#map_for" do

    subject { map_for(Intervention.new) }

    before(:each) do
      Intervention.any_instance.stub_chain(:geocode, :latitude).and_return(47.057493)
      Intervention.any_instance.stub_chain(:geocode, :longitude).and_return(6.748619)
    end

    it { should match(/google_map/) }
    it { should match(/\(47.057493, 6.748619\)/)}
  end

  describe "#map_for_stats" do

    subject { map_for_stats([Intervention.new, Intervention.new]) }

    before(:each) do
      Intervention.any_instance.stub_chain(:geocode, :latitude).and_return(47.057493)
      Intervention.any_instance.stub_chain(:geocode, :longitude).and_return(6.748619)
      Intervention.any_instance.stub(:start_date).and_return(3.days.ago)
      Intervention.any_instance.stub(:end_date).and_return(2.days.ago)
    end

    it { should match(/google_map/) }
    it "plots two points" do
      subject.scan(/\(47.057493, 6.748619\)/i).size.should == 2
    end
  end
end
