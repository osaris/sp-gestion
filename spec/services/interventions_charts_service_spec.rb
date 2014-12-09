require 'rails_helper'

describe InterventionsChartsService do

  let(:ics) { InterventionsChartsService.new([], 0) }

  describe "#by_city" do

    subject { ics.by_city }

    it { expect(subject.options[:title][:text]).to match(/ville/) }
    it { expect(subject.series_data.size).to eq 1 }
  end

  describe "#by_vehicle" do

    subject { ics.by_vehicle }

    it { expect(subject.options[:title][:text]).to match(/véhicule/) }
    it { expect(subject.series_data.size).to eq 1 }
  end

  describe "#by_hour" do

    subject { ics.by_hour }

    it { expect(subject.options[:title][:text]).to match(/heure/) }
    it { expect(subject.series_data.size).to eq 1 }
  end

  describe "#by_month" do

    subject { ics.by_month }

    it { expect(subject.options[:title][:text]).to match(/mois/) }
    it { expect(subject.series_data.size).to eq 1 }
  end

  describe "#by_subkind" do

    subject { ics.by_subkind }

    it { expect(subject.options[:title][:text]).to match(/sous-type/) }
    it { expect(subject.series_data.size).to eq 1 }
  end

  describe "#by_type" do

    subject { ics.by_type }

    it { expect(subject.options[:title][:text]).to match(/type/) }
    it { expect(subject.series_data.size).to eq 1 }
  end
end
