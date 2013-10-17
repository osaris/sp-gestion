require 'spec_helper'

describe Uniform do

  it { should validate_presence_of(:title).with_message(/titre/) }
  it { should validate_presence_of(:description).with_message(/description/) }

  let(:uniform) { Uniform.make! }

  describe "#destroy" do

    subject { uniform.destroy }

    context "and not used in a convocation" do

      it { should be_true }
    end

    context "and used in a convocation" do

      before { make_convocation_with_firemen(:uniform => uniform, :station => Station.make!) }

      it { should be_false }
    end
  end
end
