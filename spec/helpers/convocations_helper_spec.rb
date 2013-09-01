# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ConvocationsHelper do

  describe "display_last_emailed_at" do

    context "with last_emailed_at nil" do

      it "render -" do
        display_last_emailed_at(nil).should == "-"
      end
    end

    context "last_emailed_at not nil" do

      let(:date) { Date.new(2012, 04, 27) }

      it "render the date" do
        display_last_emailed_at(date).should == I18n.l(date, :format => :default)
      end
    end
  end
end