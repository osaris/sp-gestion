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
  

end
