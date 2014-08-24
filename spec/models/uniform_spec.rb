# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Uniform do

  it { should validate_presence_of(:title).with_message(/titre/) }
  it { should validate_presence_of(:description).with_message(/description/) }

  let(:uniform) { create(:uniform) }

  describe "#destroy" do

    subject { uniform.destroy }

    context "and not used in a convocation" do

      it { should be_truthy }
    end

    context "and used in a convocation" do

      before { allow(uniform).to receive_message_chain(:convocations, :empty? => false) }

      it { should be_falsey }
    end
  end
end
