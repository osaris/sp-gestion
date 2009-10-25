require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "a station subdomain" do
    setup do
      @station = Station.make(:url => 'cis-test')
      @request.host = 'cis-test.sp-gestion.fr'      
    end

    context "requesting GET :new" do
      setup do
        get :new
      end

      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("login")
    end
        
    context "with a user" do
      setup do
        @user = @station.users.make(:confirmed)
      end
      
      context "requesting POST :create with bad data" do
        setup do
          post :create, :user => {:login => 'test', :password => 'pass'}
        end

        should_respond_with(:success)
        should_render_template("new")
        should_render_with_layout("login")

        should_not_be_logged_in
        should_set_the_flash(:error)
      end      
      
      context "requesting POST :create with good data" do
        setup do
          post :create, :user_session => {:email => @user.email, :password => 'test1234'}
        end

        should_respond_with(:redirect)
        should_redirect_to("app root") { root_back_path }
        should_be_logged_in
      end
      
      context "requesting DELETE :destroy not logged in" do
        setup do
          delete :destroy
        end

        should_respond_with(:redirect)
        should_redirect_to("login page") { login_path }
        
        should_not_be_logged_in
      end      
      
      context "requesting DELETE :destroy logged in" do
        setup do
          UserSession.create(@user)
          delete :destroy
        end
        
        should_respond_with(:redirect)
        should_redirect_to("login page") { login_path }
        
        should_not_be_logged_in
        should_set_the_flash(:notice)
      end      
    end
  end
end
