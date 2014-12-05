require 'rails_helper'

describe InterventionRolesController do

  setup(:activate_authlogic)

  context "an user logged in" do

    before(:each) do
      login
    end

    let(:intervention_role) { create(:intervention_role, :station => @station) }

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { expect(assigns(:intervention_roles)).to_not be_nil}
    end

    describe "GET :show for a non existing intervention_role" do

      before(:each) do
        get :show, :id => -1
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(intervention_roles_path) }

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
        post :create, :intervention_role => {:name => '', :short_name => 'test'}
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do

      before(:each) do
        post :create, :intervention_role => attributes_for(:intervention_role)
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(intervention_role_path(assigns(:intervention_role))) }

      it { expect(assigns(:intervention_role)).to_not be_nil}
      it { should set_the_flash.level(:success) }
    end

    describe "GET :show on existing intervention_role" do

      before(:each) do
        get :show, :id => intervention_role.id
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should render_with_layout("back") }
    end

    describe "GET :edit" do

      before(:each) do
        get :edit, :id => intervention_role.id
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with bad data" do

      before(:each) do
        patch :update, :id => intervention_role.id, :intervention_role => {:name => '', :short_name => 'test'}
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PATCH :update with good data" do

      before(:each) do
        patch :update, :id => intervention_role.id, :intervention_role => attributes_for(:intervention_role)
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(intervention_role_path(assigns(:intervention_role))) }

      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy without association" do

      before(:each) do
        delete :destroy, :id => intervention_role.id
      end

      it { should redirect_to(intervention_roles_path) }

      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy with associations" do

      before(:each) do
        allow_any_instance_of(InterventionRole).to receive(:fireman_intervention).and_return(double(:empty? => false))

        delete :destroy, :id => intervention_role.id
      end

      it { should redirect_to(intervention_role_path(assigns(:intervention_role))) }

      it { should set_the_flash.level(:error) }
    end
  end
end
