require 'test_helper'

class AccountsControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in with but not owner of station" do
    setup do
      login
    end

    context "requesting GET :edit" do
      setup do
        get :edit
      end

      should redirect_to("back home") { root_back_url }
    end
  end

  context "a station with a logo" do
    setup do
      @user = User.make!(:confirmed)
      login(Station.make!(:logo, :owner_id => @user.id), @user)
    end

    context "requesting PUT :update_logo with remove logo" do
      setup do
        put :update_logo, :station => { :remove_logo => '1' }
      end

      should "delete logo station" do
        assert(!assigns(:station).reload.logo?)
      end

      should set_the_flash.level(:success)
    end
  end

  context "an user logged in and station owner" do
    setup do
      @user = User.make!(:confirmed)
      login(Station.make!(:owner_id => @user.id), @user)
    end

    should "not have a station logo" do
      assert(!@station.logo?)
    end

    context "requesting GET :edit" do
      setup do
        get :edit
      end

      should respond_with(:success)
      should render_template("edit")
      should render_with_layout("back")

      should assign_to(:users)
    end

    context "requesting PUT :update_logo with good logo" do
      setup do
        logo = fixture_file_upload('/uploads/logo/logo.png', 'image/png')
        put :update_logo, :station => { :logo => logo }
      end

      should "add logo to station" do
        assert(assigns(:station).reload.logo?)
      end

      should set_the_flash.level(:success)
    end

    context "requesting PUT :update_logo with bad logo" do
      setup do
        logo = fixture_file_upload('/uploads/logo/logo.txt', 'text/plain')
        put :update_logo, :station => { :logo => logo }
      end

      should "not add logo to station" do
        assert(!assigns(:station).reload.logo?)
      end

      should set_the_flash.level(:error)
    end

    context "requesting PUT :update_owner with good data" do
      setup do
        stub.instance_of(Station).update_owner.with_any_args { true }
        put :update_owner, :station => { :owner_id => '' }
      end

      should redirect_to("back home") { root_back_url }

      should set_the_flash.level(:success)
    end

    context "requesting PUT :update_owner with bad data" do
      setup do
        stub.instance_of(Station).update_owner.with_any_args { false }
        put :update_owner, :station => { :owner_id => '' }
      end

      should redirect_to("back home") { root_back_url }

      should set_the_flash.level(:error)
    end

    context "requesting DELETE :destroy" do
      setup do
        delete :destroy
      end

      should redirect_to("bye page") { "http://www.test.local/bye" }
    end
  end
end
