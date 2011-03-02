# -*- encoding : utf-8 -*-
require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  context "with an instance" do
    setup do
      @message = Message.new(:title => "test", :body => "test content", :user => User.make!)
    end

    should "not be read" do
      assert(!@message.read?)
    end

    context "call read!" do
      setup do
        @message.read!
      end

      should "set read_at" do
        assert_not_nil(@message.read_at)
      end

      should "do read? return true" do
        assert(@message.read?)
      end
    end
  end
end
