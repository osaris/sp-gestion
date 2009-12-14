require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
    end
    
    context "requesting index" do
      setup do
        get :index
      end

      should_respond_with(:success)
      should_render_template("index")
      should_render_with_layout("back")
      
      should_assign_to(:messages)
    end
    
    context "requesting a non existing message" do
      setup do
        get :show, :id => 2458437589
      end
      
      should_respond_with(:redirect)
      should_redirect_to(":index") { messages_path }
    end    
    
    context "with a message" do
      setup do
        @message = @user.messages.make(:read => false)
      end
      
      context "requesting GET on existing message" do
        setup do
          get :show, :id => @message.id
        end
  
        should_respond_with(:success)
        should_render_template("show")
        should_render_with_layout("back")
      end
      
      context "requestion POST :mark_as_read on existing message" do
        setup do
          post :mark_as_read, :id => @message.id
        end
        
        should "mark message as read" do
          assert(assigns(:message).read)
        end
      end
    end
  end
end
