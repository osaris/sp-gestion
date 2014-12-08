require 'rails_helper'

describe PlanningStatsService do

  let(:pss) { PlanningStatsService.new({Time.now         => 10,
                                        Time.now+1.hour  => 4,
                                        Time.now+2.hours => 11,
                                        Time.now+3.hours => 8,
                                        Time.now+4.hours => 3,
                                        Time.now+5.hours => 4}, 1) }

  describe "#periods_more_firemen" do

    subject { pss.periods_more_firemen[0][1] }

    it { should == 11 }
  end

  describe "#periods_less_firemen" do

    subject { pss.periods_less_firemen[0][1] }

    it { should == 3 }
  end

  describe "#periods_without_firemen" do

    subject { pss.periods_without_firemen }

    it { should == (7 * 24.0 - 6) }
  end

  describe "#occupation" do

    subject { pss.occupation }

    it { should == 23 }
  end

  describe "#firemen_periods_average" do

    subject { pss.firemen_periods_average }

    it { should == (40 / (7 * 24.0)) }
  end
end
