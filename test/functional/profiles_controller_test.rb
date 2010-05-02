require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
    end
    
    context "requesting GET :edit" do
      setup do
        get :edit
      end

      should_respond_with(:success)
      should_render_template("edit")
      should_render_with_layout("back")
    end
    
    context "requesting PUT :update with good data" do
      setup do
        put :update, :user => { :password => '123456', :password_confirmation => '123456' }
      end
      
      should_respond_with(:redirect)
      should_redirect_to("profile") { profile_path }
      
      should_set_the_flash(:success)
    end
    
    context "requesting PUT :update with bad data" do
      setup do
        put :update, :user => { :password => '123456', :password_confirmation => '' }
      end

      should_respond_with(:success)
      should_render_template("edit")
      should_render_with_layout("back")
    end
  end
end
