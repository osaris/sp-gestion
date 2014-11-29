# -*- encoding : utf-8 -*-
require 'rails_helper'

describe CreateDefaultsUniformJob do

  let(:station) { build(:station) }

  let(:job) { CreateDefaultsUniformJob.new }

  describe "#perform" do

    it "call destroy on station" do
      expect(Uniform).to receive(:create_defaults)
                         .with(station)

      job.perform(station)
    end
  end
end
