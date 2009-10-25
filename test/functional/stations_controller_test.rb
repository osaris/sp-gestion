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
      post :create, :station => Station.plan, :user => User.plan
    end
    
    should_respond_with(:success)
    should_render_template("create")
    should_render_with_layout("front")    
  end
  
  
end
