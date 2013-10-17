# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CheckList do

  it { should belong_to(:station) }

  it { should validate_presence_of(:title).with_message(/titre/) }

  describe "#copy" do

    let(:cl) { make_check_list_with_items() }
    let(:cl_copy) { cl.copy }

    it "returns a copy with different title" do
      cl_copy.title.should match(cl.title)
    end

    it "returns a copy having same number of items" do
      cl_copy.items.size.should == cl.items.size
    end
  end

  describe "#places" do

    let(:cl) { CheckList.make!(:items => [Item.make!(:place => 'foo'),
                                         Item.make!(:place => 'foo'),
                                         Item.make!(:place => 'bar')]) }

    it "returns distinct list of places of items ordered by name" do
      cl.places.should == ['bar', 'foo']
    end
  end
end
