# -*- encoding : utf-8 -*-
require 'rails_helper'

describe InterventionsHelper do

  before(:each) do
    allow_any_instance_of(Intervention).to receive(:init_number).and_return(1)
  end

  describe "#display_kind_and_subkind" do

    subject { display_kind_and_subkind(Intervention.new) }

    context "with no subkind" do

      before(:each) do
        allow_any_instance_of(Intervention).to receive(:kind).and_return(Intervention::KIND[:div])
      end

      it { should == "Divers"}
    end

    context "with subkind" do

      before(:each) do
        allow_any_instance_of(Intervention).to receive(:kind).and_return(Intervention::KIND[:div])
        allow_any_instance_of(Intervention).to receive(:subkind).and_return('Inondation')
      end

      it { should == "Divers / Inondation"}
    end
  end

  describe "#display_vehicles" do

    subject { display_vehicles(Intervention.new) }

    before(:each) do
      allow_any_instance_of(Intervention).to receive(:vehicles).and_return([create(:vehicle, :name => 'FPT'),
                                                                            create(:vehicle, :name => 'VSAV')])
    end

    it { should == "FPT / VSAV"}
  end

  describe "#map_for" do

    subject { map_for(Intervention.new) }

    before(:each) do
      allow_any_instance_of(Intervention).to receive(:latitude).and_return(47.057493)
      allow_any_instance_of(Intervention).to receive(:longitude).and_return(6.748619)
    end

    it { should match(/google_map/) }
    it { should match(/\(47.057493, 6.748619\)/)}
  end

  describe "#map_for_stats" do

    subject { map_for_stats([Intervention.new, Intervention.new]) }

    before(:each) do
      allow_any_instance_of(Intervention).to receive(:latitude).and_return(47.057493)
      allow_any_instance_of(Intervention).to receive(:longitude).and_return(6.748619)
      allow_any_instance_of(Intervention).to receive(:start_date).and_return(3.days.ago)
      allow_any_instance_of(Intervention).to receive(:end_date).and_return(2.days.ago)
    end

    it { should match(/google_map/) }
    it "plots two points" do
      expect(subject.scan(/\(47.057493, 6.748619\)/i).size).to eq 2
    end
  end

  describe "#min_date_intervention" do

    subject { min_date_intervention(build(:station, :intervention_editable_at => 3.days.ago)) }

    it { should == "-3/1d" }
  end

  describe "display_intervention_role" do

    subject { display_intervention_role(fireman_intervention) }

    context "with intervention_role empty" do

      let(:fireman_intervention) { build(:fireman_intervention, :intervention_role => nil) }

      it { should be_empty }
    end

    context "with intervention_role set" do

      let(:fireman_intervention) { build(:fireman_intervention) }

      it { should_not be_empty }
    end
  end
end
