require File.dirname(__FILE__) + '/../test_helper'

class NewsletterTest < ActiveSupport::TestCase

  context "create an instance" do
    setup do
      @nl = Newsletter.create(:email => "test@test.com")
    end
    
    before_should "expect one mail is delivered" do
      NewsletterMailer.expects(:deliver_activation_instructions).once
    end    

    should "init activation_key" do
      assert_not_nil(@nl.activation_key)
    end    
  end
  
  context "with an instance" do
    setup do
      @nl = Newsletter.create(:email => "test@test.com")
    end
    
    context "validate!" do
      setup do
        @nl.activate!
      end

      should "clear activation_key" do
        assert_equal("", @nl.activation_key)
      end
      
      should "set activated_at" do
        assert_not_nil(@nl.activated_at)
      end
    end    
  end
  
  context "invite_to_beta with an instance already invited" do
    setup do
      @result = Newsletter.make(:invited).invite_to_beta
    end

    should "return false" do
      assert_equal(false, @result)
    end
  end
  
  context "invite_to_beta with an instance never activated" do
    setup do
      @nl = Newsletter.make(:inactive)
      @result = @nl.invite_to_beta
    end

    should "return false" do
      assert_equal(false, @result)
    end
    should "not set invited_at" do
      assert_nil(@nl.invited_at)
    end
  end
  
  context "invite_to_beta with an instance never invited and active" do
    setup do
      @nl = Newsletter.make(:active)
      @result = @nl.invite_to_beta
    end

    should "return true" do
      assert_equal(true, @result)
    end
    should_change("number of beta_codes") { BetaCode.count }
    should "set invited_at" do
      assert_not_nil(@nl.invited_at)
    end
  end
  
  context "boost_activation with an instance active" do
    setup do
      @nl = Newsletter.make(:active)
      @result = @nl.boost_activation
    end
    
    should "return false" do
      assert_equal(false, @result)
    end
    should "not set last_boosted_at" do
      assert_nil(@nl.last_boosted_at)
    end
  end
  
  context "boost_activation with an inactive instance" do
    setup do
      @nl = Newsletter.make(:inactive)
      @result = @nl.boost_activation
    end
    
    before_should "expect one mail is delivered" do
      NewsletterMailer.expects(:deliver_boost_activation).once
    end    

    should "return true" do
      assert_equal(true, @result)
    end
    should "set last_boosted_at" do
      assert_not_nil(@nl.last_boosted_at)
    end
  end
end
