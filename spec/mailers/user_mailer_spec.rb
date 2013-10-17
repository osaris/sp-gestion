require 'spec_helper'

describe UserMailer do

  let(:user) { User.make!(:email => "test@test.com", :new_email => "test@new.com") }

  describe "#confirmation_instructions" do

    subject { UserMailer.confirmation_instructions(user).deliver }

    it { should deliver_to('test@test.com') }
    it { should have_subject(/Activation/) }
    it { should have_body_text(/#{user.perishable_token}/) }
  end

  describe "#new_email_instructions" do
    subject { UserMailer.new_email_instructions(user).deliver }

    it { should deliver_to('test@new.com') }
    it { should have_subject(/Changement/) }
    it { should have_body_text(/#{user.perishable_token}/) }
  end

  context "#cooptation_instructions" do
    subject { UserMailer.cooptation_instructions(user).deliver }

    it { should deliver_to('test@test.com') }
    it { should have_subject(/Invitation/) }
    it { should have_body_text(/#{user.perishable_token}/) }
  end

  context "#password_reset_instructions" do
    subject { UserMailer.password_reset_instructions(user).deliver }

    it { should deliver_to('test@test.com') }
    it { should have_subject(/Modification/) }
    it { should have_body_text(/#{user.station.url}/) }
  end
end
