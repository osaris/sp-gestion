require 'rails_helper'

describe ItemsController do

  setup(:activate_authlogic)

  context "an user logged in with an existing check_list" do

    before(:each) do
      login
    end

    let(:check_list) { create(:check_list, :station => @station) }

    let(:item) { create(:item, :check_list => check_list) }

    describe "GET :expirings" do

      before(:each) do
        get :expirings
      end

      it { should respond_with(:success) }
      it { should render_template("expirings") }
      it { should render_with_layout("back") }

      it { expect(assigns(:items)).to_not be_nil}
      it { should set_session(:back_path) { expirings_items_path } }
    end

    describe "GET :expirings with PDF format" do

      before(:each) do
        @request.env["SERVER_PROTOCOL"] = "http"

        get :expirings, :format => 'pdf'
      end

      it { should respond_with(:success) }
      it { should render_template("expirings") }
      it "send a file" do
        send_file_to_disk(@response.body, "check_list_expiration.pdf")
      end
    end

    describe "GET :show for a non existing check_list" do

      before(:each) do
        get :show, :check_list_id => -1, :id => -1
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(check_lists_path) }

      it { should set_the_flash.level(:error) }
    end

    describe "GET :show for a non existing item on an existing check_list" do

      before(:each) do
        get :show, :check_list_id => check_list.id, :id => -1
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(check_list_path(check_list)) }

      it { should set_the_flash.level(:error) }
    end

    describe "GET :edit for a non existing check_list" do

      before(:each) do
        get :edit, :check_list_id => -1, :id => -1
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(check_lists_path) }

      it { should set_the_flash.level(:error) }
    end

    describe "GET :edit for a non existing item on an existing check_list" do

      before(:each) do
        get :edit, :check_list_id => check_list.id, :id => -1
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(check_list_path(check_list)) }

      it { should set_the_flash.level(:error) }
    end

    describe "GET :new" do

      before(:each) do
        get :new, :check_list_id => check_list.id
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with bad data" do

      before(:each) do
        post :create, :check_list_id => check_list.id, :item => {:title => ''}
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do

      before(:each) do
        post :create, :check_list_id => check_list.id,
                      :item => {:title => 'Test', :quantity => '1'}
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(check_list_item_path(assigns(:check_list),
                                              assigns(:item))) }

      it { expect(assigns(:check_list)).to_not be_nil}
      it { should set_the_flash.level(:success) }
    end

    describe "GET :show" do

      before(:each) do
        get :show, :check_list_id => check_list.id, :id => item.id
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should render_with_layout("back") }
    end

    describe "GET :edit" do

      before(:each) do
        get :edit, :check_list_id => check_list.id, :id => item.id
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with bad data" do

      before(:each) do
        patch :update, :check_list_id => check_list.id,
                     :id => item.id,
                     :item => {:title => '', :quantity => '1'}
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with good data" do

      before(:each) do
        patch :update, :check_list_id => check_list.id,
                     :id => item.id,
                     :item => {:title => 'Test', :quantity => '1'}
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(check_list_item_path(assigns(:check_list),
                                                   assigns(:item))) }

      it { should set_the_flash.level(:success) }
    end

    describe "PATCH :update with good data and back_path set to expiring" do

      before(:each) do
        session[:back_path] = expirings_items_path

        patch :update, :check_list_id => check_list.id,
                     :id => item.id,
                     :item => {:title => 'Test', :quantity => '1'}
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(expirings_items_path) }

      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy" do

      before(:each) do
        delete :destroy, :check_list_id => check_list.id, :id => item.id
      end

      it { should redirect_to(check_list_path(assigns(:check_list))) }

      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy and back_path set to expiring" do

      before(:each) do
        session[:back_path] = expirings_items_path

        delete :destroy, :check_list_id => check_list.id, :id => item.id
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(expirings_items_path) }

      it { should set_the_flash.level(:success) }
    end
  end
end
