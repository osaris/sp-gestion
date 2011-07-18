# -*- encoding : utf-8 -*-
require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  setup(:activate_authlogic)
    
  context "a station subdomain" do
    setup do
      @station = Station.make!(:url => 'cis-test')
      @request.host = 'cis-test.sp-gestion.fr'
    end

    context "requesting GET :new" do
      setup do
        get :new
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("login")
    end
    
    context "with a user on another account" do
      setup do
        @user = User.make!(:confirmed, :station => Station.make!)
      end
      
      context "requesting POST :create with good data" do
        setup do
          post :create, :user_session => {:email => @user.email, :password => 'test1234'}
        end

        should respond_with(:success)
        should render_template("new")
        should render_with_layout("login")

        should_not be_logged_in
        should set_the_flash.level(:error).now
      end      
    end

    context "with a user on this account" do
      setup do
        @user = User.make!(:confirmed, :station => @station)
      end

      context "requesting POST :create with bad data" do
        setup do
          post :create, :user => {:login => 'test', :password => 'pass'}
        end

        should respond_with(:success)
        should render_template("new")
        should render_with_layout("login")

        should_not be_logged_in
        should set_the_flash.level(:error).now
      end

      context "requesting POST :create with good data" do
        setup do
          post :create, :user_session => {:email => @user.email, :password => 'test1234'}
        end

        should respond_with(:redirect)
        should redirect_to("app root") { root_back_path }

        should be_logged_in
      end

      context "requesting DELETE :destroy not logged in" do
        setup do
          delete :destroy
        end

        should respond_with(:redirect)
        should redirect_to("login page") { login_path }

        should_not be_logged_in
      end

      context "requesting DELETE :destroy logged in" do
        setup do
          UserSession.create(@user)
          delete :destroy
        end

        should respond_with(:redirect)
        should redirect_to("login page") { login_path }

        should_not be_logged_in
        should set_the_flash.level(:success)
      end
    end
  end
end
