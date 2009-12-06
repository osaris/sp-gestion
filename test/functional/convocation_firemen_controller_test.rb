require 'test_helper'

class ConvocationFiremenControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do    
      login
    end
        
    context "requesting GET :edit on non existing convocation" do
      setup do
        get :edit, :id => 10
      end
      
      should_respond_with(:redirect)
      should_redirect_to("convocations") { convocations_path }
    end
    
    context "with an existing convocation" do
      setup do
        @convocation = make_convocation_with_firemen(:station => @station)
      end
      
      context "requesting GET :edit on existing convocation" do
        setup do
          get :edit, :id => @convocation.id
        end
        
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
        
        should_assign_to(:convocation)
        should_assign_to(:convocation_firemen)        
      end
      
      context "requesting PUT" do
        setup do
          convocation_firemen_id = @convocation.convocation_firemen.first.id  
          post :update, :id => @convocation.id, :convocation_firemen => { convocation_firemen_id.to_s => {:presence => 1 }}
        end

        should_respond_with(:redirect)
        should_redirect_to("convocation") { convocation_path(assigns(:convocation)) }
        
        should_assign_to(:convocation)
        should "set the presence of firemen" do
          assert(@convocation.convocation_firemen.first.presence)
        end
      end
      
      
    end    
  end
end