require 'rails_helper'

describe FiremenChartsService do

  let(:fss) { FiremenChartsService.new({:sum  => 12,
                                       :data => ['foo' => 6, 'bar' => 6]}) }

  describe "#interventions_by_role" do

    subject { fss.interventions_by_role }

    it { expect(subject.options[:title][:text]).to match(/Interventions par rôle/) }
    it { expect(subject.series_data.size).to eq 1 }
  end

  describe "#interventions_by_hour" do

    subject { fss.interventions_by_hour }

    it { expect(subject.options[:title][:text]).to match(/Interventions par heure/) }
    it { expect(subject.series_data.size).to eq 1 }
  end
end
