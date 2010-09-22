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

      should_redirect_to("back home") { root_back_url }
    end
  end

  context "a station with a logo" do
    setup do
      @user = User.make(:confirmed)
      login(Station.make(:logo, :owner_id => @user.id), @user)
    end

    context "requesting PUT :update_logo with remove logo" do
      setup do
        put :update_logo, :station => { :remove_logo => '1' }
      end

      should "delete logo station" do
        assert(!assigns(:station).reload.logo?)
      end

      should_set_the_flash(:success)
    end
  end

  context "an user logged in and station owner" do
    setup do
      @user = User.make(:confirmed)
      login(Station.make(:owner_id => @user.id), @user)
    end

    should "not have a station logo" do
      assert(!@station.logo?)
    end

    context "requesting GET :edit" do
      setup do
        get :edit
      end

      should_respond_with(:success)
      should_render_template("edit")
      should_render_with_layout("back")

      should_assign_to(:users)
    end

    context "requesting PUT :update_logo with good logo" do
      setup do
        logo = fixture_file_upload('/uploads/logo/logo.png', 'image/png')
        put :update_logo, :station => { :logo => logo }
      end

      should "add logo to station" do
        assert(assigns(:station).reload.logo?)
      end

      should_set_the_flash(:success)
    end

    context "requesting PUT :update_logo with bad logo" do
      setup do
        logo = fixture_file_upload('/uploads/logo/logo.txt', 'text/plain')
        put :update_logo, :station => { :logo => logo }
      end

      should "not add logo to station" do
        assert(!assigns(:station).reload.logo?)
      end

      should_set_the_flash(:error)
    end

    context "requesting PUT :update_owner with good data" do
      setup do
        Station.any_instance.stubs(:update_owner).returns(true)
        put :update_owner, :station => { :owner_id => '' }
      end

      should_redirect_to("back home") { root_back_url }

      should_set_the_flash(:success)
    end

    context "requesting PUT :update_owner with bad data" do
      setup do
        Station.any_instance.stubs(:update_owner).returns(false)
        put :update_owner, :station => { :owner_id => '' }
      end

      should_redirect_to("back home") { root_back_url }

      should_set_the_flash(:error)
    end

    context "requesting DELETE :destroy" do
      setup do
        delete :destroy
      end

      should_redirect_to("bye page") { "http://www.test.local/bye" }
      should_change("number of stations", :by => -1) { Station.count }
    end
  end
end
