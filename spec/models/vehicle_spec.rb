# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Vehicle do

  it { should belong_to(:station) }

  it { should validate_presence_of(:name).with_message(/nom/) }

  let(:vehicle) { Vehicle.make }

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
end
