# -*- encoding : utf-8 -*-
require 'rails_helper'

describe ConvocationsHelper do

  describe "display_last_emailed_at" do

    context "with last_emailed_at nil" do

      it "render -" do
        expect(display_last_emailed_at(nil)).to eq "-"
      end
    end

    context "last_emailed_at not nil" do

      let(:date) { Date.new(2012, 04, 27) }

      it "render the date" do
        expect(display_last_emailed_at(date)).to eq I18n.l(date, :format => :default)
      end
    end
  end
end
