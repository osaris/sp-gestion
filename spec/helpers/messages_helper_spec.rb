# -*- encoding : utf-8 -*-
require 'rails_helper'

describe MessagesHelper do

  describe "class_tr_message" do

    context "with message read" do

      let(:message) { create(:message_read) }

      it "render read" do
        expect(class_tr_message(message)).to eq "read"
      end
    end

    context "with message unread" do

      let(:message) { create(:message) }

      it "render unread" do
        expect(class_tr_message(message)).to eq "unread"
      end
    end
  end
end
