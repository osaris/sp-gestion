# -*- encoding : utf-8 -*-
require 'test_helper'

class EmailConfirmationsControllerTest < ActionController::TestCase

  context "a station subdomain with a user who asked for an email change" do
    setup do
      @station = Station.make!
      @user = User.make!(:confirmed, :station => @station, :new_email => 'new_email@test.com')
      @request.host = "#{@station.url}.test.local"
    end

    context "requesting GET :edit" do
      setup do
        get :edit, :id => @user.perishable_token
      end

      should respond_with(:success)
      should render_template("edit")
      should render_with_layout("login")
    end

    context "requesting PUT :update with bad password" do
      setup do
        put :update, :id => @user.perishable_token, :user_session => { :email => @user.email, :new_email => @user.new_email, :password => '' }
      end

      should respond_with(:success)
      should render_template("edit")
      should render_with_layout("login")

      should set_the_flash.level(:error).now
    end

    context "requesting PUT :update with good password" do
      setup do
        put :update, :id => @user.perishable_token, :user_session => { :email => @user.email, :new_email => @user.new_email, :password => 'test1234' }
      end

      should respond_with(:redirect)
      should redirect_to("profile") { profile_path }

      should set_the_flash.level(:success)
    end

    context "requesting PUT :update with good password but new_email already used" do
      setup do
        @user.new_email = User.make!(:confirmed, :station => @station).email
        @user.save
        put :update, :id => @user.perishable_token, :user_session => { :email => @user.email, :new_email => @user.new_email, :password => 'test1234' }
      end

      should respond_with(:redirect)
      should redirect_to("login form") { login_path }

      should set_the_flash.level(:error).now
    end
  end

  context "a station subdomain with a user who never asked for an email change" do
    setup do
      @station = Station.make!
      @user = User.make!(:confirmed, :station => @station, :new_email => '')
      @request.host = "#{@station.url}.test.local"
    end

    context "requesting GET :edit" do
      setup do
        get :edit, :id => @user.perishable_token
      end

      should respond_with(:redirect)
      should redirect_to("login form") { login_path }
    end
  end
end
