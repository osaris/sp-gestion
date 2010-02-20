require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup(:activate_authlogic)

  context "with an instance unsaved" do
    setup do
      @user = User.make_unsaved(:beta_code => '')
    end
        
    should "not be valid?" do
      assert(@user.valid?)
    end
    
    context "with valid beta code" do
      setup do
        @bc = BetaCode.make
        @user.beta_code = @bc.code
      end
      
      should "be valid" do
        assert(@user.valid?)
      end
      
      context "saving" do
        setup do
          @user.save
        end

        should "set user_id to BetaCode" do
          assert_equal(@user.id, @bc.reload.user_id)
        end
      end
    end
  end

  context "with an instance saved and not activated" do
    setup do
      @user = User.make(:beta)
    end
        
    should "not be confirmed?" do
      assert(!@user.confirmed?)
    end
    
    context "after a call to confirm!" do
      setup do
        @user.confirm!
      end

      should "be confirmed" do
        assert(@user.confirmed?)
      end
      
      should "set BetaCode to used" do
        assert(@user.beta_codes.first.used)
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
  
  context "boost_activation on a confirmed instance" do
    setup do
      @u = User.make(:confirmed)
      @result = @u.boost_activation
    end
    
    should "return false" do
      assert_equal(false, @result)
    end
    should "not set last_boosted_at" do
      assert_nil(@u.last_boosted_at)
    end
  end
  
  context "boost_activation on a non confirmed instance" do
    setup do
      @u = User.make(:beta)
      @result = @u.boost_activation
    end
    
    before_should "expect one mail is delivered" do
      UserMailer.expects(:deliver_boost_activation).once
    end
    
    should "return true" do
      assert_equal(true, @result)
    end
    should "set last_boosted_at" do
      assert_not_nil(@u.last_boosted_at)
    end
  end
end
