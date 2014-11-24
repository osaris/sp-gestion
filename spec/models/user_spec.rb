# -*- encoding : utf-8 -*-
require 'rails_helper'

describe User do

  setup(:activate_authlogic)

  let(:user) { create(:user) }

  describe "#confirmed?" do

    subject { user.reload.confirmed? }

    it { should be_falsey }

    context "after a call to confirm with bad password" do

      before { user.confirm!('123', '') }

      it { should be_falsey }
    end

    context "after a call to confirm with good password" do

      before { user.confirm!('123456', '123456') }

      it { should be_truthy }
    end
  end

  describe "#reset_password!" do

    context "with wrong password" do

      subject { user.reset_password!('test', 'test') }

      it { should be_falsey }
    end

    context "with good password" do

      subject { user.reset_password!('test3467', 'test3467') }

      it { should be_truthy }
    end
  end

  describe "#deliver_confirmation_instructions!" do

    it "unconfirm user" do
      user.deliver_confirmation_instructions!

      expect(user.confirmed?).to be_falsey
    end

    it "send an email" do
      expect(UserMailer).to receive(:confirmation_instructions)
                            .and_return(double("mailer", :deliver_later => true))

      user.deliver_confirmation_instructions!
    end
  end

  describe "#deliver_cooptation_instructions!" do

    it "unconfirm user" do
      user.deliver_cooptation_instructions!

      expect(user.confirmed?).to be_falsey
    end

    it "send an email" do
      expect(UserMailer).to receive(:cooptation_instructions)
                            .and_return(double("mailer", :deliver_later => true))

      user.deliver_cooptation_instructions!
    end
  end

  describe "#password_reset_instructions!" do

    it "send an email" do
      expect(UserMailer).to receive(:password_reset_instructions)
                            .and_return(double("mailer", :deliver_later => true))

      user.deliver_password_reset_instructions!
    end
  end

  describe "#deliver_new_email_instructions!" do

    let(:user) { create(:user, :new_email => 'foo@bar.com')}

    it "it resets perishable_token" do
      old_perishable_token = user.perishable_token
      user.send(:deliver_new_email_instructions!)

      expect(user.perishable_token).to_not eq old_perishable_token
    end

    it "send an email" do
      expect(UserMailer).to receive(:new_email_instructions)
                            .and_return(double("mailer", :deliver_later => true))

      user.send(:deliver_new_email_instructions!)
    end
  end

  describe "#owner?" do

    subject { user.owner? }

    context "with user not owner of the station" do

      it { should be_falsey }
    end

    context "with user owner of the station" do

      before(:each) do
        create(:station, :users => [user])
      end

      it { should be_truthy }
    end
  end
end
