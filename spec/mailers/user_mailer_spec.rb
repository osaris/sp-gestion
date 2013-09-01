# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserMailer do

  let(:user) { User.make!(:email => "test@test.com", :new_email => "test@new.com") }

  describe "#confirmation_instructions" do

    subject { UserMailer.confirmation_instructions(user).deliver }

    it { should have_sent_email.to('test@test.com') \
                               .with_subject(/Activation/) \
                              .with_body { /#{user.perishable_token}/ } }
  end

  describe "#new_email_instructions" do
    subject { UserMailer.new_email_instructions(user).deliver }

    it { should have_sent_email.to('test@new.com') \
                               .with_subject(/Changement/) \
                               .with_body { /#{user.perishable_token}/ } }
  end

  context "#cooptation_instructions" do
    subject { UserMailer.cooptation_instructions(user).deliver }

    it { should have_sent_email.to('test@test.com') \
                               .with_subject(/Invitation/) \
                               .with_body { /#{user.perishable_token}/ } }
  end

  context "#password_reset_instructions" do
    subject { UserMailer.password_reset_instructions(user).deliver }

    it { should have_sent_email.to('test@test.com') \
                               .with_subject(/Modification/) \
                               .with_body { /#{user.station.url}/ } }
  end
end
