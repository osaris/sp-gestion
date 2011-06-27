# -*- encoding : utf-8 -*-
require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  context "with a user" do
    setup do
      @user = User.make!(:email => "test@test.com", :new_email => "test@new.com")
    end

    context "deliver confirmation instructions" do
      setup do
        UserMailer.confirmation_instructions(@user).deliver
      end

      # TODO fix when https://github.com/thoughtbot/shoulda/issues/128 is fixed
      # should  have_sent_email.to('test@test.com') \
      #                        .with_body(@user.perishable_token)
    end

    context "deliver new email instructions" do
      setup do
        UserMailer.new_email_instructions(@user).deliver
      end

      # TODO fix when https://github.com/thoughtbot/shoulda/issues/128 is fixed
      # should  have_sent_email.to('test@new.com') \
      #                        .with_body(@user.perishable_token)
    end

    context "deliver cooptation instructions" do
      setup do
       UserMailer.cooptation_instructions(@user).deliver
      end

      # TODO fix when https://github.com/thoughtbot/shoulda/issues/128 is fixed
      # should have_sent_email.to('test@test.com') \
      #                       .with_body(@user.perishable_token)
    end

    context "deliver password reset instructions" do
      setup do
        UserMailer.password_reset_instructions(@user).deliver
      end

      # TODO fix when https://github.com/thoughtbot/shoulda/issues/128 is fixed
      # should have_sent_email.to('test@test.com') \
      #                       .with_body(@user.station.url)
    end

    context "deliver boost activation" do
      setup do
        UserMailer.boost_activation(@user).deliver
      end

      # TODO fix when https://github.com/thoughtbot/shoulda/issues/128 is fixed
      # should have_sent_email.to('test@test.com') \
      #                       .with_body(@user.perishable_token)
    end
  end
end
