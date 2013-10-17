# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CheckListsController do

  setup(:activate_authlogic)

  context "an user logged in" do
    before(:each) do
      login
    end

    let(:check_list) { @station.check_lists.make! }

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { expect(assigns(:check_lists)).to_not be_nil }
    end

    describe "GET :show for a non existing check-list" do

      before(:each) do
        get :show, :id => -1
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(check_lists_path) }

      it { should set_the_flash.level(:error) }
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
        post :create, :check_list => {:title => ''}
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do

      before(:each) do
        post :create, :check_list => plan(CheckList.make)
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(check_list_path(assigns(:check_list))) }

      it { expect(assigns(:check_list)).to_not be_nil }
      it { should set_the_flash.level(:success) }
    end

    describe "GET :show on existing check_list" do

      before(:each) do
        get :show, :id => check_list.id
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should render_with_layout("back") }
    end

    describe "GET :show on existing check_list with PDF format" do

      before(:each) do
        @request.env["SERVER_PROTOCOL"] = "http"
        get :show, :id => check_list.id, :format => 'pdf'
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it "send a file" do
        send_file_to_disk(@response.body, "check_list.pdf")
      end
    end

    describe "GET :edit" do

      before(:each) do
        get :edit, :id => check_list.id
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with bad data" do

      before(:each) do
        patch :update, :id => check_list.id, :check_list => {:title => ''}
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with good data" do

      before(:each) do
        patch :update, :id => check_list.id, :check_list => plan(CheckList.make)
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(check_list_path(assigns(:check_list))) }
      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy" do

      before(:each) do
        delete :destroy, :id => check_list.id
      end

      it { should redirect_to(check_lists_path) }

      it { should set_the_flash.level(:success) }
    end

    describe "POST :copy" do

      before(:each) do
        post :copy, :id => check_list.id
      end

      it { should redirect_to(check_lists_path) }

      it { should set_the_flash.level(:success) }
    end
  end
end
