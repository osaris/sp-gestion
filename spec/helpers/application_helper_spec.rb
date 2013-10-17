require 'spec_helper'

describe ApplicationHelper do

  describe "#flash_helper" do

    subject { flash_helper() }

    before(:each) do
      flash[:warning] = 'foo'
    end

    it { should == "<p class=\"alert alert-warning\">foo</p>" }
  end

  describe "#img_grade" do

    subject { img_grade(Grade::GRADE['Colonel']) }

    it { should == "<img alt=\"Colonel\" class=\"grade\" src=\"/images/back/grades/14.png\" />" }
  end

  describe "#icon_label_text" do

    subject { icon_label_text('name', 'label') }

    it { should == "<i class=\"name\"></i>&nbsp;label" }
  end

  describe "#display_tags" do

    subject { display_tags('foo,bar') }

    it { should == "<span class=\"label\">foo</span>&nbsp;<span class=\"label\">bar</span>&nbsp;" }
  end
end
