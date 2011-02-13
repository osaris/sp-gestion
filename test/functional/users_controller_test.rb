require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in and station owner" do
    setup do
      @user = User.make!(:confirmed)
      login(Station.make!(:owner_id => @user.id), @user)
    end

    context "requesting GET :index" do
      setup do
        get :index
      end

      should respond_with(:success)
      should render_template("index")
      should render_with_layout("back")

      should assign_to(:users)
    end

    context "requesting GET :new" do
      setup do
        get :new
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with bad data" do
      setup do
        post :create, :user => { :email => '' }
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with good data" do
      setup do
        post :create, :user => { :email => 'raphael.emourgeon@gmail.com' }
      end

      should respond_with(:redirect)
      should redirect_to("users") { users_path }

      should set_the_flash.level(:success)
    end

    context "requesting DELETE :destroy of account owner (current user)" do
      setup do
        delete :destroy, :id => @user.id
      end

      should respond_with(:redirect)
      should redirect_to("users") { users_path }

      should set_the_flash.level(:warning)
    end

    context "with another user not owner" do
      setup do
        @another_user = User.make!(:confirmed, :station => @station)
      end

      context "requesting DELETE :destroy for a non existing user" do
        setup do
          delete :destroy, :id => -1
        end

        should respond_with(:redirect)
        should redirect_to(":index") { users_path }

        should set_the_flash.level(:error)
      end

      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :id => @another_user.id
        end

        should respond_with(:redirect)
        should redirect_to("users") { users_path }

        should set_the_flash.level(:success)
      end
    end
  end
end
