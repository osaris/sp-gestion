# -*- encoding : utf-8 -*-
require 'rails_helper'

describe SendConvocationsJob do

  let(:convocation) { build(:convocation) }

  let(:job) { SendConvocationsJob.new }

  let(:user) { build(:user) }

  describe "#perform" do

    it "call send_emails on convocation" do
      expect(convocation).to receive(:send_emails)
                             .with(user.email)

      job.perform(convocation, user)
    end
  end
end
