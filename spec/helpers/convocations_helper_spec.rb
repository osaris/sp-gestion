# -*- encoding : utf-8 -*-
require 'rails_helper'

describe ConvocationsHelper do

  describe "#display_stats_presence" do

    let(:presences) { [:status => 1, :presents => 12, :total => 12] }

    it "display stats for group" do
      display_stats_presence(presences, 1).should ==
        "12 convoqué(s) / 12 présent(s) / 0 absent(s) (100 % présents)"
    end
  end

  describe "#distance_to_next_email_send" do

    it "return remaining number of minutes before next hour" do
      distance_to_next_email_send(11.minutes.ago).should == 48
    end
  end

  describe "#display_last_emailed_at" do

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
