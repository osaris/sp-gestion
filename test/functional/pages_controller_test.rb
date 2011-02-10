require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase

  context "requesting GET :home" do
    setup do
      get :home
    end

    should respond_with(:success)
    should render_template("home")
    should render_with_layout("front")
  end

end
