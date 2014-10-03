# -*- encoding : utf-8 -*-
require 'rails_helper'

describe UsersController do

  setup(:activate_authlogic)

  context "an user logged in and owner of station in demo mode" do

    before(:each) do
      login(create(:station, :demo => true))
    end

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should redirect_to(root_back_url) }

      it { should set_the_flash.level(:error) }
    end
  end

  context "an user logged in and owner" do

    let(:user) { create(:user_confirmed) }

    before(:each) do
      login(create(:station, :owner_id => user.id), user)
    end

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { expect(assigns(:users)).to_not be_nil}
    end

    describe "GET :new" do

      before(:each) do
        get :new
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with bad data" do

      before(:each) do
        post :create, :user => { :email => '' }
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do

      before(:each) do
        post :create, :user => { :email => 'raphael.emourgeon@gmail.com' }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(users_path) }

      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy of account owner (current user)" do

      before(:each) do
        # because rspec fails on render_to_string in controller
        allow(controller).to receive(:render_to_string).with(any_args).and_return('erreur')

        delete :destroy, :id => user.id
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(users_path) }

      it { should set_the_flash.level(:warning) }
    end

    context "with another user not owner" do

      let(:another_user) { create(:user_confirmed, :station => @station) }

      describe "DELETE :destroy for a non existing user" do

        before(:each) do
          delete :destroy, :id => -1
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(users_path) }

        it { should set_the_flash.level(:error) }
      end

      describe "DELETE :destroy" do

        before(:each) do
          delete :destroy, :id => another_user.id
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(users_path) }

        it { should set_the_flash.level(:success) }
      end
    end
  end
end
