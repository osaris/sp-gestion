# -*- encoding : utf-8 -*-
require 'test_helper'

class ConfirmationsControllerTest < ActionController::TestCase

  context "a station subdomain" do
    setup do
      @station = Station.make!(:url => 'cis-test')
      @request.host = 'cis-test.sp-gestion.fr'
    end

    context "with an active user on this subdomain" do
      setup do
        @user = User.make!(:confirmed, :station => @station)
      end

      context "requesting GET :edit with good confirmation code" do
        setup do
          get :edit, :id => @user.perishable_token
        end

        should respond_with(:redirect)
        should redirect_to("login form") { login_path }
        should set_the_flash.level(:error)
      end
    end

    context "with an inactive user on this subdomain" do
      setup do
        @user = User.make!(:station => @station)
      end

      context "requesting GET :edit with good confirmation code" do
        setup do
          get :edit, :id => @user.perishable_token
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("login")
      end

      context "requesting POST :update with bad password" do
        setup do
          post :update, :id => @user.perishable_token, :user => {:password => '123',
                                                                 :password_confirmation => ''}
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("login")
      end

      context "requesting POST :update with good password" do
        setup do
          post :update, :id => @user.perishable_token, :user => {:password => '123456',
                                                                 :password_confirmation => '123456'}
        end

        should respond_with(:redirect)
        should redirect_to("back root") { root_back_path }
        should "be active" do
          assert(assigns(:user).confirmed?)
        end
        should be_logged_in
      end
    end
  end
end
