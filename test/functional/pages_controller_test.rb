require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase

  context "requesting GET :home" do
    setup do
      get :home
    end

    should_respond_with(:success)
    should_render_template("home")
    should_render_with_layout("front")
  end

end
