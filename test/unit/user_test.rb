require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup(:activate_authlogic)

  context "with an instance not activated" do
    setup do
      @user = User.make(:email => 'test@test.com')
    end
    
    context "call confirmed?" do
      setup do
        @result = @user.confirmed?
      end

      should "return false" do
        assert_equal(false, @result)
      end
    end
    
    context "after a call to confirm!" do
      setup do
        @user.confirm!
      end

      should "be confirmed" do
        assert(@user.confirmed?)
      end
    end

    context "call reset_password! with bad data" do
      setup do
        @result = @user.reset_password!('test', 'test')
      end
      
      should "return false" do
        assert_equal(false, @result)
      end
    end

    context "call reset_password! with good data" do
      setup do
        @result = @user.reset_password!('test3467', 'test3467')
      end

      should "return true" do
        assert(@result)
      end
    end

    context "call deliver_confirmation_instructions!" do
      setup do
        @user.deliver_confirmation_instructions!
      end

      should "unconfirm user" do
        assert_equal(false, @user.confirmed?)
      end

      should "send an email" do
        assert_sent_email()
      end
    end
    
    context "call password_reset_instructions!" do
      setup do
        @user.deliver_password_reset_instructions!
      end

      should "send an email" do
        assert_sent_email()
      end
    end
    
  end
end
