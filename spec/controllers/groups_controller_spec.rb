require 'rails_helper'

describe GroupsController do

  setup(:activate_authlogic)

  describe "an user logged in and owner" do

    let(:user) { create(:user_confirmed) }

    before(:each) do
      login(create(:station, :owner_id => user.id), user)
    end

    let(:group) { create(:group, :station => @station) }

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { expect(assigns(:groups)).to_not be_nil}
    end

    describe "GET :show for a non existing group" do

      before(:each) do
        get :show, :params => { :id => -1 }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(groups_path) }

      it { should set_flash[:error] }
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
        post :create, :params => { :group => {:name => ''} }
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do

      before(:each) do
        post :create, :params => { :group => attributes_for(:group) }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(group_path(assigns(:group))) }

      it { expect(assigns(:group)).to_not be_nil}
      it { should set_flash[:success] }
    end

    describe "GET :show on existing group" do

      before(:each) do
        get :show, :params => { :id => group.id }
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should render_with_layout("back") }
    end

    describe "GET :edit" do

      before(:each) do
        get :edit, :params => { :id => group.id }
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with bad data" do

      before(:each) do
        patch :update, :params => { :id => group.id, :group => {:name => ''} }
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with good data" do

      before(:each) do
        patch :update, :params => { :id => group.id, :group => attributes_for(:group) }
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(group_path(assigns(:group))) }

      it { should set_flash[:success] }
    end

    describe "DELETE :destroy" do

      before(:each) do
        delete :destroy, :params => { :id => group.id }
      end

      it { should redirect_to(groups_path) }

      it { should set_flash[:success] }
    end
  end
end
