# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Grade do

  describe "#new_defaults" do

    let(:grades) { Grade::new_defaults }

    it "initialize grades" do
      expect(grades.size).to eq Grade::GRADE.size
    end
  end
end
