# -*- encoding : utf-8 -*-
require 'spec_helper'

describe PasswordResetsController do

  context "a station in demo mode" do

    let(:station) { Station.make!(:demo => true) }

    before(:each) do
      @request.host = "#{station.url}.test.local"
    end

    describe "GET :new" do

      before(:each) do
        get :new
      end

      it { should redirect_to(login_path) }

      it { should set_the_flash.level(:error) }
    end
  end

  context "a station subdomain with a user" do

    let(:station) { Station.make! }

    let(:user) { User.make!(:confirmed, :station => station) }

    before(:each) do
      @request.host = "#{station.url}.test.local"
    end

    describe "GET :new" do

      before(:each) do
        get :new
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("login") }
    end

    describe "POST :create with bad data" do

      before(:each) do
        UserMailer.any_instance.should_not_receive(:password_reset_instructions)

        post :create, :email => 'test@test.com'
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("login") }

      it { should set_the_flash.level(:error).now }
    end

    describe "POST :create with good data" do

      before(:each) do
        UserMailer.any_instance.should_receive(:password_reset_instructions)

        post :create, :email => user.email
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("login") }

      it { should set_the_flash.level(:warning).now }
    end

    describe "GET :edit with bad data" do

      before(:each) do
        get :edit, :id => -1
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }

      it { should set_the_flash.level(:error) }
    end

    describe "GET :edit with good data" do

      before(:each) do
        get :edit, :id => user.perishable_token
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("login") }

      it { should_not set_the_flash() }
    end

    describe "PUT :update with bad data" do

      before(:each) do
        put :update, :id => user.perishable_token,
                     :user => {:password => 'test',
                               :password_confirmation => 'tes'}
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("login") }
    end

    describe "PUT :update with good data" do

      before(:each) do
        put :update, :id => user.perishable_token,
                     :user => {:password => 'test2958',
                               :password_confirmation => 'test2958'}
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(root_back_path) }

      it { should be_logged_in }
    end
  end
end
