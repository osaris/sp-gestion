# -*- encoding : utf-8 -*-
require 'rails_helper'

describe ConvocationFireman do

  let(:fireman) { create(:fireman) }
  let(:convocation) { create(:convocation, :firemen => [fireman]) }

  it "set the convocation_firemen grade to firemen grade" do
    expect(convocation.convocation_firemen.first.grade).to eq fireman.grade
  end

  it "set the convocation_firemen status to firemen status" do
    expect(convocation.convocation_firemen.first.status).to eq fireman.status
  end
end
