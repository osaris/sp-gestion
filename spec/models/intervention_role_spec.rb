# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InterventionRole do

  it { should validate_presence_of(:name).with_message(/nom/) }

  it { should validate_presence_of(:short_name).with_message(/nom court/) }

  let(:intervention_role) { InterventionRole.make! }

  describe "#destroy" do

    subject { intervention_role.destroy }

    context "and not used in an intervention" do

      it { should be_true }
    end

    context "and used in an intervention" do

      before do
        i = make_intervention_with_firemen(:station => Station.make!)
        i.fireman_interventions.first.intervention_role = intervention_role
        i.save
      end

      it { should be_false }
    end
  end
end
