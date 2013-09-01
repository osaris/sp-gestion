# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MessagesHelper do

  describe "class_tr_message" do

    context "with message read" do

      let(:message) { Message.make(:read) }

      it "render read" do
        class_tr_message(message).should == "read"
      end
    end

    context "with message unread" do

      let(:message) { Message.make }

      it "render unread" do
        class_tr_message(message).should == "unread"
      end
    end
  end
end
