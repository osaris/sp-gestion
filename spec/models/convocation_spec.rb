# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Convocation do

  it { should validate_presence_of(:title).with_message(/titre/) }

  it { should validate_presence_of(:date).with_message(/date/) }

  it { should validate_presence_of(:uniform).with_message(/tenue/) }

  it { should validate_presence_of(:firemen).with_message(/personnes/) }

  let(:convocation_in_future) { make_convocation_with_firemen(:date => 3.days.from_now,
                                                              :station => Station.make!) }

  let(:convocation_in_past) { make_convocation_with_firemen(:date => 3.days.ago,
                                                            :station => Station.make!) }

  describe "#valid?" do

    context "date in the future" do

      it "is true" do
        expect(convocation_in_future.valid?).to be_truthy
      end
    end

    context "date in the past" do

      it "is false" do
        expect(convocation_in_past.valid?).to be_falsey
      end
    end
  end

  describe "#editable?" do

    context "date in the future" do

      it "is true" do
        expect(convocation_in_future.editable?).to be_truthy
      end
    end

    context "date in the past" do

      it "is false" do
        expect(convocation_in_past.editable?).to be_falsey
      end
    end
  end

  describe "#send_emails" do

    context "with 1 fireman" do

      let(:convocation) { make_convocation_with_firemen({:date => 3.days.from_now,
                                                     :station => Station.make!}, 1) }

      it "deliver convocations" do
        expect(ConvocationMailer).to receive(:convocation)
                                     .with(an_instance_of(Convocation), an_instance_of(ConvocationFireman), an_instance_of(String))
                                     .and_return(double("mailer", :deliver => true))

        convocation.send_emails("test@test.com")
      end

      it "deliver a sending confirmation" do
        expect(ConvocationMailer).to receive(:sending_confirmation)
                                     .with(an_instance_of(Convocation), an_instance_of(String))
                                     .and_return(double("mailer", :deliver => true))

        convocation.send_emails("test@test.com")
      end

      before { convocation.send_emails("test@test.com") }

      it "set nb_email_sent" do
        expect(convocation.station.reload.nb_email_sent).to eq 1
      end

      it "update last_emailed_at" do
        expect(convocation.last_emailed_at).to_not be_nil
      end
    end

    context "with 3 firemen (2 emails)" do

      let(:convocation) { make_convocation_with_firemen({:date => 3.days.from_now,
                                                         :station => Station.make!}, 3) }

      before { convocation.firemen.first.update_attribute(:email, '') }

      it "deliver convocations" do
        expect(ConvocationMailer).to receive(:convocation)
                                     .twice
                                     .with(an_instance_of(Convocation), an_instance_of(ConvocationFireman), an_instance_of(String))
                                     .and_return(double("mailer", :deliver => true))

        convocation.send_emails("test@test.com")
      end

      before { convocation.send_emails("test@test.com") }

      it "set nb_email_sent" do
        expect(convocation.station.reload.nb_email_sent).to eq 2
      end

      it "update last_emailed_at" do
        expect(convocation.last_emailed_at).to_not be_nil
      end
    end
  end
end
