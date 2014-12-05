require 'rails_helper'

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

  describe "#context_login_navigation" do

    subject { context_login_navigation(controller_name) }

    context "with confirmations controller" do

      let(:controller_name) { 'confirmations' }

      it { should == 'confirmation'}
    end

    context "with email confirmations controller" do

      let(:controller_name) { 'email_confirmations' }

      it { should == 'email_confirmation'}
    end

    context "with any controller" do

      let(:controller_name) { 'foo' }

      it { should == 'login'}
    end
  end

  describe "#l!" do

    subject { l!(object) }


    context "with something localizable" do

      let(:object) { Date.today }

      it { should_not == '' }
    end

    context "with something not localizable" do

      let(:object) { nil }

      it { should == '' }
    end
  end

  describe "#error_message_on" do

    subject { error_message_on(object, method) }

    let(:method) { 'name' }

    before(:each) do
      object.valid?
    end

    context "with invalid object" do

      let(:object) { build(:vehicle, :name => '') }

      it { should match(/formError/) }
    end

    context "with valid object" do

      let(:object) { build(:vehicle) }

      it { should == "" }
    end
  end

  describe "#icon_label_text" do

    subject { icon_label_text('name', 'label') }

    it { should == "<i class=\"name\"></i>&nbsp;label" }
  end

  describe "#display_tags" do

    subject { display_tags('foo,bar') }

    it { should == "<span class=\"label label-info\">foo</span>&nbsp;<span class=\"label label-info\">bar</span>&nbsp;" }
  end
end
