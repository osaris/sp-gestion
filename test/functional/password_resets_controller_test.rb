require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase

  context "a station subdomain with a user" do
    setup do
      @station = Station.make!
      @user = User.make!(:confirmed, :station => @station)
      @request.host = "#{@station.url}.test.local"
    end

    context "requesting GET :new" do
      setup do
        get :new
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("login")
    end

    context "requesting POST :create with bad data" do
      setup do
        post :create, :email => 'test@test.com'
      end

      before_should "expect no mail is delivered" do
        dont_allow(UserMailer).password_reset_instructions.with_any_args
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("login")

      should set_the_flash.level(:error).now
    end

    context "requesting POST :create with good data" do
      setup do
        post :create, :email => @user.email
      end

      before_should "expect one mail is delivered" do
        mock.proxy(UserMailer).password_reset_instructions.with_any_args
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("login")

      should set_the_flash.level(:warning).now
    end

    context "requesting GET :edit with bad data" do
      setup do
        get :edit, :id => -1
      end

      should respond_with(:redirect)
      should redirect_to("login page") { login_path }

      should set_the_flash.level(:error)
    end

    context "requesting GET :edit with good data" do
      setup do
        get :edit, :id => @user.perishable_token
      end

      should respond_with(:success)
      should render_template("edit")
      should render_with_layout("login")

      should_not set_the_flash()
    end

    context "requesting PUT :update with bad data" do
      setup do
        put :update, :id => @user.perishable_token, :user => {:password => 'test', :password_confirmation => 'tes'}
      end

      should respond_with(:success)
      should render_template("edit")
      should render_with_layout("login")
    end

    context "requesting PUT :update with good data" do
      setup do
        put :update, :id => @user.perishable_token, :user => {:password => 'test2958', :password_confirmation => 'test2958'}
      end

      should respond_with(:redirect)
      should redirect_to("login root") { root_back_path }

      should be_logged_in
    end
  end
end
