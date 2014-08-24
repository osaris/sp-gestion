# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Training do

  it { should validate_presence_of(:name).with_message(/nom/) }
  it { should validate_presence_of(:short_name).with_message(/nom court/) }

  let(:training) { create(:training) }

  describe "#destroy" do

    subject { training.destroy }

    context "and not used by a fireman" do

      it { should be_truthy }
    end

    context "and used by a fireman" do

      before { allow(training).to receive_message_chain(:firemen, :empty? => false) }

      it { should be_falsey }
    end
  end
end
