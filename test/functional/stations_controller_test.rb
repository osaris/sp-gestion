require 'test_helper'

class StationsControllerTest < ActionController::TestCase

  context "requesting GET :new" do
    setup do
      get :new
    end

    should respond_with(:success)
    should render_template("new")
    should render_with_layout("front")
  end

  context "requesting POST :create with bad data" do
    setup do
      post :create, :station => {:name => 'test', :url => 'él3 ek'},
                    :user => {:email => 'raphael', :password => '213', :password_confirmation => '123'}
    end

    should respond_with(:success)
    should render_template("new")
    should render_with_layout("front")
  end

  context "requesting POST :create with good data" do
    setup do
      post :create, :station => plan(Station.make), :user => plan(User.make)
    end

    should respond_with(:success)
    # FIXME assert_template is broken when using render_to_string
    # http://dev.rubyonrails.org/ticket/8990
    # should_render_template("create")
    should render_with_layout("front")

    should "add a message to the default user" do
      assert_equal(1, assigns(:user).messages.length)
    end
  end

  context "requesting POST :check with existing station" do
    setup do
      stub(Station).check.with_any_args { Station.make }
      post :check, :station => { :name => 'test' }
    end

    should respond_with(:success)
    should render_template("check")
    should_not render_with_layout

    should assign_to(:station)
    should "show name_warning" do
      # FIXME assert_select_rjs is broken with Jquery and Rails3 (without jrails)
      assert_match("$(\"#name_warning\").show();", @response.body)
    end
  end

   context "requesting POST :check with non existing station" do
    setup do
      stub(Station).check.with_any_args { nil }
      post :check, :station => { :name => 'test' }
    end

    should respond_with(:success)
    should render_template("check")
    should_not render_with_layout

    should_not assign_to(:station)
    should "hide name_warning" do
      # FIXME assert_select_rjs is broken with Jquery and Rails3 (without jrails)
      assert_match("$(\"#name_warning\").hide();", @response.body)
    end
  end

end
