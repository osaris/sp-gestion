require 'rails_helper'

describe Permission do

  it { should belong_to(:group) }
  it { should belong_to(:resource) }
end
