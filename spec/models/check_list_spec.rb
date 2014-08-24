# -*- encoding : utf-8 -*-
require 'rails_helper'

describe CheckList do

  it { should belong_to(:station) }

  it { should validate_presence_of(:title).with_message(/titre/) }

  describe "#copy" do

    let(:cl) { create(:check_list_with_items) }
    let(:cl_copy) { cl.copy }

    it "returns a copy with different title" do
      expect(cl_copy.title).to match(cl.title)
    end

    it "returns a copy having same number of items" do
      expect(cl_copy.items.size).to eq cl.items.size
    end
  end

  describe "#places" do

    let(:cl) { create(:check_list, :items => [create(:item, :place => 'foo'),
                                              create(:item, :place => 'foo'),
                                              create(:item, :place => 'bar')]) }

    it "returns distinct list of places of items ordered by name" do
      expect(cl.places).to eq ['bar', 'foo']
    end
  end
end
