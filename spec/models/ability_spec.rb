# -*- encoding : utf-8 -*-
require 'rails_helper'
require 'cancan/matchers'

describe Ability do

  subject(:ability) { Ability.new(user) }

  context "user with no group" do

    let(:user) { create(:user) }

    it { should be_able_to(:manage, CheckList) }
  end

  context "user in a group" do

    let(:user) { create(:user, :group => group) }

    context "and permission on checklist" do

      let(:group) { create(:group_destroy_checklist) }

      it { should be_able_to(:destroy, CheckList) }
    end

    context "and no permission" do

      let(:group) { create(:group_no_right) }

      it { should_not be_able_to(:manage, CheckList) }
    end
  end
end
