require 'test_helper'

class InterventionsControllerTest < ActionController::TestCase
  
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
      
      should_assign_to(:interventions)
    end
    
    context "requesting a non existing intervention" do
      setup do
        get :show, :id => 2458437589
      end
      
      should_respond_with(:redirect)
      should_redirect_to(":index") { interventions_path }

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
    
    context "requesting POST with bad data" do
      setup do
        post :create, :intervention => {:place => '', :kind => '', :start_date => '', :end_date => ''}
      end
    
      should_respond_with(:success)
      should_render_template("new")
      should_render_with_layout("back")
      
      should_not_change("number of interventions") { Intervention.count }
    end
    
    context "requesting POST with good data" do
      setup do
        post :create, :intervention => Intervention.plan
      end
    
      should_respond_with(:redirect)
      should_redirect_to("intervention") { intervention_path(assigns(:intervention)) }
      
      should_assign_to(:intervention)
      should_change("number of interventions", :by => 1) { Intervention.count }
      should_set_the_flash(:success)
    end
    
    context "with an existing intervention" do
      setup do
        @intervention = @station.interventions.make
      end

      context "requesting GET" do
        setup do
          get :show, :id => @intervention.id
        end
  
        should_respond_with(:success)
        should_render_template("show")
        should_render_with_layout("back")
      end
      
      context "requesting GET :edit" do
        setup do
          get :edit, :id => @intervention.id
        end
  
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end  
      
      context "requesting PUT with bad data" do
        setup do
          put :update, :id => @intervention.id, :intervention => {:place => '', :kind => '', :start_date => '', :end_date => ''}
        end
        
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
      end
      
      context "requesting PUT with good data" do
        setup do
          put :update, :id => @intervention.id, :intervention => Intervention.plan
        end
  
        should_respond_with(:redirect)
        should_redirect_to("intervention") { intervention_path(assigns(:intervention)) }
  
        should_set_the_flash(:success)
      end
      
      context "requesting DELETE :destroy" do
        setup do
          delete :destroy, :id => @intervention.id
        end
        
        should_redirect_to("interventions list") { interventions_path }
        
        should_change("number of interventions", :by => -1) { Intervention.count }
        should_set_the_flash(:success)
      end
    end
  end
end
