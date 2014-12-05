require 'rails_helper'

describe Station do

  describe "#intervention_editable_at" do

    context "intervention_editable_at blank" do

      let(:station) { create(:station, :intervention_editable_at => nil) }

      it "doesn't confirm intervention_editable_at" do
        expect(station.confirm_intervention_editable_at?(Date.today)).to be_falsey
      end
    end

    let(:station) { create(:station, :intervention_editable_at => Date.today) }

    context "intervention_editable_at but no intervention" do

      it "doesn't confirm intervention_editable_at" do
        expect(station.confirm_intervention_editable_at?(Date.today)).to be_falsey
      end
    end

    context "intervention_editable_at and interventions but date before intervention_editable_at" do

      before { allow(station.interventions).to receive(:empty?)
                                               .and_return(false) }

      it "doesn't confirm intervention_editable_at" do
        expect(station.confirm_intervention_editable_at?(3.days.ago)).to be_falsey
      end
    end
  end

  describe ".owner_id" do

    let(:user) { build(:user) }
    let(:station) { create(:station, :users => [user]) }

    it "set owner_id to user" do
      expect(station.owner_id).to eq user.id
    end
  end

  describe "#can_send_email?" do

    let(:station) { create(:station) }

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

      let(:station) { create(:station, :last_email_sent_at => 3.hours.ago, :nb_email_sent => 10) }

      it "reset nb_email_sent" do
        expect(station.reload.nb_email_sent).to eq 0
      end
    end

    context "with an instance which has sent emails 15 minutes ago and call to reset_email_limitation" do

      let(:station) { create(:station, :last_email_sent_at => 15.minutes.ago, :nb_email_sent => 10) }

      it "doesn't reset nb_email_sent" do
        expect(station.reload.nb_email_sent).to eq 10
      end
    end
  end
end
