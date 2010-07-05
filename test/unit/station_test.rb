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

  context "with an instance which has never sent email" do
    setup do
      @station = Station.make()
    end

    should "let send less than NB_EMAIL_PER_HOUR" do
      assert(@station.can_send_email?(NB_EMAIL_PER_HOUR-1))
    end

    should "let send NB_EMAIL_PER_HOUR" do
      assert(@station.can_send_email?(NB_EMAIL_PER_HOUR))
    end

    should "should not let send more than NB_EMAIL_PER_HOUR" do
      assert_equal(false, @station.can_send_email?(NB_EMAIL_PER_HOUR+1))
    end
  end

  context "with an instance which has sent emails 3 hours ago and call to reset_email_limitation" do
    setup do
      @station = Station.make(:last_email_sent_at => 3.hours.ago, :nb_email_sent => 10)
      @station.reset_email_limitation
    end

    should "reset nb_email_sent" do
      assert_equal(0, @station.reload.nb_email_sent)
    end
  end

  context "with an instance which has sent emails 15 minutes ago and call to reset_email_limitation" do
    setup do
      @station = Station.make(:last_email_sent_at => 15.minutes.ago, :nb_email_sent => 10)
      @station.reset_email_limitation
    end

    should "not reset nb_email_sent" do
      assert_equal(10, @station.reload.nb_email_sent)
    end
  end
end