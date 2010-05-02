require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in and station owner" do
    setup do
      @user = User.make(:confirmed)
      login(Station.make(:owner_id => @user.id), @user)
    end
    
    context "requesting GET :index" do
      setup do
        get :index
      end

      should_respond_with(:success)
      should_render_template("index")
      should_render_with_layout("back")
      
      should_assign_to(:users)
    end
    
    context "requesting GET :new" do
      setup do
        get :new
      end

      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
    end
    
    context "requesting POST :create with bad data" do
      setup do
        post :create, :user => { :email => '' }
      end
    
      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
      
      should_not_change("number of users") { User.count }
    end   
    
    context "requesting POST :create with good data" do
      setup do
        post :create, :user => { :email => 'raphael.emourgeon@gmail.com' }
      end
    
      should_respond_with(:redirect)
      should_redirect_to("users") { users_path }
      
      should_change("number of users", :by => 1) { User.count }
      should_set_the_flash(:success)
    end
    
    context "requesting DELETE :destroy of account owner (current user)" do
      setup do
        delete :destroy, :id => @user.id
      end
      
      should_respond_with(:redirect)
      should_redirect_to("users") { users_path }
      
      should_set_the_flash(:warning)
    end
    
    context "with another user not owner" do
      setup do
        @another_user = @station.users.make(:confirmed)
      end

      context "requesting DELETE :destroy for a non existing user" do
        setup do
          delete :destroy, :id => rand(10)
        end

        should_respond_with(:redirect)
        should_redirect_to(":index") { users_path }

        should_set_the_flash(:error)
      end

      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :id => @another_user.id
        end

        should_respond_with(:redirect)
        should_redirect_to("users") { users_path }

        should_change("number of users", :by => -1) { User.count }
        should_set_the_flash(:success)
      end
    end
  end
end
