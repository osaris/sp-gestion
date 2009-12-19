require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  context "with an instance" do
    setup do
      @message = Message.new(:title => "test", :body => "test content", :user => User.make(:beta))
    end
    
    should "not be read" do
      assert(!@message.read?)
    end
    
    context "call mark_as_read" do
      setup do
        @message.mark_as_read
      end
      
      should "set read to true" do
        assert(@message.read)
      end
    end
    
    
  end

end
