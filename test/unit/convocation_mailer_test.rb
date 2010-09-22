require 'test_helper'

class ConvocationMailerTest < ActionMailer::TestCase

  context "with a convocation" do
    setup do
      @convocation = make_convocation_with_firemen(:date => 3.days.from_now,
                                                   :station => Station.make)
    end

    context "deliver sending_confirmation" do
      setup do
        ConvocationMailer.deliver_sending_confirmation(@convocation, "test@test.com")
      end

      should "send an email" do
        assert_sent_email do |email|
          email.to.include?("test@test.com") &&
          email.body.match(@convocation.title)
        end
      end
    end

    context "deliver convocation" do
      setup do
        @convocation_fireman = @convocation.convocation_firemen.first
        ConvocationMailer.deliver_convocation(@convocation, @convocation_fireman, "test@test.com")
      end

      should "send an email" do
        assert_sent_email do |email|
          email.from.include?("pas_de_reponse@sp-gestion.fr") &&
          email.reply_to.include?("test@test.com") &&
          email.to.include?(@convocation_fireman.fireman.email) &&
          email.body.match(@convocation.title)
        end
      end
    end

  end

end
