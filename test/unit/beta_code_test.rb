require 'test_helper'

class BetaCodeTest < ActiveSupport::TestCase

  context "with an instance" do
    setup do
      @bc = BetaCode.new
    end

    should "initialize used to false" do
      assert_equal(false, @bc.used)
    end
    
    context "saved" do
      setup do
        @bc.save
      end
      
      before_should "expect one mail is delivered" do
        BetaCodeMailer.expects(:deliver_welcome_instructions).once
      end      
      
      should "have a code" do
        assert_not_nil(@bc.code)
      end
    end
  end
end
