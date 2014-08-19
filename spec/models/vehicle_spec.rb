# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Vehicle do

  it { should belong_to(:station) }

  it { should validate_presence_of(:name).with_message(/nom/) }

  let(:station) { Station.make! }
  let(:vehicle) { station.vehicles.make }
  let(:vehicle_delisted) { station.vehicles.make!(:date_delisting => Date.today) }

  describe ".date_delisting" do

    context "set" do

      before do
        vehicle.update_attributes(:date_delisting => Date.today)
      end

      it "set warnings" do
        expect(vehicle.warnings).to eq "Attention, ce véhicule est désormais dans la liste des véhicules radiés."
      end
    end

    context "unset" do

      before do
        vehicle_delisted.update_attributes(:date_delisting => nil)
      end

      it "set warnings" do
        expect(vehicle_delisted.warnings).to eq "Attention, ce véhicule est désormais dans la liste des véhicules."
      end
    end
  end

  describe "#destroy" do

    subject { vehicle.destroy }

    context "and not used in an intervention" do

      it { should be_truthy }
    end

    context "and used in an intervention" do

      before { make_intervention_with_firemen(:vehicles => [vehicle], :station => Station.make!) }

      it { should be_falsey }
    end
  end

  describe ".valid?" do

    subject { vehicle.valid? }

    context "date_delisting is blank" do

      before(:each) do
        vehicle.date_delisting = nil
      end

      it { should be_truthy }
    end

    context "date_delisting set and doesn't change intervention_editable_at" do

      before(:each) do
        vehicle.date_delisting = Date.today
        allow_any_instance_of(Station).to receive(:confirm_intervention_editable_at?)
                                          .and_return(false)
      end

      it { should be_truthy }
    end

    context "date_delisting set and change intervention_editable_at" do

      before(:each) do
        vehicle.date_delisting = Date.today
        allow_any_instance_of(Station).to receive(:confirm_intervention_editable_at?)
                                          .and_return(true)
      end

      it { should be_falsey }
    end

    context "date_delisting set and change intervention_editable_at and change validated" do

      before(:each) do
        vehicle.date_delisting = Date.today
        vehicle.validate_date_delisting_update = 1
        allow_any_instance_of(Station).to receive(:confirm_intervention_editable_at?)
                                          .and_return(true)
      end

      it { should be_truthy }
    end
  end
end
