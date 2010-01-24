require 'test_helper'

class ConfirmationsControllerTest < ActionController::TestCase

  context "a station subdomain" do
    setup do
      @station = Station.make(:url => 'cis-test')
      @request.host = 'cis-test.sp-gestion.fr'
    end

    context "with an active user on this subdomain" do
      setup do
        @user = @station.users.make(:confirmed)
      end

      context "which GET :create with good confirmation code" do
        setup do
          get :create, :id => @user.perishable_token
        end

        should_respond_with(:redirect)
        should_redirect_to("login form") { login_path }
        should_set_the_flash(:error)
      end
    end
    
    context "with an inactive user on this subdomain" do
      setup do
        @user = @station.users.make(:beta)
      end
      
      context "which GET :create with good confirmation code" do
        setup do
          get :create, :id => @user.perishable_token
        end

        should_respond_with(:redirect)
        should_redirect_to("back root") { root_back_path }
        
        should "be active" do        
          assert(assigns(:user).confirmed?)
        end        
        should_be_logged_in
        should_set_the_flash(:success)
      end
    end
  end
end
