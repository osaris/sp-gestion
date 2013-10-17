require 'spec_helper'

describe User do

  setup(:activate_authlogic)

  let(:user) { User.make! }

  describe "#confirmed?" do

    subject { user.reload.confirmed? }

    it { should be_false }

    context "after a call to confirm with bad password" do

      before { user.confirm!('123', '') }

      it { should be_false }
    end

    context "after a call to confirm with good password" do

      before { user.confirm!('123456', '123456') }

      it { should be_true }
    end
  end

  describe "#reset_password!" do

    context "with wrong password" do

      subject { user.reset_password!('test', 'test') }

      it { should be_false }
    end

    context "with good password" do

      subject { user.reset_password!('test3467', 'test3467') }

      it { should be_true }
    end
  end

  describe "#deliver_confirmation_instructions!" do

    it "unconfirm user" do
      user.deliver_confirmation_instructions!

      user.confirmed?.should be_false
    end

    it "send an email" do
      UserMailer.should_receive(:confirmation_instructions)
                .and_return(double("mailer", :deliver => true))

      user.deliver_confirmation_instructions!
    end
  end

  describe "#deliver_cooptation_instructions!" do

    it "unconfirm user" do
      user.deliver_cooptation_instructions!

      user.confirmed?.should be_false
    end

    it "send an email" do
      UserMailer.should_receive(:cooptation_instructions)
                .and_return(double("mailer", :deliver => true))

      user.deliver_cooptation_instructions!
    end
  end

  describe "#password_reset_instructions!" do

    it "send an email" do
      UserMailer.should_receive(:password_reset_instructions)
                .and_return(double("mailer", :deliver => true))

      user.deliver_password_reset_instructions!
    end
  end

  describe "#deliver_new_email_instructions!" do

    let(:user) { User.make!(:new_email => 'foo@bar.com')}

    it "it resets perishable_token" do
      old_perishable_token = user.perishable_token
      user.send(:deliver_new_email_instructions!)

      user.perishable_token.should_not == old_perishable_token
    end

    it "send an email" do
      UserMailer.should_receive(:new_email_instructions)
                .and_return(double("mailer", :deliver => true))

      user.send(:deliver_new_email_instructions!)
    end
  end
end
