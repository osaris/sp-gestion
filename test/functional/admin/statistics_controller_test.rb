# -*- encoding : utf-8 -*-
require 'test_helper'

# ControllerTest generated by Typus, use it to test the extended admin functionality.
class Admin::StatisticsControllerTest < ActionController::TestCase

  context "an user logged in" do
    setup do
      @request.session[:typus_user_id] = TypusUser.make!.id
    end

    context "requesting GET :index" do
      setup do
        get :index
      end

      should respond_with(:success)
      should render_template("index")
    end
  end
end
