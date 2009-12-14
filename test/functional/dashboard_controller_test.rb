require 'test_helper'

class DashboardControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
    end

    context "requesting GET :index" do
      setup do
        get :index
      end
      
      should_respond_with(:success)
      should_render_template("index")
      should_render_with_layout("back")
      
      should_assign_to(:messages)
    end
  end

end
