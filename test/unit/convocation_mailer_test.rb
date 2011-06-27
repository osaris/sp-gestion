# -*- encoding : utf-8 -*-
require 'test_helper'

class ConvocationMailerTest < ActionMailer::TestCase

  context "with a convocation" do
    setup do
      @convocation = make_convocation_with_firemen(:date => 3.days.from_now,
                                                   :station => Station.make!,
                                                   :rem => 'Test')
      debugger
    end

    context "deliver sending_confirmation" do
      setup do
        ConvocationMailer.sending_confirmation(@convocation, "test@test.com").deliver
      end

      # TODO fix when https://github.com/thoughtbot/shoulda/issues/128 is fixed
      # should have_sent_email.to('test@test.com') \
      #                       .with_body(@convocation.title)
    end

    context "deliver convocation" do
      setup do
        @convocation_fireman = @convocation.convocation_firemen.first
        ConvocationMailer.convocation(@convocation, @convocation_fireman, "test@test.com").deliver
      end

      # TODO fix when https://github.com/thoughtbot/shoulda/issues/128 is fixed
      # should have_sent_email.from('pas_de_reponse@sp-gestion.fr') \
      #                       # .reply_to('test@test.com') \
      #                       .to(@convocation_fireman.fireman.email) \
      #                       .with_body(@convocation.title) \
      #                       .with_body(Digest::SHA1.hexdigest(@convocation.id.to_s)) \
      #                       .with_body(Digest::SHA1.hexdigest(@convocation_fireman.id.to_s))
    end

    # TODO write a test for confirmable?
  end
end