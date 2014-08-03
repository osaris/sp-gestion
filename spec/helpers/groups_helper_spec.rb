# -*- encoding : utf-8 -*-
require 'rails_helper'

describe GroupsHelper do

  describe "#permission_icon" do

    subject { permission_icon(authorized) }

    context "authorized" do

      let(:authorized) { true }

      it { should == "<i class=\"icon-ok\"></i>" }
    end

    context "not authorized" do

      let(:authorized) { false }

      it { should == "<i class=\"icon-remove\"></i>" }
    end
  end
end
