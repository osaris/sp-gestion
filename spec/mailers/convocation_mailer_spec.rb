# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ConvocationMailer do


  let(:convocation) { make_convocation_with_firemen(:date => 3.days.from_now,
                                                    :station => Station.make!,
                                                    :rem => 'Test') }

  describe "#sending_confirmation" do
    subject { ConvocationMailer.sending_confirmation(convocation, "test@test.com").deliver }


    it { should have_sent_email.to('test@test.com') \
                               .with_subject(/Confirmation/) \
                               .with_body { /#{convocation.title}/ } }
  end

  describe "#convocation" do

    let(:convocation_fireman) { convocation.convocation_firemen.first }

    subject { ConvocationMailer.convocation(convocation, convocation_fireman, "test@test.com").deliver }

    context "and not confirmable convocation" do
      it { should have_sent_email.from('pas_de_reponse@sp-gestion.fr') \
                                 .reply_to('test@test.com') \
                                 .to { convocation_fireman.fireman.email } \
                                 .with_body { /#{convocation.title}/ } }
    end

    let(:convocation) { make_convocation_with_firemen(:date => 3.days.from_now,
                                                      :station => Station.make!,
                                                      :rem => 'Test',
                                                      :confirmable => true) }

    context "and confirmable convocation" do
      it { should have_sent_email.from('pas_de_reponse@sp-gestion.fr') \
                                 .reply_to('test@test.com') \
                                 .to { convocation_fireman.fireman.email } \
                                 .with_body { /#{convocation.title}/ } \
                                 .with_body { /#{Digest::SHA1.hexdigest(convocation.id.to_s)}/ } \
                                 .with_body { /#{Digest::SHA1.hexdigest(convocation_fireman.id.to_s)}/ } }
    end
  end
end