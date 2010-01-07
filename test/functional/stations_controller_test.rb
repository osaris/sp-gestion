require 'test_helper'

class StationsControllerTest < ActionController::TestCase

  context "requesting GET :new" do
    setup do
      get :new
    end

    should_respond_with(:success)
    should_render_template("new")
    should_render_with_layout("front")
  end
  
  context "requesting POST :create with bad data" do
    setup do
      post :create, :station => {:name => 'test', :url => 'él3 ek'}, 
                    :user => {:email => 'raphael', :password => '213', :password_confirmation => '123'}
    end

    should_respond_with(:success)
    should_render_template("new")
    should_render_with_layout("front")
  end
  
  context "requesting POST :create with good data" do
    setup do
      post :create, :station => Station.plan, :user => User.plan(:beta_code => BetaCode.make.code)
    end
    
    should_respond_with(:success)
    # FIXME assert_template is broken when using render_to_string
    # http://dev.rubyonrails.org/ticket/8990
    # should_render_template("create")
    should_render_with_layout("front")
    
    should "add a message to the default user" do
      assert_equal(1, assigns(:user).messages.length)
    end
  end

  context "requesting GET :check with existing station" do
    setup do
      Station.stubs(:find).returns(Station.plan)
      get :check, :name => 'test'
    end

    should_respond_with(:success)
    should_render_template("check")
    should_render_without_layout

    should_assign_to(:station)
    should "show name_warning" do
      assert_select_rjs(:show, '#name_warning')
    end
  end

   context "requesting GET :check with non existing station" do
    setup do
      get :check, :name => 'test'
    end

    should_respond_with(:success)
    should_render_template("check")
    should_render_without_layout

    should "have station set to nil" do
      assert(assigns(:station).nil?)
    end
    should "hide name_warning" do
      assert_select_rjs(:hide, '#name_warning')
    end
  end
  
end
