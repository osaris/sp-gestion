require 'rails_helper'

describe DestroyStationJob do

  let(:station) { build(:station) }

  let(:job) { DestroyStationJob.new }

  describe "#perform" do

    it "call destroy on station" do
      expect(station).to receive(:destroy)

      job.perform(station)
    end
  end
end
