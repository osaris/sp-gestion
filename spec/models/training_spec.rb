# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Training do

  it { should validate_presence_of(:name).with_message(/nom/) }
  it { should validate_presence_of(:short_name).with_message(/nom court/) }

  let(:training) { Training.make! }


  describe "#destroy" do

    subject { training.destroy }

    context "and not used by a fireman" do

      it { should be_truthy }
    end

    context "and used by a fireman" do

      before {  make_fireman_with_grades(:fireman_trainings => [FiremanTraining.make(:training => training)],
                                         :station => Station.make!) }

      it { should be_falsey }
    end
  end
end