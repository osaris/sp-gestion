require 'test_helper'

class VehiclesControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do
      login
    end
    
    context "requesting index" do
      setup do
        get :index
      end

      should_respond_with(:success)
      should_render_template("index")
      should_render_with_layout("back")
      
      should_assign_to(:vehicles)
    end    
    
    context "requesting a non existing vehicle" do
      setup do
        get :show, :id => rand(10)
      end
      
      should_respond_with(:redirect)
      should_redirect_to(":index") { vehicles_path }      
    end    
        
    context "requesting GET :new" do
      setup do
        get :new
      end

      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
    end
    
    context "requesting POST with bad data" do
      setup do
        post :create, :vehicle => {:name => ''}
      end
    
      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
      
      should_not_change("number of vehicles") { Vehicle.count }
    end   
    
    context "requesting POST with good data" do
      setup do
        post :create, :vehicle => Vehicle.plan
      end
    
      should_respond_with(:redirect)
      should_redirect_to("vehicle") { vehicle_path(assigns(:vehicle)) }
      
      should_assign_to(:vehicle)
      should_change("number of vehicle", :by => 1) { Vehicle.count }
    end    
    
    context "with an existing vehicle" do
      setup do
        @vehicle = @station.vehicles.make
      end
  
      context "requesting GET on existing vehicle" do
        setup do
          get :show, :id => @vehicle.id
        end
  
        should_respond_with(:success)
        should_render_template("show")
        should_render_with_layout("back")
      end
      
      context "requesting GET :edit" do
        setup do
          get :edit, :id => @vehicle.id
        end
  
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end  
      
      context "requesting PUT with bad data" do
        setup do
          put :update, :id => @vehicle.id, :vehicle => {:name => ''}
        end
  
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end  
      
      context "requesting PUT with good data" do
        setup do
          put :update, :id => @vehicle.id, :vehicle => Vehicle.plan
        end
  
        should_respond_with(:redirect)
        should_redirect_to("vehicle") { vehicle_path(assigns(:vehicle)) }
      end       
      
      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :id => @vehicle.id
        end
        
        should_redirect_to("vehicles list") { vehicles_path }
        
        should_change("number of vehicles", :by => -1) { Vehicle.count }
      end
    end
  end
end
