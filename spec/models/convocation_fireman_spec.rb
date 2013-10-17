require 'spec_helper'

describe ConvocationFireman do

  let(:fireman) { make_fireman_with_grades(:station => Station.make!) }
  let(:convocation) { Convocation.make }

  before do
    convocation.firemen << fireman
    convocation.save
  end

  it "set the convocation_firemen grade to firemen grade" do
    convocation.convocation_firemen.first.grade.should == fireman.grade
  end

  it "set the convocation_firemen status to firemen status" do
    convocation.convocation_firemen.first.status.should == fireman.status
  end
end
