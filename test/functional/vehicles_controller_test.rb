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

      should_respond_with(:success)
      should_render_template("index")
      should_render_with_layout("back")
      
      should_assign_to(:vehicles)
    end    
    
    context "requesting GET :show for a non existing vehicle" do
      setup do
        get :show, :id => rand(10)
      end
      
      should_respond_with(:redirect)
      should_redirect_to(":index") { vehicles_path }

      should_set_the_flash(:error)
    end    
        
    context "requesting GET :new" do
      setup do
        get :new
      end

      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
    end
    
    context "requesting POST :create with bad data" do
      setup do
        post :create, :vehicle => {:name => ''}
      end
    
      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
      
      should_not_change("number of vehicles") { Vehicle.count }
    end   
    
    context "requesting POST :create with good data" do
      setup do
        post :create, :vehicle => Vehicle.plan
      end
    
      should_respond_with(:redirect)
      should_redirect_to("vehicle") { vehicle_path(assigns(:vehicle)) }
      
      should_assign_to(:vehicle)
      should_change("number of vehicle", :by => 1) { Vehicle.count }
      should_set_the_flash(:success)
    end    
    
    context "with an existing vehicle" do
      setup do
        @vehicle = @station.vehicles.make
      end
  
      context "requesting GET :show on existing vehicle" do
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
      
      context "requesting PUT :update with bad data" do
        setup do
          put :update, :id => @vehicle.id, :vehicle => {:name => ''}
        end
  
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end  
      
      context "requesting PUT :update with good data" do
        setup do
          put :update, :id => @vehicle.id, :vehicle => Vehicle.plan
        end
  
        should_respond_with(:redirect)
        should_redirect_to("vehicle") { vehicle_path(assigns(:vehicle)) }

        should_set_the_flash(:success)
      end       
      
      context "requesting DELETE :destroy without association" do
        setup do
          delete :destroy, :id => @vehicle.id
        end
        
        should_redirect_to("vehicles list") { vehicles_path }
        
        should_change("number of vehicles", :by => -1) { Vehicle.count }
        should_set_the_flash(:success)
      end
      
      context "requesting DELETE :destroy with association" do
        setup do
          Vehicle.any_instance.stubs(:destroy).returns(false)
          # because there is no stub_chain for any_instance in mocha
          Vehicle.any_instance.stubs(:errors).returns(mock(:full_messages => ["erreur"]))
          delete :destroy, :id => @vehicle.id          
        end

        should_redirect_to("vehicle") { vehicle_path(assigns(:vehicle)) }
        
        should_not_change("number of vehicle") { Vehicle.count }
        should_set_the_flash(:error)
      end
    end
  end
end