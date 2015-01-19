require 'rails_helper'

describe FiremenChartsService do

  let(:fss) { FiremenChartsService.new({:sum  => 12,
                                       :data => ['foo' => 6, 'bar' => 6]}) }

  describe "#interventions" do

    subject { fss.interventions }

    it { expect(subject.options[:title][:text]).to match(/Interventions/) }
    it { expect(subject.series_data.size).to eq 1 }
  end
end
