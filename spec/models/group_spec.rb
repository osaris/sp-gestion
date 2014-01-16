# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Group do

  it { should belong_to(:station) }
  it { should have_many(:users) }
  it { should have_many(:permissions) }
  it { should have_many(:resources) }

  it { should validate_presence_of(:name).with_message(/nom/) }

  describe "#initialized_permissions" do

    subject { group.initialized_permissions(resources) }

    let(:resources) { [Resource.make(:checklist)] }

    context "with a new group" do

      let(:group) { Group.make }

      it { should have(1).items }
    end

    context "with an existing group" do

      let(:group) { Group.make(:permissions => [Permission.make(:resource => resources.first)]) }

      it { should have(1).items }

      it "should be linked to the existing resource" do
        resources.first.should equal(group.permissions.first.resource)
      end
    end
  end
end
