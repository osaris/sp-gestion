# -*- encoding : utf-8 -*-
require 'spec_helper'

describe VehiclesController do

  setup(:activate_authlogic)

  describe "an user logged in" do
    before(:each) do
      login
    end

    let(:vehicle) { @station.vehicles.make! }

    describe "GET :index" do

      before(:each) do
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template("index") }
      it { should render_with_layout("back") }

      it { should assign_to(:vehicles) }
    end

    describe "GET :show for a non existing vehicle" do

      before(:each) do
        get :show, :id => -1
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(vehicles_path) }

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
        post :create, :vehicle => {:name => ''}
      end

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { should render_with_layout("back") }
    end

    describe "POST :create with good data" do

      before(:each) do
        post :create, :vehicle => plan(Vehicle.make)
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(vehicle_path(assigns(:vehicle))) }

      it { should assign_to(:vehicle) }
      it { should set_the_flash.level(:success) }
    end

    describe "GET :show on existing vehicle" do

      before(:each) do
        get :show, :id => vehicle.id
      end

      it { should respond_with(:success) }
      it { should render_template("show") }
      it { should render_with_layout("back") }
    end

    describe "GET :edit" do

      before(:each) do
        get :edit, :id => vehicle.id
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PUT :update with bad data" do

      before(:each) do
        put :update, :id => vehicle.id, :vehicle => {:name => ''}
      end

      it { should respond_with(:success) }
      it { should render_template("edit") }
      it { should render_with_layout("back") }
    end

    describe "PUT :update with good data" do

      before(:each) do
        put :update, :id => vehicle.id, :vehicle => plan(Vehicle.make)
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(vehicle_path(assigns(:vehicle))) }

      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy without association" do

      before(:each) do
        delete :destroy, :id => vehicle.id
      end

      it { should redirect_to(vehicles_path) }

      it { should set_the_flash.level(:success) }
    end

    describe "DELETE :destroy with associations" do

      before(:each) do
        allow_any_instance_of(Vehicle).to receive(:interventions).and_return(double(:empty? => false))

        delete :destroy, :id => vehicle.id
      end

      it { should redirect_to(vehicle_path(assigns(:vehicle))) }

      it { should set_the_flash.level(:error) }
    end
  end
end
