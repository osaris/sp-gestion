require 'test_helper'

class VehiclesControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
    end

    context "requesting GET :index" do
      setup do
        get :index
      end

      should respond_with(:success)
      should render_template("index")
      should render_with_layout("back")

      should assign_to(:vehicles)
    end

    context "requesting GET :show for a non existing vehicle" do
      setup do
        get :show, :id => -1
      end

      should respond_with(:redirect)
      should redirect_to(":index") { vehicles_path }

      should set_the_flash.level(:error)
    end

    context "requesting GET :new" do
      setup do
        get :new
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with bad data" do
      setup do
        post :create, :vehicle => {:name => ''}
      end

      should respond_with(:success)
      should render_template("new")
      should render_with_layout("back")
    end

    context "requesting POST :create with good data" do
      setup do
        post :create, :vehicle => plan(Vehicle.make)
      end

      should respond_with(:redirect)
      should redirect_to("vehicle") { vehicle_path(assigns(:vehicle)) }

      should assign_to(:vehicle)
      should set_the_flash.level(:success)
    end

    context "with an existing vehicle" do
      setup do
        @vehicle = @station.vehicles.make!
      end

      context "requesting GET :show on existing vehicle" do
        setup do
          get :show, :id => @vehicle.id
        end

        should respond_with(:success)
        should render_template("show")
        should render_with_layout("back")
      end

      context "requesting GET :edit" do
        setup do
          get :edit, :id => @vehicle.id
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with bad data" do
        setup do
          put :update, :id => @vehicle.id, :vehicle => {:name => ''}
        end

        should respond_with(:success)
        should render_template("edit")
        should render_with_layout("back")
      end

      context "requesting PUT :update with good data" do
        setup do
          put :update, :id => @vehicle.id, :vehicle => plan(Vehicle.make)
        end

        should respond_with(:redirect)
        should redirect_to("vehicle") { vehicle_path(assigns(:vehicle)) }

        should set_the_flash.level(:success)
      end

      context "requesting DELETE :destroy without association" do
        setup do
          delete :destroy, :id => @vehicle.id
        end

        should redirect_to("vehicles list") { vehicles_path }

        should set_the_flash.level(:success)
      end

      context "requesting DELETE :destroy with association" do
        setup do
          stub.instance_of(Vehicle).destroy { false }
          stub.instance_of(Vehicle).errors.stub!.full_messages { ["erreur"] }
          delete :destroy, :id => @vehicle.id
        end

        should redirect_to("vehicle") { vehicle_path(assigns(:vehicle)) }

        should set_the_flash.level(:error)
      end
    end
  end
end