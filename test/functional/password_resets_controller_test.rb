require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase

  context "a station subdomain with a user" do
    setup do
      @station = Station.make(:url => 'cis-test')
      @user = @station.users.make(:confirmed)
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
    
    context "requesting POST :create with bad data" do
      setup do
        post :create, :email => 'test@test.com'
      end
      
      before_should "expect no mail is delivered" do
        UserMailer.expects(:deliver_password_reset_instructions).never        
      end

      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("login")
      
      should_set_the_flash(:error)
    end
    
    context "requesting POST :create with good data" do
      setup do
        post :create, :email => @user.email
      end
      
      before_should "expect one mail is delivered" do
        UserMailer.expects(:deliver_password_reset_instructions).once
      end

      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("login")
      
      should_set_the_flash(:notice)
    end
    
    context "requesting GET :edit with bad data" do
      setup do
        get :edit, :id => rand(10)
      end
      
      should_respond_with(:redirect)
      should_redirect_to("login page") { login_path }
      
      should_set_the_flash(:error)
    end
    
    context "requesting GET :edit with good data" do
      setup do
        get :edit, :id => @user.perishable_token
      end

      should_respond_with(:success)
      should_render_template("edit")
      should_render_with_layout("login")
      
      should_not_set_the_flash()
    end
    
    context "requesting PUT :update with bad data" do
      setup do
        put :update, :id => @user.perishable_token, :user => {:password => 'test', :password_confirmation => 'tes'}
      end
    
      should_respond_with(:success)
      should_render_template("edit")
      should_render_with_layout("login")
    end
    
    context "requesting PUT :update with good data" do
      setup do
        put :update, :id => @user.perishable_token, :user => {:password => 'test2958', :password_confirmation => 'test2958'}
      end
    
      should_respond_with(:redirect)
      should_redirect_to("login root") { root_back_path }
      
      should_be_logged_in
    end
  end
end
