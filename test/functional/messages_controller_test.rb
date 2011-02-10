require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
    end

    context "requesting GET :index" do
      setup do
        get :index
      end

      should respond_with(:success)
      should render_template("index")
      should render_with_layout("back")

      should assign_to(:messages)
    end

    context "requesting GET :show for a non existing message" do
      setup do
        get :show, :id => 2458437589
      end

      should respond_with(:redirect)
      should redirect_to(":index") { messages_path }

      should set_the_flash.level(:error)
    end

    context "with a message" do
      setup do
        @message = @user.messages.make!
      end

      context "requesting GET :show on existing message" do
        setup do
          get :show, :id => @message.id
        end

        should respond_with(:success)
        should render_template("show")
        should render_with_layout("back")
      end

      context "requestion POST :mark_as_read on existing message" do
        setup do
          xhr :post, :mark_as_read, :id => @message.id
        end

        should "mark message as read" do
          assert(assigns(:message).read?)
        end
      end
    end
  end
end
