require 'test_helper'

class StationTest < ActiveSupport::TestCase
  
  context "with an instance and last_grade_update_at blank" do
    setup do
      @station = Station.make(:last_grade_update_at => nil)
    end
    
    should "not confirm last_grade_update_at" do
      assert_equal(false, @station.confirm_last_grade_update_at?(Date.today))
    end
  end
  
  context "with an instance and last_grade_update_at but no intervention" do
    setup do
      @station = Station.make(:last_grade_update_at => Date.today)
    end
  
    should "not confirm last_grade_update_at" do
      assert_equal(false, @station.confirm_last_grade_update_at?(Date.today))
    end
  end
  
  context "with an instance and last_grade_update_at and interventions but date before last_grade_update_at" do
    setup do
      @station = Station.make(:last_grade_update_at => Date.today)
      # because there is no stub_chain for any_instance in mocha
      Station.any_instance.stubs(:interventions).returns(mock(:empty? => false))
    end
  
    should "not confirm last_grade_update_at" do
      assert_equal(false, @station.confirm_last_grade_update_at?(3.days.ago))
    end
  end
  
  context "with an instance and a user, save" do
    setup do
      @user = User.new
      @station = Station.create(:users => [@user])
    end
    
    should "set owner_id to user" do
      assert_equal(@station.owner_id, @user.id)
    end
  end
end