require 'rails_helper'

describe FiremanAvailability do

  it { should validate_presence_of(:fireman_id) }

  it { should validate_presence_of(:availability) }

  it { should validate_presence_of(:station_id) }

  let(:station) { create(:station) }

  let(:fireman) { create(:fireman, :station => station) }

  let(:fireman_availability) { build(:fireman_availability) }

  describe "#create_all" do

    subject { fireman.fireman_availabilities.size }

    before do
      FiremanAvailability::create_all(station, fireman.id, Date.today.to_s)
    end

    it { should == 24 }
  end

  describe "#destroy_all" do

    subject { fireman.fireman_availabilities.size }

    before do
      FiremanAvailability::destroy_all(fireman.id, Date.today.to_s)
    end

    it { should == 0 }
  end

  describe "#destroy" do

    subject { fireman_availability.destroy }

    context "and availability in future" do

      it { should be_truthy }

    end

    context "and availability passed" do

      before do
        fireman_availability.availability = 2.days.ago
      end

      it { should be_falsey }
    end
  end
end
