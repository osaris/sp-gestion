# -*- encoding : utf-8 -*-
require 'spec_helper'

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
        convocation_in_future.valid?.should be_true
      end
    end

    context "date in the past" do

      it "is false" do
        convocation_in_past.valid?.should be_false
      end
    end
  end

  describe "#editable?" do

    context "date in the future" do

      it "is true" do
        convocation_in_future.editable?.should be_true
      end
    end

    context "date in the past" do

      it "is false" do
        convocation_in_past.editable?.should be_false
      end
    end
  end

  describe "#send_emails" do

    context "with 1 fireman" do

      let(:convocation) { make_convocation_with_firemen({:date => 3.days.from_now,
                                                     :station => Station.make!}, 1) }

      it "deliver convocations" do
        ConvocationMailer.should_receive(:convocation)
                         .with(an_instance_of(Convocation), an_instance_of(ConvocationFireman), an_instance_of(String))
                         .and_return(double("mailer", :deliver => true))

        convocation.send_emails("test@test.com")
      end

      it "deliver a sending confirmation" do
        ConvocationMailer.should_receive(:sending_confirmation)
                         .with(an_instance_of(Convocation), an_instance_of(String))
                         .and_return(double("mailer", :deliver => true))

        convocation.send_emails("test@test.com")
      end

      before { convocation.send_emails("test@test.com") }

      it "set nb_email_sent" do
        convocation.station.reload.nb_email_sent.should == 1
      end

      it "update last_emailed_at" do
        convocation.last_emailed_at.should_not be_nil
      end
    end

    context "with 3 firemen (2 emails)" do

      let(:convocation) { make_convocation_with_firemen({:date => 3.days.from_now,
                                                         :station => Station.make!}, 3) }

      before { convocation.firemen.first.update_attribute(:email, '') }

      it "deliver convocations" do
        ConvocationMailer.should_receive(:convocation)
                         .twice
                         .with(an_instance_of(Convocation), an_instance_of(ConvocationFireman), an_instance_of(String))
                         .and_return(double("mailer", :deliver => true))

        convocation.send_emails("test@test.com")
      end

      before { convocation.send_emails("test@test.com") }

      it "set nb_email_sent" do
        convocation.station.reload.nb_email_sent.should == 2
      end

      it "update last_emailed_at" do
        convocation.last_emailed_at.should_not be_nil
      end
    end
  end
end
