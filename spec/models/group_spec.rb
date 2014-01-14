# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Group do

  it { should belong_to(:station) }
  it { should have_many(:users) }
  it { should have_many(:permissions) }
  it { should have_many(:resources) }

  it { should validate_presence_of(:name).with_message(/nom/) }
end
