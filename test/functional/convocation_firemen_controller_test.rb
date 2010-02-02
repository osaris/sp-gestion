require 'test_helper'

class ConvocationFiremenControllerTest < ActionController::TestCase

  setup(:activate_authlogic)

  context "an user logged in" do
    setup do    
      login
    end
        
    context "requesting GET :edit on non existing convocation" do
      setup do
        get :edit_all, :convocation_id => 10
      end
      
      should_respond_with(:redirect)
      should_redirect_to("convocations") { convocations_path }

      should_set_the_flash(:error)
    end
    
    context "with an existing convocation" do
      setup do
        @convocation = make_convocation_with_firemen(:station => @station)
      end
      
      context "requesting GET :edit on existing convocation" do
        setup do
          get :edit_all, :convocation_id => @convocation.id
        end
        
        should_respond_with(:success)
        should_render_template("edit")
        should_render_with_layout("back")
        
        should_assign_to(:convocation)
        should_assign_to(:convocation_firemen)        
      end

      context "requesting GET on existing convocation_fireman with PDF format" do
        setup do
          @request.env["SERVER_PROTOCOL"] = "http"
          get :show, :convocation_id => @convocation.id, :id => @convocation.convocation_firemen.first.id, :format => 'pdf'
        end

        should_respond_with(:success)
        should_render_template("show")
        should "send a file" do
          send_file_to_disk(@response.body, "convocation_unique.pdf")
        end
      end
      
      context "requesting PUT" do
        setup do
          convocation_firemen_id = @convocation.convocation_firemen.first.id
          post :update_all, :convocation_id => @convocation.id, :convocation_firemen => { convocation_firemen_id.to_s => {:presence => 1 }}
        end

        should_respond_with(:redirect)
        should_redirect_to("convocation") { convocation_path(assigns(:convocation)) }
        
        should_assign_to(:convocation)
        should "set the presence of firemen" do
          assert(@convocation.convocation_firemen.first.presence)
        end
        should_set_the_flash(:success)
      end
    end    
  end
end