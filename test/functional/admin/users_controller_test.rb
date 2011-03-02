# -*- encoding : utf-8 -*-
require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase

  context "an user logged in and HTTP_REFERER set" do
    setup do
      @request.session[:typus_user_id] = TypusUser.make!.id
      @request.env["HTTP_REFERER"] = "/admin"
    end

    context "requesting GET :boost_activation which send boost" do
      setup do
        stub.instance_of(User).boost_activation { true }
        get :boost_activation, :id => User.make!.id
      end

      should respond_with(:redirect)
      should redirect_to("users list") { "/admin/users" }

      should set_the_flash.level(:success)
    end

    context "requesting GET :boost_activation which fail" do
      setup do
        stub.instance_of(User).boost_activation { false }
        get :boost_activation, :id => User.make!.id
      end

      should respond_with(:redirect)
      should redirect_to("back") { "/admin" }

      should set_the_flash.level(:error)
    end
  end
end
