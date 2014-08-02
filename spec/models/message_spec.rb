# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Message do

  it { should belong_to(:user) }

  let(:message) { Message.new(:title => "test", :body => "test content", :user => User.make!) }

  describe "#read?" do

    subject { message.read? }

    context "and message not read" do

      it { should be_falsey }
    end

    context "and message read" do

      before { message.read! }

      it { should be_truthy }
    end
  end

  describe "#read_at" do

    subject { message.read_at }

    context "and message not read" do

      it { should be_nil }
    end

    context "and message read" do

      before { message.read! }

      it { should_not be_nil }
    end
  end
end
