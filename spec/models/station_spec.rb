# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Station do

  describe "#last_grade_updated_at" do

    context "last_grade_update_at blank" do

      let(:station) { Station.make!(:last_grade_update_at => nil) }

      it "doesn't confirm last_grade_update_at" do
        expect(station.confirm_last_grade_update_at?(Date.today)).to be_falsey
      end
    end

    let(:station) { Station.make!(:last_grade_update_at => Date.today) }

    context "last_grade_update_at but no intervention" do

      it "doesn't confirm last_grade_update_at" do
        expect(station.confirm_last_grade_update_at?(Date.today)).to be_falsey
      end
    end

    context "last_grade_update_at and interventions but date before last_grade_update_at" do

      before { allow(station.interventions).to receive(:empty?)
                                               .and_return(false) }

      it "doesn't confirm last_grade_update_at" do
        expect(station.confirm_last_grade_update_at?(3.days.ago)).to be_falsey
      end
    end
  end

  describe ".owner_id" do

    let(:user) { User.new }
    let(:station) { Station.create(:users => [user]) }

    it "set owner_id to user" do
      expect(station.owner_id).to eq user.id
    end
  end

  describe "#can_send_email?" do

    let(:station) { Station.make! }

    it "let send less than NB_EMAIL_PER_HOUR" do
      expect(station.can_send_email?(NB_EMAIL_PER_HOUR-1)).to be_truthy
    end

    it "let send NB_EMAIL_PER_HOUR" do
      expect(station.can_send_email?(NB_EMAIL_PER_HOUR)).to be_truthy
    end

    it "doesn't let send more than NB_EMAIL_PER_HOUR" do
      expect(station.can_send_email?(NB_EMAIL_PER_HOUR+1)).to be_falsey
    end
  end

  describe "#reset_email_limitation" do

    before { station.reset_email_limitation }

    context "with an instance which has sent emails 3 hours ago and call to reset_email_limitation" do

      let(:station) { Station.make!(:last_email_sent_at => 3.hours.ago, :nb_email_sent => 10) }

      it "reset nb_email_sent" do
        expect(station.reload.nb_email_sent).to eq 0
      end
    end

    context "with an instance which has sent emails 15 minutes ago and call to reset_email_limitation" do

      let(:station) { Station.make!(:last_email_sent_at => 15.minutes.ago, :nb_email_sent => 10) }

      it "doesn't reset nb_email_sent" do
        expect(station.reload.nb_email_sent).to eq 10
      end
    end
  end
end
