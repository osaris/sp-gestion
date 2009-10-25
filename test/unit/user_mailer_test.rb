require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  context "with a user" do
    setup do
      @user = User.make(:email => "test@test.com")
    end
    
    context "deliver confirmation instructions" do
      setup do
        UserMailer.deliver_confirmation_instructions(@user)
      end

      should "send an email" do
        assert_sent_email do |email|
          email.to.include?("test@test.com") &&
          email.body.match(@user.perishable_token)
        end      
      end
    end

    context "deliver password reset instructions" do
      setup do
        UserMailer.deliver_password_reset_instructions(@user)
      end

      should "send an email" do
        assert_sent_email do |email|
          email.to.include?("test@test.com") &&
          email.body.match(@user.station.url)
        end      
      end
    end    
    
  end
  
end
