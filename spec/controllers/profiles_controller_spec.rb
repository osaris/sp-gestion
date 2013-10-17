require 'spec_helper'

describe ProfilesController do

  setup(:activate_authlogic)

  context "an user logged in station in demo mode" do

    before(:each) do
      login(Station.make!(:demo => true))
    end

    describe "GET :edit" do

      before(:each) do
        get :edit
      end

      it { should redirect_to(root_back_url) }

      it { should set_the_flash.level(:error) }
    end
  end

  context "an user logged in" do

    before(:each) do
      login
    end

    describe "GET :edit" do

      before(:each) do
        get :edit
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with good data" do

      before(:each) do
        patch :update, :user => { :password => '123456', :password_confirmation => '123456' }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(profile_path) }

      it { should set_the_flash.level(:success) }
    end

    describe "PATCH :update with bad data" do

      before(:each) do
        patch :update, :user => { :password => '123456', :password_confirmation => '' }
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end
  end
end
