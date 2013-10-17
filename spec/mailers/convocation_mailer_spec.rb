# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ConvocationMailer do

  let(:station) { Station.make! }

  let(:convocation) { make_convocation_with_firemen(:date => 3.days.from_now,
                                                    :station => station,
                                                    :rem => 'Test') }

  describe "#sending_confirmation" do
    subject { ConvocationMailer.sending_confirmation(convocation, "test@test.com").deliver }


    it { should deliver_to('test@test.com') }
    it { should have_subject(/Confirmation/) }
    it { should have_body_text(/#{convocation.title}/) }
  end

  describe "#convocation" do

    let(:convocation_fireman) { convocation.convocation_firemen.first }

    subject { ConvocationMailer.convocation(convocation, convocation_fireman, "test@test.com").deliver }

    context "and not confirmable convocation" do

      it { should deliver_from("#{station.name} <pas_de_reponse@sp-gestion.fr>") }
      it { should reply_to('test@test.com') }
      it { should deliver_to(convocation_fireman.fireman.email) }
      it { should have_body_text(/#{convocation.title}/) }
    end

    let(:convocation) { make_convocation_with_firemen(:date => 3.days.from_now,
                                                      :station => station,
                                                      :rem => 'Test',
                                                      :confirmable => true) }

    context "and confirmable convocation" do

      it { should deliver_from("#{station.name} <pas_de_reponse@sp-gestion.fr>") }
      it { should reply_to('test@test.com') }
      it { should deliver_to(convocation_fireman.fireman.email) }
      it { should have_body_text(/#{convocation.title}/) }
      it { should have_body_text(/#{Digest::SHA1.hexdigest(convocation.id.to_s)}/) }
      it { should have_body_text(/#{Digest::SHA1.hexdigest(convocation_fireman.id.to_s)}/) }
    end
  end
end