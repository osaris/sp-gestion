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

      context "requesting GET :edit with good confirmation code" do
        setup do
          get :edit, :id => @user.perishable_token
        end

        should_respond_with(:redirect)
        should_redirect_to("login form") { login_path }
        should_set_the_flash(:error)
      end
    end

    context "with an inactive user on this subdomain" do
      setup do
        @user = @station.users.make
      end

      context "requesting GET :edit with good confirmation code" do
        setup do
          get :edit, :id => @user.perishable_token
        end

        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("login")
      end

      context "requesting POST :update with bad password" do
        setup do
          post :update, :id => @user.perishable_token, :user => {:password => '123',
                                                                 :password_confirmation => ''}
        end

        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("login")
      end

      context "requesting POST :update with good password" do
        setup do
          post :update, :id => @user.perishable_token, :user => {:password => '123456',
                                                                 :password_confirmation => '123456'}
        end

        should_respond_with(:redirect)
        should_redirect_to("back root") { root_back_path }
        should "be active" do
          assert(assigns(:user).confirmed?)
        end
        should_be_logged_in
      end
    end
  end
end
