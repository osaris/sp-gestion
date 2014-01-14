# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Resource do

  it { should have_many(:permissions) }
  it { should have_many(:groups) }
end