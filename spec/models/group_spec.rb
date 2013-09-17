# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Group do

  it { should belong_to(:station) }

  it { should validate_presence_of(:name).with_message(/nom/) }

end
