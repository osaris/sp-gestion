# -*- encoding : utf-8 -*-
require 'test_helper'

class MessagesHelperTest < ActionView::TestCase
  
  context "class_tr_message with message read" do
    setup do
      @class_tr_message = class_tr_message(Message.new(:read_at => Time.now))
    end

    should "render read" do
      assert_equal("read", @class_tr_message)
    end
  end
  
  context "class_tr_message with message unread" do
    setup do
      @class_tr_message = class_tr_message(Message.new(:read_at => nil))
    end

    should "render unread" do
      assert_equal("unread", @class_tr_message)
    end
  end
  
end
