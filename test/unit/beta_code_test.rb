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
  
  context "boost_activation with an instance linked to a user" do
    setup do
      @bc = BetaCode.make()
      @bc.stubs(:user_id).returns(10)
      @result = @bc.boost_activation
    end
    
    should "return false" do
      assert_equal(false, @result)
    end
    should "not set last_boosted_at" do
      assert_nil(@bc.last_boosted_at)
    end
  end
  
  context "boost_activation with an instance not linked to a user" do
    setup do
      @bc = BetaCode.make()
      @result = @bc.boost_activation
    end

    before_should "expect one mail is delivered" do
      BetaCodeMailer.expects(:deliver_boost_activation).once
    end

    should "return true" do
      assert_equal(true, @result)
    end
    should "set last_boosted_at" do
      assert_not_nil(@bc.last_boosted_at)
    end
  end
end
