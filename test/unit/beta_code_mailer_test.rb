require 'test_helper'

class BetaCodeMailerTest < ActionMailer::TestCase
  
  context "with a beta_code" do
    setup do
      @bc = BetaCode.new(:code => "123456", :email => "test@test.com")
    end
    
    context "deliver welcome instructions" do
      setup do
        BetaCodeMailer.deliver_welcome_instructions(@bc)
      end

      should "send an email" do
        assert_sent_email do |email|
          email.to.include?("test@test.com") &&
          email.body.match(@bc.code)
        end      
      end
    end
    
    context "deliver boost activation" do
      setup do
        BetaCodeMailer.deliver_boost_activation(@bc)
      end

      should "send an email" do
        assert_sent_email do |email|
          email.to.include?("test@test.com") &&
          email.body.match(@bc.code)
        end      
      end
    end
  end
end
