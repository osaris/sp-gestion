# -*- encoding : utf-8 -*-
require 'rails_helper'

describe InterventionRole do

  it { should validate_presence_of(:name).with_message(/nom/) }

  it { should validate_presence_of(:short_name).with_message(/nom court/) }

  let(:intervention_role) { create(:intervention_role) }

  describe "#destroy" do

    subject { intervention_role.destroy }

    context "and not used in an intervention" do

      it { should be_truthy }
    end

    context "and used in an intervention" do

      before do
        i = create(:intervention)
        i.fireman_interventions.first.intervention_role = intervention_role
        i.save
      end

      it { should be_falsey }
    end
  end
end
