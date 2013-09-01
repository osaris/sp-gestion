# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Grade do

  describe "#new_defaults" do

    let(:grades) { Grade::new_defaults }

    it "initialize grades" do
      grades.size.should == Grade::GRADE.size
    end
  end
end
