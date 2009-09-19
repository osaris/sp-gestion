require File.dirname(__FILE__) + '/../test_helper'

class NewsletterMailerTest < ActionMailer::TestCase

  context "deliver activations instructions" do
    setup do
      @nl = Newsletter.make()
      NewsletterMailer.deliver_activation_instructions(@nl)
    end

    should "generate an email with good activation link" do
      assert_sent_email do |email|
        email.subject = "Disponibilité de SP-Gestion"
        email.body.include?(@nl.activation_key)
      end
    end
  end

end
