require 'test_helper'

class ConvocationTest < ActiveSupport::TestCase

  should_validate_presence_of(:title, :message => /titre/)
  should_validate_presence_of(:date, :message => /date/)
  should_validate_presence_of(:uniform, :message => /tenue/)
  should_validate_presence_of(:firemen, :message => /personnes/)

  context "with an instance" do
    setup do
      @convocation = make_convocation_with_firemen(:date => 3.days.from_now,
                                                   :station => Station.make)
    end

    should "be valid" do
      assert(@convocation.valid?)
    end

    should "be editable" do
      assert(@convocation.editable?)
    end

    context "and date in past" do
      setup do
        @convocation.date = 3.weeks.ago
      end

      should "not be valid" do
        assert_equal(false, @convocation.valid?)
      end

      should "not be editable" do
        assert_equal(false, @convocation.editable?)
      end
    end
  end

  context "with an instance with 3 firemen (3 emails) and a call to send_emails" do
    setup do
      @convocation = make_convocation_with_firemen({:date => 3.days.from_now,
                                                   :station => Station.make}, 3)
      @convocation.send_emails("test@test.com")
    end

    before_should "expect convocations are delivered" do
      ConvocationMailer.expects(:deliver_convocation).times(3)
    end

    before_should "expect one sending confirmation is delivered" do
      ConvocationMailer.expects(:deliver_sending_confirmation).once
    end

    should "set nb_email_sent" do
      assert_equal(3, @convocation.station.reload.nb_email_sent)
    end
  end

  context "with an instance and 3 firemen (2 emails) and a call to send_emails" do
    setup do
      @convocation = make_convocation_with_firemen({:date => 3.days.from_now,
                                                   :station => Station.make}, 3)
      @convocation.firemen.first.update_attribute(:email, '')
      @convocation.send_emails("test@test.com")
    end

    before_should "expect convocations are delivered" do
      ConvocationMailer.expects(:deliver_convocation).times(2)
    end

    should "set nb_email_sent" do
      assert_equal(2, @convocation.station.reload.nb_email_sent)
    end
  end

end
