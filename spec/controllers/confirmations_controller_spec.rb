# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ConfirmationsController do

  context "a station subdomain" do

    let(:station) { Station.make!(:url => 'cis-test') }

    before(:each) do
      @request.host = 'cis-test.sp-gestion.fr'
    end

    context "with an active user on this subdomain" do

      let(:user) { User.make!(:confirmed, :station => station) }

      describe "GET :edit with good confirmation code" do

        before(:each) do
          get :edit, :id => user.perishable_token
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(login_path) }
        it { should set_the_flash.level(:error) }
      end
    end

    context "with an inactive user on this subdomain" do

      let(:user) { User.make!(:station => station) }

      describe "GET :edit with good confirmation code" do

        before(:each) do
          get :edit, :id => user.perishable_token
        end

        it { should respond_with(:success) }
        it { should render_template("edit") }
        it { should render_with_layout("login") }
      end

      describe "POST :update with bad password" do

        before(:each) do
          post :update, :id => user.perishable_token,
                        :user => {:password => '123',
                                  :password_confirmation => ''}
        end

        it { should respond_with(:success) }
        it { should render_template("edit") }
        it { should render_with_layout("login") }
      end

      describe "POST :update with good password" do

        before(:each) do
          post :update, :id => user.perishable_token,
                        :user => {:password => '123456',
                                  :password_confirmation => '123456'}
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(root_back_path) }
        it "is active" do
          assert(assigns(:user).confirmed?)
        end
        it { should be_logged_in }
      end
    end
  end
end
