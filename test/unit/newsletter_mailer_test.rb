require File.dirname(__FILE__) + '/../test_helper'

class NewsletterMailerTest < ActionMailer::TestCase

  context "with a newsletter" do
    setup do
      @nl = Newsletter.make()      
    end

    context "deliver activations instructions" do
      setup do
        NewsletterMailer.deliver_activation_instructions(@nl)
      end

      should "generate an email with good activation link" do
        assert_sent_email do |email|
          email.subject = "Disponibilité de SP-Gestion"
          email.body.include?(@nl.activation_key)
          email.body.include?("www.#{BASE_URL}")
        end
      end
    end
    
    context "deliver boost activation" do
      setup do
        NewsletterMailer.deliver_boost_activation(@nl)
      end

      should "generate an email with good activation link" do
        assert_sent_email do |email|
          email.subject = "Disponibilité de SP-Gestion"
          email.body.include?(@nl.activation_key)
          email.body.include?("www.#{BASE_URL}")
        end
      end
    end
  end
end
