require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup(:activate_authlogic)

  context "with an instance unsaved" do
    setup do
      @user = User.make
    end

    should "not be valid?" do
      assert(@user.valid?)
    end
  end

  context "with an instance saved and not activated" do
    setup do
      @user = User.make!
    end

    should "not be confirmed?" do
      assert(!@user.confirmed?)
    end

    context "after a call to confirm! with good password" do
      setup do
        @user.confirm!('123456', '123456')
      end

      should "be confirmed" do
        assert(@user.reload.confirmed?)
      end
    end

    context "after a call to confirm! with bad password" do
      setup do
        @user.confirm!('123','')
      end

      should "not be confirmed" do
        assert_equal(false, @user.reload.confirmed?)
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

      should have_sent_email()
    end

    context "call deliver_cooptation_instructions!" do
      setup do
        @user.deliver_cooptation_instructions!
      end

      should "unconfirm user" do
        assert_equal(false, @user.confirmed?)
      end

      should have_sent_email()
    end


    context "call password_reset_instructions!" do
      setup do
        @user.deliver_password_reset_instructions!
      end

      should have_sent_email()
    end
  end

  context "with a confirmed user call boost_activation!" do
    setup do
      @u = User.make!(:confirmed)
      @result = @u.boost_activation
    end

    before_should "expect one mail is delivered" do
      dont_allow(UserMailer).boost_activation.with_any_args
    end

    should "return false" do
      assert_equal(false, @result)
    end

    should "not set last_boosted_at" do
      assert_nil(@u.last_boosted_at)
    end
  end

  context "with a not confirmed user call boost_activation!" do
    setup do
      @u = User.make!
      @result = @u.boost_activation
    end

    before_should "expect one mail is delivered" do
      mock.proxy(UserMailer).boost_activation.with_any_args
    end

    should "return true" do
      assert_equal(true, @result)
    end

    should "set last_boosted_at" do
      assert_not_nil(@u.last_boosted_at)
    end
  end
end
