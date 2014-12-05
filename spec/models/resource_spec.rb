require 'rails_helper'

describe Resource do

  it { should have_many(:permissions) }
  it { should have_many(:groups) }
end
