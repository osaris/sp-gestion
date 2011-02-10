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

      should respond_with(:success)
      should render_template("index")
      should render_with_layout("back")

      should assign_to(:messages)
      should assign_to(:interventions)
      should assign_to(:convocations)
      should assign_to(:items)
    end
  end

end
