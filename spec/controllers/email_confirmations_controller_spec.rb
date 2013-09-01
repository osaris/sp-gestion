# -*- encoding : utf-8 -*-
require 'spec_helper'

describe EmailConfirmationsController do

  let(:station) { Station.make! }

  context "a station subdomain with a user who asked for an email change" do

    let(:user) { User.make!(:confirmed, :station => station, :new_email => 'new_email@test.com') }

    before(:each) do
      @request.host = "#{station.url}.test.local"
    end

    describe "GET :edit" do

      before(:each) do
        get :edit, :id => user.perishable_token
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("login") }
    end

    describe "PUT :update with bad password" do

      before(:each) do
        put :update, :id => user.perishable_token,
                     :user_session => { :email => user.email,
                                        :new_email => user.new_email,
                                        :password => '' }
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("login") }

      it { should set_the_flash.level(:error).now }
    end

    describe "PUT :update with good password" do

      before(:each) do
        put :update, :id => user.perishable_token,
                     :user_session => { :email => user.email,
                                        :new_email => user.new_email,
                                        :password => 'test1234' }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(profile_path) }

      it { should set_the_flash.level(:success) }
    end

    describe "PUT :update with good password but new_email already used" do

      before(:each) do
        user.new_email = User.make!(:confirmed, :station => station).email
        user.save

        put :update, :id => user.perishable_token,
                     :user_session => { :email => user.email,
                                        :new_email => user.new_email,
                                        :password => 'test1234' }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }

      it { should set_the_flash.level(:error).now }
    end
  end

  context "a station subdomain with a user who never asked for an email change" do

    let(:user) { User.make!(:confirmed, :station => station, :new_email => '') }

    before(:each) do
      @request.host = "#{station.url}.test.local"
    end

    describe "GET :edit" do

      before(:each) do
        get :edit, :id => user.perishable_token
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end
  end
end
